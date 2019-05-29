;========================================
;Start Up
;==============================================================
;----------#Directives----------
#NoEnv
#Persistent
#SingleInstance, Force

;----------Used to correctly locate where to click or something----------
CoordMode, Pixel, Relative
CoordMode, Mouse, Relative

;----------Searches Hidden Windows----------
DetectHiddenWindows, On

;----------Set Global Variable----------
global Speed, StatusText
Speed = 3

;----------Displays Status GUI----------
Gui St: -Caption -Border +AlwaysOnTop +LastFound
WinSet Transparent, 245
Gui St: Color, 20252d
Gui St: Font, Segoe UI
Gui St: Font, s8 cc3c4c6 Normal
Gui St: Add, Text, BackgroundTrans x0 y0 w120 h20 0x200 vMovePos gGuiMove
Gui St: Add, Text, BackgroundTrans x3 y3 w120 h20 vStatusText, Not Running
WinSet Region, 0-0 w120 h20 r6-6
Gui St: Show, x0 y0, StatusMeWin

;----------Set Menu Tray----------
Menu, Tray, NoStandard
Menu, Tray, Add, &Pause, ButtonPause
Menu, Tray, Add, &Reload, ButtonReload
Menu, Tray, Add, &Exit, ButtonExit

;----------Make GUI Invisible, Keep button visible----------
Gui Inv: +LastFound +AlwaysOnTop
IdInv := WinExist()
Gui Inv: -dpiscale -Caption -Border
Gui Inv: Color, White
Gui Inv: Add, Button, x221 y221 w60 h60 vMoveButton gClicked HWNDClickMe, click me
Gui Inv: Show, w500 h500, ClickMeWin
WinSet, TransColor, White, ahk_id %IdInv%
OnMessage(0x200,"MoveButton")
Return

;========================================
;Button Move Function
;==============================================================
;----------Action for when mouse moves over GUI----------
MoveButton() { 
SetTimer, WindowSnap, Off
If A_Gui<=0
{
	Return
}
	{
	Random, X, 0, 440
	Random, Y, 0, 440
	GuiControl, Move, MoveButton, x%X% y%Y%
	}
}
Return

;========================================
;Speed Change
;==============================================================
;----------Displays GUI to change Mouse Move Speed----------
^m::
SetTimer, WindowSnap, Off
GuiControl, St:, StatusText, Load SetSpeedGUI
Gui Help: Destroy
Gui Spd: Destroy
Gui Spd: -Caption -Border
Gui Spd: Add, Text, x0 y0 w100 h20 Center BackgroundTrans 0x200 gGuiMove
Gui Spd: Add, Text, Center BackgroundTrans x10 y10 w80 h20, Move Speed
Gui Spd: Add, Edit, x10 y+0 w80 h20
Gui Spd: Add, UpDown, vSpeed Range0-20, %Speed%
Gui Spd: Add, Button, x20 y+6 w60 h20 gSetSpeed, Confirm
Gui Spd: Show, x100 y100 w100 h85
Return

;========================================
;Help
;==============================================================
;----------Displays Help GUI----------
^h::
SetTimer, WindowSnap, Off
GuiControl, St:, StatusText, Load HelpGUI
Gui Spd: Destroy
Gui Help: Destroy
Gui Help: -Caption -Border
Gui Help: Font, Bold
Gui Help: Add, Text, x0 y0 w120 h150 Center BackgroundTrans 0x200 gGuiMove
Gui Help: Add, Text, Center BackgroundTrans x10 y5 w100 h20, Hotkeys
Gui Help: Font, Normal
Gui Help: Add, Text, Center BackgroundTrans x10 y+0 w100 h20, Ctrl+T: Toggle
Gui Help: Add, Text, Center BackgroundTrans x10 y+0 w100 h20, Ctrl+M: Speed
Gui Help: Add, Text, Center BackgroundTrans x10 y+0 w100 h20, Ctrl+H: Help
Gui Help: Add, Text, Center BackgroundTrans x10 y+0 w100 h20, Ctrl+P: Pause
Gui Help: Add, Text, Center BackgroundTrans x10 y+0 w100 h20, Ctrl+R: Reload
Gui Help: Add, Text, Center BackgroundTrans x10 y+0 w100 h20, Ctrl+Q: Exit
Gui Help: Add, Button, x30 y+5 w60 h20 gCloseHelp, Close
Gui Help: Show, x100 y100 w120 h175
Return

