; Developed by Halil Emre Yildiz (Github: @JahnStar)
; Hey Quick Keyboard
; Win + CapsLock to toggle it on or off

; Numpad
; !(Shift | Win | AltGr) + 0-9 = Numpad 0-9
; Alt + . = Numpad .
; Left Alt + / = Numpad /
; Left Alt + - = Numpad -
; Left Alt + , = Numpad +
; Left Ctrl + - = Ctrl + Numpad -
; Left Ctrl + + = Ctrl + Numpad +

; Tabs
; Pause = Ctrl + Alt + Tab
; PgUp = Alt + Tab
; PgDn = Alt + Tab

; Screenshot
; PrtSc = Win + PrtSc
; Ctrl + PrtSc = PrtSc

; Windows
; Ctrl + Alt + F4 Kill active window
; Win + F5 Restart Explorer

; Power
; Win + F1 Hibernate Timer
; Win + F2 Restart Timer
; Win + F3 Sleep Timer
; Win + F4 Shutdown Timer
; Win + F6 Logout Timer
; Win + 12 Turn off the display (Esc for cancel)

;Mouse
; Menu Key = Middle Click
; Right Ctrl + Arrows = Mouse movement
; Right Ctrl + M = Move cursor in the middle
; Right Ctrl + Z = Left Click
; Right Ctrl + Y = Middle Click
; Right Ctrl + C = Right Click
; Left Alt + Up/Down Arrow = Scroll Wheel

; ==============================================================================================================================================================================================
#NoEnv
#SingleInstance force
SendMode Input
SetWorkingDir %A_ScriptDir%

; Global variable to store the startup state ------------------------------

SetNumLockState, On
Suspend, Off

update_traytip()
{
    tray_text := "Hey Quick Keyboard v1.1`nAuthor: @JahnStar (Github)`n`nToggle with Win + CapsLock"

	if (A_IsSuspended)
    {
        Menu, Tray, Icon, Icon-disabled.ico, , 1
        SoundPlay, *16
        SplashImage,, M1 b fs12 cteb2a2a cwWhite x25 y25 w200, Disabled, Hey Quick Keyboard
        sleep, 1000
        Splashimage, off
    }
	else
    {
        Menu, Tray, Icon, Icon.ico, , 1
        SoundPlay, *48
        SplashImage,, M1 b fs12 ct009c1c cwWhite x25 y25 w200, Enabled, Hey Quick Keyboard
        sleep, 1000
        Splashimage, off
    }
    Menu, Tray, Tip, %tray_text%
    Menu, Tray, Add, Help, HelpLabel 
    Return
}
update_traytip()

Menu, Tray, Add, Run on Startup, TrayRunStartup
Menu, Tray, Default, Run on Startup
init = 0
TrayRunStartup:
startupPath = %A_Startup%\HeyQuickKeyboard.lnk
willRun := FileExist(startupPath)
if !init++
{
    if (willRun)
        Menu, Tray, Check, Run on Startup
    else
        Menu, Tray, UnCheck, Run on Startup
}
else
{
    if (willRun)
    {
        FileDelete, %startupPath%
        Menu, Tray, UnCheck, Run on Startup
    }
    else
    {
        FileCreateShortcut, %A_ScriptFullPath%, %startupPath%
        Menu, Tray, Check, Run on Startup
    }
}
Return

; - Ctrl + CapsLock ---------------------------------

#CapsLock::
    Suspend, Toggle
    update_traytip()
Return

;; Tabs --------------------------------------------------
Pause::Send, ^!{Tab}
PgUp::Send, !{Tab}
PgDn::Send, !+{Tab}
	
^!F4::
	WinGetActiveTitle, ActiveWindow
	WinKill, %ActiveWindow%
return

;; Screen Show --------------------------------------------------
	$PrintScreen::Send, #{PrintScreen}
	^PrintScreen::Send, {PrintScreen}

