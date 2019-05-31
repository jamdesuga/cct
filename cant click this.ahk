;===================
;> https://github.com/jamdesuga/cct
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
global Speed, StatusText, SX, SY
;Default Move Speed
Speed = 3
;Default StatusGUI co-ordinates
SX = 0
SY = 0

;----------Set Menu Tray----------
SetTrayMenu()

;----------Make GUI Invisible, Keep button visible----------
Gui Inv: +LastFound +AlwaysOnTop
IdInv := WinExist()
Gui Inv: -dpiscale -Caption -Border
Gui Inv: Color, Black
Gui Inv: Add, Button, x221 y221 w60 h60 vMoveButton gClicked HWNDClickMe, click me
Gui Inv: Show, w500 h500, ClickMeWin
WinSet, TransColor, Black, ahk_id %IdInv%
OnMessage(0x200,"MoveButton")

;----------Displays Status GUI----------

Gui St: -Caption -Border +AlwaysOnTop +LastFound
WinSet Transparent, 245
Gui St: Color, 20252d
Gui St: Font, Segoe UI
Gui St: Font, s8 cc3c4c6 Normal 
Gui St: Add, Text, BackgroundTrans x0 y0 w120 h20 0x200 vMovePos gGuiMove
Gui St: Add, Text, BackgroundTrans x3 y3 w120 h20 vStatusText, Not Running
WinSet Region, 0-0 w120 h20 r6-6
Gui St: Show, x%SX% y%SY%, StatusMeWin
Return

;######################################################################################################################
;######################################################################################################################

;========================================
;Tray Menu
;==============================================================
SetTrayMenu() {
Menu, Tray, NoStandard
Menu, Tray, Add, &Status, TrayStatus
Menu, Tray, Add, &Pause, TrayPause
Menu, Tray, Add, &Reload, TrayReload
Menu, Tray, Add, &Exit, TrayExit
}

;========================================
;Button Move Function
;==============================================================
;----------Action for when mouse moves over GUI, or in this case, the "click me" button----------
MoveButton() {
SetTimer, WindowSnap, Off
If A_Gui <= 0
{
	Return
}
	{
	Random, X, 0, 440
	Random, Y, 0, 440
	GuiControl, Move, MoveButton, x%X% y%Y%
	}
}

Return ;Ends Start Up

;######################################################################################################################
;######################################################################################################################

;========================================
;Window Snap - Still Buggy :c
;==============================================================
WindowSnap:
WinGetPos, SX, SY,,, StatusMeWin
;If SX is less than 0 pixels and if SY is greater than 0 pixels
If ((SX < 0) && (SY > 0)) {
	WinMove, StatusMeWin,, 0 %SY% ;snap SX to border(0), keep SY co-ordinatess
}
;If SX is less than 0 pixels and if SY is less than 0 pixels
Else If ((SX < 0) && (SY < 0)) {
    WinMove, StatusMeWin,, 0 0 ;snap SX to border(0), snap SY to border(0)
}
WinGetPos, SXN, SYN,,, StatusMeWin
GuiControl, St:, StatusText, Current: X%SXN% Y%SYN%
Return

;========================================
;Button Functions
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

;----------Adds function to move StatusGUI----------
GuiMove:
SetTimer, WindowSnap, Off
SetTimer, WindowSnap, 10
PostMessage, 0xA1, 2
Return

;----------Adds function to move windows without Captions----------
GuiMoveO:
PostMessage, 0xA1, 2
Return

;----------Tray Menu Button to toggle StatusGUI----------
TrayStatus:
sttoggle := !sttoggle
    If (sttoggle) {
        GuiControl, St:, StatusText, StatusGUI Off
        Gui St: Hide
    }
    Else {
        GuiControl, St:, StatusText, StatusGUI On
        Gui St: Show, x%SX% y%SY%
    }
Return

;----------Tray Menu Button to Pause the script----------
TrayPause:
SetTimer, WindowSnap, Off
GuiControl, St:, StatusText, Paused - Tray
Pause
Return

;----------Tray Menu Button to Reload the script----------
TrayReload:
SetTimer, WindowSnap, Off
GuiControl, St:, StatusText, Reloading...
Reload
Return

;----------Tray Menu Button to Exit the script----------
TrayExit:
SetTimer, WindowSnap, Off
GuiControl, St:, StatusText, Stopping...
ExitApp
Return

;######################################################################################################################
;######################################################################################################################

;========================================
;Hotkeys
;==============================================================

;==========Speed Change | CTRL+M==========
;----------Displays GUI to change Mouse Move Speed----------
^m::
SetTimer, WindowSnap, Off
GuiControl, St:, StatusText, Load SetSpeedGUI
Gui Help: Destroy
Gui Spd: Destroy
Gui Spd: -Caption -Border
Gui Spd: Add, Text, x0 y0 w100 h20 Center BackgroundTrans 0x200 gGuiMoveO
Gui Spd: Add, Text, Center BackgroundTrans x10 y10 w80 h20, Move Speed
Gui Spd: Add, Edit, x10 y+0 w80 h20
Gui Spd: Add, UpDown, vSpeed Range0-20, %Speed%
Gui Spd: Add, Button, x20 y+6 w60 h20 gSetSpeed, Confirm
Gui Spd: Show, x100 y100 w100 h85
Return

;==========Help | CTRL+H==========
;----------Displays Help GUI----------
^h::
SetTimer, WindowSnap, Off
GuiControl, St:, StatusText, Load HelpGUI
Gui Spd: Destroy
Gui Help: Destroy
Gui Help: -Caption -Border
Gui Help: Font, Bold
Gui Help: Add, Text, x0 y0 w120 h150 Center BackgroundTrans 0x200 gGuiMoveO
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

;==========Toggle Automatic Clicker | CTRL+T==========
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
        GuiControl, St:, StatusText, MouseMoved, Paused
        Sleep 10000
        }
    Else If (Speed <= 2) {
        ControlGetPos, X, Y,,,, % "ahk_id" . ClickMe
        ;----------Use below for random location!----------
        ;Random, RX, 3, 57
        ;Random, RY, 3, 57
        ;Random, Speed, 5, 10

        X += 29 ;Replace with %RX%
        Y += 29 ;Replace with %RY%
        MouseMove, %X%, %Y%, %Speed%

        ;Below fixes unwanted pauses when mouse moves to button at high speeds...
        X += 1 ;Replace with %RX%
        Y += 1 ;Replace with %RY%
        MouseMove, %X%, %Y%, 0

        ;----------Click instead of Move----------
        ;MouseClick, Left, %X%, %Y%, 1, 0

        ;----------Status Text----------
        CoordMode, Mouse, Screen
        MouseGetPos, MX, MY
        GuiControl, St:, StatusText, Clicking X%MX% Y%MY%
    }
        Else If (Speed > 2) {
        ControlGetPos, X, Y,,,, % "ahk_id" . ClickMe
        ;----------Use below for random location!----------
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

;==========Disables certain keys that can press the button without clicking==========
#iF WinActive("ClickMeWin")
Enter::
Return
Space::
return
#iF

;==========Pause Script | CTRL+P==========
^p::
SetTimer, WindowSnap, Off
GuiControl, St:, StatusText, Hotkey Pause
Pause
Return

;==========Reload Script | CTRL+R==========
^r::
SetTimer, WindowSnap, Off
GuiControl, St:, StatusText, Hotkey Reload
Reload
Return

;==========Exit Script | CTRL+Q==========
^q::
SetTimer, WindowSnap, Off
GuiControl, St:, StatusText, Hotkey Exit
ExitApp
Return