;========================================
;Click Bot
;==============================================================
;----------Activates the invisible GUI and Toggles the Bot----------
^t::
SetTimer, WindowSnap, Off
WinActivate ClickMeWin
SetTimer, ClickLoop, 0
Return

ClickLoop:
If WinActive("ClickMeWin") {
MouseGetPos, MoveX1, MoveY1
Sleep 20
MouseGetPos, MoveX2, MoveY2
    If ((MoveX1 <> MoveX2) or (MoveY1 <> MoveY2)) {
        GuiControl, St:, StatusText, Mouse Moved, Paused
        Sleep 10000
        }
    Else {
        ControlGetPos, X, Y,,,, % "ahk_id" . ClickMe
        ;----------Use below for random movement!----------
        ;Random, RX, 3, 57
        ;Random, RY, 3, 57
        ;Random, Speed, 5, 10
        X += 29 ;Replace with %RX%
        Y += 29 ;Replace with %RY%
        MouseMove, %X%, %Y%, %Speed%
        ;----------Click instead of Move----------
        ;MouseClick, Left, %X%, %Y%, 1, 0
        ;----------Status Text----------
        CoordMode, Mouse, Screen
        MouseGetPos, MX, MY
        GuiControl, St:, StatusText, Clicking X%MX% Y%MY%
    }
}
Return

;========================================
;Window Snap - Still Buggy :c
;==============================================================
WindowSnap:
WinGetPos, SX, SY,,, StatusMeWin
;If SX is less than 30 and if SY is greater than 0
If ((SX < 30) && (SY > 0)) {
	WinMove, StatusMeWin,, 0 %SY%
}
;If SX is less than 30 and if SY is less than 0
Else If ((SX < 30) && (SY < 0)) {
    WinMove, StatusMeWin,, 0 0
}
;If SX is less than 0 and if SY is greater than 0
Else If ((SX < 0) && (SY > 0)) {
    WinMove, StatusMeWin,, 0 %SY%
}
;If SX is less than 0 and if SY is less than 0
Else If ((SX < 0) && (SY < 0)) {
    WinMove, StatusMeWin,, 0 0
}
GuiControl, St:, StatusText, Current: X%SX% Y%SY%
Return

;========================================
;Buttons
;==============================================================
;----------If "Almost" Impossible to click button was clicked----------
Clicked:
SetTimer, WindowSnap, Off
GuiControl, St:, StatusText, Button Clicked!
MsgBox,, houh, yay :D, 1
Return

;----------Button to set Mouse Move Speed----------
SetSpeed:
SetTimer, WindowSnap, Off
Gui Spd: Submit
GuiControl, St:, StatusText, SpeedSet: %Speed%
Gui Spd: Destroy
Gui Help: Destroy
Sleep 1000
Return

;----------Button to close Help GUI----------
CloseHelp:
SetTimer, WindowSnap, Off
GuiControl, St:, StatusText, Closed HelpGUI
Gui Spd: Destroy
Gui Help: Destroy
Return

;----------Adds function to move windows without Captions----------
GuiMove:
SetTimer, WindowSnap, 0
PostMessage, 0xA1, 2
Return

;----------Tray Menu Button to Pause the script----------
ButtonPause:
SetTimer, WindowSnap, Off
GuiControl, St:, StatusText, Paused - Tray
Pause
Return

;----------Tray Menu Button to Reload the script----------
ButtonReload:
SetTimer, WindowSnap, Off
GuiControl, St:, StatusText, Reloading...
Reload
Return

;----------Tray Menu Button to Exit the script----------
ButtonExit:
SetTimer, WindowSnap, Off
GuiControl, St:, StatusText, Stopping...
ExitApp
Return

;========================================
;Hotkeys
;==============================================================

^p::
SetTimer, WindowSnap, Off
GuiControl, St:, StatusText, Hotkey Pause
Pause
Return

^r::
SetTimer, WindowSnap, Off
GuiControl, St:, StatusText, Hotkey Reload
Reload
Return

^q::
SetTimer, WindowSnap, Off
GuiControl, St:, StatusText, Hotkey Exit
ExitApp
Return