;; Power --------------------------------------------------
#F3:: ;; Sleep
If (Timer > 0) 
{
    Elapsed := A_TickCount - Start 
    Remaining := (Timer - Elapsed) // 3600000 
    RemainingMinutes := Mod((Timer - Elapsed), 3600000) // 60000 
    MsgBox, 3, The %TimerName% timer is running,The computer will %TimerName% in %Remaining% hours and %RemainingMinutes% minutes.`n`nDo you want to cancel the timer?, 20
    IfMsgBox, Yes
    {
        SetTimer, SleepMode, Off 
        Timer := 0 
        ElapsedTime := Elapsed // 3600000
        ElapsedMinutes := Mod((Elapsed), 3600000) // 60000
        MsgBox, 48, Sleep Mode Timer, The %TimerName% timer was canceled with %Remaining% hours and %RemainingMinutes% minutes remaining (Elapsed %ElapsedTime% hours and %ElapsedMinutes% minutes)., 20
        TimerName := ""
    }
}
Else 
{
    InputBox, UserInput, Sleep Mode Timer, How many hours do you want the computer to go to sleep mode?`n,,,, Locale , 20
    If (ErrorLevel = 0) 
    {
        If (UserInput is Integer) 
        {
            TimerName := "sleep"
            Timer := UserInput * 3600000 
            Start := A_TickCount 
            SetTimer, SleepMode, %Timer% 
            MsgBox, 64, Sleep Mode Timer, The computer will go to sleep mode in %UserInput% hours., 20
        }
    }
}
Return
SleepMode:
    SetTimer, SleepMode, Off 
    If (TimerName != "sleep") 
    {
        Timer := 0 
        Return
    }
    MsgBox, 4, , The computer will %TimerName% in 30 seconds. Do you want to %TimerName%?, 30
    IfMsgBox No
    Return
    DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
Return
#F4:: ;; Shutdown
If (Timer > 0) 
{
    Elapsed := A_TickCount - Start 
    Remaining := (Timer - Elapsed) // 3600000 
    RemainingMinutes := Mod((Timer - Elapsed), 3600000) // 60000 
    MsgBox, 3, The %TimerName% timer is running,The computer will %TimerName% in %Remaining% hours and %RemainingMinutes% minutes.`n`nDo you want to cancel the timer?, 20
    IfMsgBox, Yes
    {
        SetTimer, ShutdownMode, Off 
        Timer := 0 
        ElapsedTime := Elapsed // 3600000
        ElapsedMinutes := Mod((Elapsed), 3600000) // 60000
        MsgBox, 48, Shutdown Mode Timer, The %TimerName% timer was canceled with %Remaining% hours and %RemainingMinutes% minutes remaining (Elapsed %ElapsedTime% hours and %ElapsedMinutes% minutes)., 20
        TimerName := ""
    }
}
Else 
{
    InputBox, UserInput, Shutdown Mode Timer, How many hours do you want the computer to shut down?`n,,,, Locale , 20
    If (ErrorLevel = 0) 
    {
        If (UserInput is Integer) 
        {
            TimerName := "shut down"
            Timer := UserInput * 3600000 
            Start := A_TickCount 
            SetTimer, ShutdownMode, %Timer% 
            MsgBox, 64, Shutdown Mode Timer, The computer will shut down in %UserInput% hours., 20
        }
    }
}
Return
ShutdownMode:
    SetTimer, ShutdownMode, Off 
    If (TimerName != "shut down") 
    {
        Timer := 0 
        Return
    }
    MsgBox, 4, , The computer will %TimerName% in 30 seconds. Do you want to %TimerName%?, 30
    IfMsgBox No
    Return
    Shutdown, 9
Return
#F2:: ;; Restart
If (Timer > 0) 
{
    Elapsed := A_TickCount - Start 
    Remaining := (Timer - Elapsed) // 3600000 
    RemainingMinutes := Mod((Timer - Elapsed), 3600000) // 60000 
    MsgBox, 3, The %TimerName% timer is running,The computer will %TimerName% in %Remaining% hours and %RemainingMinutes% minutes.`n`nDo you want to cancel the timer?, 20
    IfMsgBox, Yes
    {
        SetTimer, RestartMode, Off 
        Timer := 0 
        ElapsedTime := Elapsed // 3600000
        ElapsedMinutes := Mod((Elapsed), 3600000) // 60000
        MsgBox, 48, Restart Mode Timer, The %TimerName% timer was canceled with %Remaining% hours and %RemainingMinutes% minutes remaining (Elapsed %ElapsedTime% hours and %ElapsedMinutes% minutes)., 20
        TimerName := ""
    }
}
Else 
{
    InputBox, UserInput, Restart Mode Timer, How many hours do you want the computer to restart?`n,,,, Locale , 20
    If (ErrorLevel = 0) 
    {
        If (UserInput is Integer) 
        {
            TimerName := "restart"
            Timer := UserInput * 3600000 
            Start := A_TickCount 
            SetTimer, RestartMode, %Timer% 
            MsgBox, 64, Restart Mode Timer, The computer will restart in %UserInput% hours., 20
        }
    }
}
Return
RestartMode:
    SetTimer, RestartMode, Off 
    If (TimerName != "restart") 
    {
        Timer := 0 
        Return
    }
    MsgBox, 4, , The computer will %TimerName% in 30 seconds. Do you want to %TimerName%?, 30
    IfMsgBox No
    Return
    Shutdown, 2
Return
#F1:: ;; Hibernate
If (Timer > 0) 
{
    Elapsed := A_TickCount - Start 
    Remaining := (Timer - Elapsed) // 3600000 
    RemainingMinutes := Mod((Timer - Elapsed), 3600000) // 60000 
    MsgBox, 3, The %TimerName% timer is running,The computer will %TimerName% in %Remaining% hours and %RemainingMinutes% minutes.`n`nDo you want to cancel the timer?, 20
    IfMsgBox, Yes
    {
        SetTimer, HibernateMode, Off 
        Timer := 0 
        ElapsedTime := Elapsed // 3600000
        ElapsedMinutes := Mod((Elapsed), 3600000) // 60000
        MsgBox, 48, Hibernate Mode Timer, The %TimerName% timer was canceled with %Remaining% hours and %RemainingMinutes% minutes remaining (Elapsed %ElapsedTime% hours and %ElapsedMinutes% minutes)., 20
        TimerName := ""
    }
}
Else 
{
    InputBox, UserInput, Hibernate Mode Timer, How many hours do you want the computer to hibernate?`n,,,, Locale , 20
    If (ErrorLevel = 0) 
    {
        If (UserInput is Integer) 
        {
            TimerName := "hibernate"
            Timer := UserInput * 3600000 
            Start := A_TickCount 
            SetTimer, HibernateMode, %Timer% 
            MsgBox, 64, Hibernate Mode Timer, The computer will hibernate in %UserInput% hours., 20
        }
    }
}
Return
HibernateMode:
    SetTimer, HibernateMode, Off 
    If (TimerName != "hibernate") 
    {
        Timer := 0 
        Return
    }
    MsgBox, 4, , The computer will %TimerName% in 30 seconds. Do you want to %TimerName%?, 30
    IfMsgBox No
    Return
    DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
Return
#F6:: ;; Logout
If (Timer > 0) 
{
    Elapsed := A_TickCount - Start 
    Remaining := (Timer - Elapsed) // 3600000 
    RemainingMinutes := Mod((Timer - Elapsed), 3600000) // 60000 
    MsgBox, 3, The %TimerName% timer is running,The computer will %TimerName% in %Remaining% hours and %RemainingMinutes% minutes.`n`nDo you want to cancel the timer?, 20
    IfMsgBox, Yes
    {
        SetTimer, LogoutMode, Off 
        Timer := 0 
        ElapsedTime := Elapsed // 3600000
        ElapsedMinutes := Mod((Elapsed), 3600000) // 60000
        MsgBox, 48, Logout Mode Timer, The %TimerName% timer was canceled with %Remaining% hours and %RemainingMinutes% minutes remaining (Elapsed %ElapsedTime% hours and %ElapsedMinutes% minutes)., 20
        TimerName := ""
    }
}
Else 
{
    InputBox, UserInput, Logout Mode Timer, How many hours do you want the computer to log out?`n,,,, Locale , 20
    If (ErrorLevel = 0) 
    {
        If (UserInput is Integer) 
        {
            TimerName := "log out"
            Timer := UserInput * 3600000 
            Start := A_TickCount 
            SetTimer, LogoutMode, %Timer% 
            MsgBox, 64, Logout Mode Timer, The computer will log out in %UserInput% hours., 20
        }
    }
}
Return
LogoutMode:
    SetTimer, LogoutMode, Off 
    If (TimerName != "log out") 
    {
        Timer := 0 
        Return
    }
    MsgBox, 4, , The computer will %TimerName% in 30 seconds. Do you want to %TimerName%?, 30
    IfMsgBox No
    Return
    Shutdown, 0
Return

screenIsOn := False
#F12::
While(!screenIsOn & !GetKeyState("Escape", "P"))
{	
    Sleep, 250
    SendMessage,0x112,0xF170,2,,Program Manager
    Sleep, 250
}
screenIsOn := !screenIsOn
Sleep, 2000
Return

;; Reset Ip --------------------------------------------------
^F5::
	RunWait %comspec% /c ipconfig.exe /release
	Sleep,  10000
	RunWait %comspec% /c ipconfig.exe /renew
	RunWait %comspec% /c ipconfig.exe /flushdns
Return

;; Reset Explorer --------------------------------------------------
#F5::
    BatFilePath := A_Temp "\ResetExplorer.bat"
    BatFileContent :=  "del /f /s /q ""%~f0"" %* && taskkill /F /IM explorer.exe && start explorer.exe"
    FileAppend, %BatFileContent%, %BatFilePath%
    RunWait, explorer.exe %BatFilePath%
    Run, powershell.exe -file "%A_ScriptDir%\other\Clear-TempFiles.ps1" WinActivate, ahk_class CabinetWClass
    Send, {Left}{Enter}
return

;; Translate clipboard --------------------------------------------------
#T::
    AutoTrim, Off
    Send, ^c
    ClipWait, 2
    if (ErrorLevel)
        return
    InputBox, language, Translate Text, `n"%clipboard%"`n`nTranslate to:, , 400, 400
    if ErrorLevel 
        Return
    else
    {
        searchTerm = %clipboard% 
        StringReplace, searchTerm, searchTerm, `r`n, +, all
        StringReplace, searchTerm, searchTerm, %A_SPACE%, +, all
        Run, https://translate.google.com/?sl=auto&tl=%language%&text=%searchTerm%&op=translate ;Run, https://translate.google.com/#auto/%language%/%searchTerm%
    }
    Clipboard :=
Return

;; Search clipboard --------------------------------------------------
#F::
    AutoTrim, Off
    Send, ^c
    ClipWait, 2
    if (ErrorLevel)
        return
    searchTerm = %clipboard% 
    StringReplace, searchTerm, searchTerm, `r`n, +, all
    StringReplace, searchTerm, searchTerm, %A_SPACE%, +, all
    Run, http://www.google.com/search?sourceid=navclient&ie=UTF-8&oe=UTF-8&q=%searchTerm% 
    Clipboard :=
Return

;; Numpad with numerics  --------------------------------------------------

    RAlt & .::Send {NumpadDot}
    LAlt & .::Send {NumpadDot}
    LAlt & *::Send {NumpadMult}
    LAlt & /::Send {NumpadDiv}
    LAlt & -::Send {NumpadSub}
    LAlt & ,::Send {NumpadAdd}
    #If not GetKeyState("Alt")
    LCtrl & -::Send ^{NumpadSub}
    LCtrl & ,::Send ^{NumpadAdd}
    #If

#If, not GetKeyState("Shift") and not GetKeyState("RAlt")
    0::Numpad0
    1::Numpad1
    2::Numpad2
    3::Numpad3
    4::Numpad4
    5::Numpad5
    6::Numpad6
    7::Numpad7
    8::Numpad8
    9::Numpad9
#If
    #0::#0
    #1::#1
    #2::#2
    #3::#3
    #4::#4
    #5::#5
    #6::#6
    #7::#7
    #8::#8
    #9::#9
#If

;; Mouse --------------------------------------------------

RCtrl & Z::
Send {LButton}
Send {LButton Down}
KeyWait, Z
Send {LButton Up}
return
RCtrl & C::
Send {RButton}
Send {RButton Down}
KeyWait, C
Send {RButton Up}
return
RCtrl & X::
Send {MButton Down}
KeyWait, X
Send {MButton Up}
Send {MButton}
return
AppsKey::MButton

!Up::Send {WheelUp}
!Down::Send {WheelDown}

RCtrl & Up::
    MouseSpeed += 3
    MouseMove, 0, -MouseSpeed, 0, R
    MouseSpeed += 1
    Return
RCtrl & Down::
    MouseSpeed += 3
    MouseMove, 0, MouseSpeed, 0, R
    MouseSpeed += 1
    Return
RCtrl & Left::
    MouseSpeed += 3
    MouseMove, -MouseSpeed, 0, 0, R
    MouseSpeed += 2
    Return
RCtrl & Right::
    MouseSpeed += 3
    MouseMove, MouseSpeed, 0, 0, R
    MouseSpeed += 2
    Return
RCtrl & Up Up::
    MouseSpeed := 0 
    Return
RCtrl & Down Up::
    MouseSpeed := 0 
    Return
RCtrl & Left Up::
    MouseSpeed := 0 
    Return
RCtrl & Right Up::
    MouseSpeed := 0 
    Return
#If

RCtrl & M::
  CoordMode, Mouse, Screen
  MouseMove, (A_ScreenWidth // 2), (A_ScreenHeight // 2)
Return

; Show the shortcuts --------------------------------------------------
HelpLabel:
hotkeyInfo := "Win + CapsLock to toggle it on or off`n`n"
; Numpad
hotkeyInfo .= "Numpad`n"
hotkeyInfo .= "!(Shift | Win | AltGr) + 0-9 = Numpad 0-9`n"
hotkeyInfo .= "Alt + . = Numpad .`n"
hotkeyInfo .= "Left Alt + / = Numpad /`n"
hotkeyInfo .= "Left Alt + - = Numpad -`n"
hotkeyInfo .= "Left Alt + , = Numpad +`n"
hotkeyInfo .= "Left Ctrl + - =  Ctrl + Numpad -`n"
hotkeyInfo .= "Left Ctrl + + = Ctrl + Numpad +`n`n"

; Tabs
hotkeyInfo .= "Tabs`n"
hotkeyInfo .= "Pause = Ctrl + Alt + Tab`n"
hotkeyInfo .= "PgUp = Alt + Tab`n"
hotkeyInfo .= "PgDn = Alt + Tab`n`n"
; Screenshot
hotkeyInfo .= "Screenshot`n"
hotkeyInfo .= "PrtSc = Win + PrtSc`n"
hotkeyInfo .= "Ctrl + PrtSc = PrtSc`n`n"
; Windows
hotkeyInfo .= "Windows`n"
hotkeyInfo .= "Win + F = Quick Google Search`n"
hotkeyInfo .= "Win + T = Quick Google Translate`n"
hotkeyInfo .= "Ctrl + Alt + F4 Kill active window`n"
hotkeyInfo .= "Win + F5 Restart Explorer`n`n"
; Power
hotkeyInfo .= "Power`n"
hotkeyInfo .= "Win + F1 Hibernate Timer`n"
hotkeyInfo .= "Win + F2 Restart Timer`n"
hotkeyInfo .= "Win + F3 Sleep Timer`n"
hotkeyInfo .= "Win + F4 Shutdown Timer`n"
hotkeyInfo .= "Win + F6 Logout Timer`n"
hotkeyInfo .= "Win + F12 Turn off the display`n`n"
; Mouse
hotkeyInfo .= "Mouse`n"
hotkeyInfo .= "Menu Key = Middle Click`n"
hotkeyInfo .= "Right Ctrl + Arrows = Mouse movement`n"
hotkeyInfo .= "Right Ctrl + M = Move cursor in the middle`n"
hotkeyInfo .= "Right Ctrl + Z = Left Click`n"
hotkeyInfo .= "Right Ctrl + Y = Middle Click`n"
hotkeyInfo .= "Right Ctrl + C = Right Click`n"
hotkeyInfo .= "Left Alt + Up/Down Arrow = Scroll Wheel`n"
MsgBox, 64, Hey Quick Keyboard v1.1, %hotkeyInfo%`nDeveloped by Halil Emre Yildiz`nGithub: @JahnStar, 20
Run, https://github.com/JahnStar/Hey-Quick-Keyboard/
return