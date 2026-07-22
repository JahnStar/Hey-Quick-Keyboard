;***************************************************************************************************
; Script:  Hey Quick Keyboard v1.3 Lite	(5.31.2026)
; Author: Halil Emre Yildiz
; GitHub: @JahnStar
;***************************************************************************************************
#NoEnv
#SingleInstance Force
#MaxHotkeysPerInterval 10000
#HotkeyInterval 10000
#KeyHistory 0
#InstallKeybdHook   
#InstallMouseHook
SendMode Input
SetWorkingDir, %A_ScriptDir%
Process, Priority, , High
SetBatchLines -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1

Send {LCtrl up}{RCtrl up}{LWin up}{RWin up}{LAlt up}{RAlt up}{LShift up}{RShift up}

SetTimer, CheckHooks, 10000

CheckHooks:
    if A_IsSuspended
        Return
    #InstallKeybdHook
    #InstallMouseHook
Return

if not A_IsAdmin
{
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}

CurrentBrightness := 50
Timer := 0
TimerName := ""

SetNumLockState, On
Suspend, Off

update_traytip()
{
    tray_text := "Hey Quick Keyboard v1.3 Lite`nAuthor: @JahnStar (Github)`n`nToggle with Win + CapsLock"

    if (A_IsSuspended)
    {
        Menu, Tray, Icon, Icon-disabled.ico, , 1
        SplashImage,, M1 b fs12 cteb2a2a cwWhite x25 y25 w200, Disabled, Hey Quick Keyboard
        sleep, 1000
        Splashimage, off
    }
    else
    {
        Menu, Tray, Icon, Icon.ico, , 1
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

ReleaseAllKeys()
{
    Send {LCtrl up}{RCtrl up}{LWin up}{RWin up}{LAlt up}{RAlt up}{LShift up}{RShift up}
    Send {LButton up}{RButton up}{MButton up}
}

End::ReleaseAllKeys()

get_mouse_position()
Return

#CapsLock::
    Suspend, Toggle
    update_traytip()
Return

Pause::
    SendInput, ^!{Tab}
Return

PgUp::
    SendInput, !{Tab}
Return

PgDn::
    SendInput, !+{Tab}
Return
    
^!F4::
    WinGetActiveTitle, ActiveWindow
    WinKill, %ActiveWindow%
return

$PrintScreen::
    SendInput, #{PrintScreen}
Return

^PrintScreen::
    SendInput, {PrintScreen}
Return

CreatePowerTimer(mode, hours)
{
    global Timer, TimerName, Start
    
    if (Timer > 0) 
    {
        Elapsed := A_TickCount - Start 
        Remaining := (Timer - Elapsed) // 3600000 
        RemainingMinutes := Mod((Timer - Elapsed), 3600000) // 60000 
        MsgBox, 3, The %TimerName% timer is running,The computer will %TimerName% in %Remaining% hours and %RemainingMinutes% minutes.`n`nDo you want to cancel the timer?, 20
        IfMsgBox, Yes
        {
            SetTimer, %mode%Mode, Off 
            Timer := 0 
            ElapsedTime := Elapsed // 3600000
            ElapsedMinutes := Mod((Elapsed), 3600000) // 60000
            MsgBox, 48, %mode% Mode Timer, The %TimerName% timer was canceled with %Remaining% hours and %RemainingMinutes% minutes remaining (Elapsed %ElapsedTime% hours and %ElapsedMinutes% minutes)., 20
            TimerName := ""
        }
    }
    Else 
    {
        InputBox, UserInput, %mode% Mode Timer, How many hours do you want the computer to %mode%?`n,,,, Locale , 20
        If (ErrorLevel = 0) 
        {
            If (UserInput is Integer) 
            {
                TimerName := mode
                Timer := UserInput * 3600000 
                Start := A_TickCount 
                SetTimer, %mode%Mode, %Timer% 
                MsgBox, 64, %mode% Mode Timer, The computer will %mode% in %UserInput% hours., 20
            }
        }
    }
}

#F3::
    CreatePowerTimer("sleep", 0)
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

#F4::
    CreatePowerTimer("shutdown", 0)
Return

ShutdownMode:
    SetTimer, ShutdownMode, Off 
    If (TimerName != "shutdown") 
    {
        Timer := 0 
        Return
    }
    MsgBox, 4, , The computer will %TimerName% in 30 seconds. Do you want to %TimerName%?, 30
    IfMsgBox No
    Return
    Shutdown, 9
Return

#F2::
    CreatePowerTimer("restart", 0)
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

#F1::
    CreatePowerTimer("hibernate", 0)
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

#F6::
    CreatePowerTimer("logout", 0)
Return

LogoutMode:
    SetTimer, LogoutMode, Off 
    If (TimerName != "logout") 
    {
        Timer := 0 
        Return
    }
    MsgBox, 4, , The computer will %TimerName% in 30 seconds. Do you want to %TimerName%?, 30
    IfMsgBox No
    Return
    Shutdown, 0
Return

lockScreen := false
#F12::
    lockScreen := true
    if (lockScreen)
    {
        SplashImage,, M2 B2 fs12 ct000000 cwBlack x0 y0 h%A_ScreenHeight% w%A_ScreenWidth%, ,
        Gui, Color, Black
        Gui, +ToolWindow -Caption +AlwaysOnTop
        Gui, show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight%, NA
    }
    While(lockScreen)
    {
        SendMessage,0x112,0xF170,2,,Program Manager
        Sleep, 50
    }
    Sleep, 250
    if (!lockScreen)
    {
        Gui, Destroy
        Splashimage, off
    }
Return

#ESC::
    lockScreen := false
    Gui, Destroy
    Splashimage, off
return

^F5::
    RunWait %comspec% /c ipconfig.exe /release
    Sleep,  10000
    RunWait %comspec% /c ipconfig.exe /renew
    RunWait %comspec% /c ipconfig.exe /flushdns
Return

#F5::
    BatFilePath := A_Temp "\ResetExplorer.bat"
    BatFileContent :=  "del /f /s /q ""%~f0"" %* && taskkill /F /IM explorer.exe && start explorer.exe"
    FileAppend, %BatFileContent%, %BatFilePath%
    RunWait, explorer.exe %BatFilePath%
    Run, cleanmgr.exe
    Run, powershell.exe -file "%A_ScriptDir%\other\Clear-TempFiles.ps1" WinActivate, ahk_class CabinetWClass
    SendInput, {Left}{Enter}
return

#T::
Run, wt.exe -d "%A_Desktop%"
return

<!#T::
    AutoTrim, Off
    SendInput, ^c
    ClipWait, 2
    if (ErrorLevel)
    {
        return
    }
    InputBox, language, Translate Text, `n"%clipboard%"`n`nTranslate to:, , 400, 400
    if ErrorLevel 
    {
        Return
    }
    else
    {
        searchTerm = %clipboard% 
        StringReplace, searchTerm, searchTerm, `r`n, +, all
        StringReplace, searchTerm, searchTerm, %A_SPACE%, +, all
        Run, https://translate.google.com/?sl=auto&tl=%language%&text=%searchTerm%&op=translate
    }
    Clipboard :=
Return

#F::
    AutoTrim, Off
    SendInput, ^c
    ClipWait, 2
    if (ErrorLevel)
    {
        return
    }
    searchTerm = %clipboard% 
    StringReplace, searchTerm, searchTerm, `r`n, +, all
    StringReplace, searchTerm, searchTerm, %A_SPACE%, +, all
    Run, http://www.google.com/search?sourceid=navclient&ie=UTF-8&oe=UTF-8&q=%searchTerm% 
    Clipboard :=
Return

#C::
    SendInput, #+{F23}
Return

#S::
    AutoTrim, Off
    SendInput, ^c
    ClipWait, 100
    Sleep, 400
    Run, wscript.exe "%A_ScriptDir%\tts.vbs" "%Clipboard%"
Return

#+F23::
    SendInput, <
return

RShift & F23::
    SendInput, >
Return

LCtrl & F23::
    SendInput, |
Return

get_mouse_position()
{
    CoordMode, Mouse, Screen
    loop
    {
        if (A_IsSuspended)
        {
            sleep, 100
            continue
        }
        
        MouseGetPos, x, y
        if (x < 10 && y >= A_ScreenHeight - 10)
        {
            sleep, 4000
        }
        sleep, 50
    }
Return
}

$WheelUp::
    CoordMode, Mouse, Screen
    MouseGetPos, x, y
    
    if (y < 10) 
    {
        if (x > 10 && x < A_ScreenWidth - 10) 
        {
            if (LastDesktopSwitch = "" || A_TickCount - LastDesktopSwitch > 400) 
            {
                SendInput, {LCtrl down}{LWin down}{Left}{LWin up}{LCtrl up}
                LastDesktopSwitch := A_TickCount
            }
        }
        else if (x >= A_ScreenWidth - 10) 
        {
            SoundSet, +10
        }
        else if (x <= 10) 
        {
            ChangeBrightness(CurrentBrightness += 20)
        }
        return
    }
    SendInput, {WheelUp}
Return

$WheelDown::
    CoordMode, Mouse, Screen
    MouseGetPos, x, y
    
    if (y < 10) 
    {
        if (x > 10 && x < A_ScreenWidth - 10) 
        {
            if (LastDesktopSwitch = "" || A_TickCount - LastDesktopSwitch > 400) 
            {
                SendInput, {LCtrl down}{LWin down}{Right}{LWin up}{LCtrl up}
                LastDesktopSwitch := A_TickCount
            }
        }
        else if (x >= A_ScreenWidth - 10) 
        {
            SoundSet, -10
        }
        else if (x <= 10) 
        {
            ChangeBrightness(CurrentBrightness -= 20)
        }
        return
    }
    SendInput, {WheelDown}
Return
    
ChangeBrightness(ByRef brightness, timeout = 1)
{
    if (brightness > -20 && brightness < 120)
    {
        For property in ComObjGet("winmgmts:\\.\root\WMI").ExecQuery("SELECT * FROM WmiMonitorBrightnessMethods")
            property.WmiSetBrightness(timeout, brightness)    
    }
    else if (brightness >= 120)
    {
        brightness := 120
    }
    else if (brightness <= -20)
    {
        brightness := -20
    }
}

Gui, +AlwaysOnTop -Caption +ToolWindow
Gui, Color, 50A0FF
Gui, Add, Button, x0 y0 w15 h15 gTaskViewButton, ◘
Gui, Show, x0 y0 w15 h15, HotCornerButton
WinSet, Transparent, 180, HotCornerButton
Return

TaskViewButton:
    KeyWait, LButton
    SendInput, {LWin down}{Tab}{LWin up}
Return

Home::
    SendInput, #{Tab}
Return

~LButton::
{
    CoordMode, Mouse, Screen
    MouseGetPos, x, y, win
    WinGetTitle, winTitle, ahk_id %win%
    
    if (winTitle = "HotCornerButton")
        return

    if (x >= A_ScreenWidth - 10 && y >= A_ScreenHeight - 10) 
    {
        ; Disabled
    }
    else if (x < 10 && y < 10) 
    {
        KeyWait, LButton
        SendInput, {LWin down}{Tab}{LWin up}
    }
    else if (x < 10 && y >= A_ScreenHeight - 10)
    {
        KeyWait, LButton
        SendInput, {LWin down}{LWin up}
    }
    sleep, 50
    Return
}

ToggleTaskbar()
{
    static isHidden := false
    
    WinGetPos, X, Y, Width, Height, ahk_class Shell_TrayWnd
    
    if (Height > 0 && !isHidden) {
        WinHide, ahk_class Shell_TrayWnd
        WinHide, ahk_class Shell_SecondaryTrayWnd
        isHidden := true
    } else {
        WinShow, ahk_class Shell_TrayWnd
        WinShow, ahk_class Shell_SecondaryTrayWnd
        isHidden := false
    }
}

~MButton::
{
    CoordMode, Mouse, Screen
    MouseGetPos, x, y, win
    WinGetTitle, winTitle, ahk_id %win%
    
    if (winTitle = "HotCornerButton")
        return
        
    if (x < 10 && y < 10) 
    {
        WinGetActiveTitle, ActiveWindow
        WinKill, %ActiveWindow%
    }
        
    sleep, 50
    Return
}

HelpLabel:
hotkeyInfo := "Win + CapsLock to toggle it on or off`n`n"
hotkeyInfo .= "Turkish Q Keyboard Support`n"
hotkeyInfo .= "Right Shift + Copilot = >`n"
hotkeyInfo .= "Copilot = <`n`n"
hotkeyInfo .= "RCtrl + Copilot = |`n`n"
hotkeyInfo .= "Tabs`n"
hotkeyInfo .= "Pause = Ctrl + Alt + Tab`n"
hotkeyInfo .= "PgUp = Alt + Tab`n"
hotkeyInfo .= "PgDn = Alt + Tab`n`n"
hotkeyInfo .= "Screenshot`n"
hotkeyInfo .= "PrtSc = Win + PrtSc`n"
hotkeyInfo .= "Ctrl + PrtSc = PrtSc`n`n"
hotkeyInfo .= "Windows`n"
hotkeyInfo .= "Win + F = Quick Google Search`n"
hotkeyInfo .= "Win + T = Quick Google Translate`n"
hotkeyInfo .= "Win + C = Quick AI Chatbot`n"
hotkeyInfo .= "Win + S = Text to Speech`n"
hotkeyInfo .= "Ctrl + Alt + F4 Kill active window`n"
hotkeyInfo .= "Win + F5 Restart Explorer`n"
hotkeyInfo .= "Win + F12 Turn off the display`n"
hotkeyInfo .= "Win + ESC Turn on the display`n"
hotkeyInfo .= "F24 = Release all stuck keys (EMERGENCY)`n`n"
hotkeyInfo .= "Power`n"
hotkeyInfo .= "Win + F1 Hibernate Timer`n"
hotkeyInfo .= "Win + F2 Restart Timer`n"
hotkeyInfo .= "Win + F3 Sleep Timer`n"
hotkeyInfo .= "Win + F4 Shutdown Timer`n"
hotkeyInfo .= "Win + F6 Logout Timer`n`n"
hotkeyInfo .= "Hot Corners`n"
hotkeyInfo .= "Right click on top-left corner opens task view`n"
hotkeyInfo .= "Middle click on top-left corner force kill opened app`n"
hotkeyInfo .= "Mouse wheel in corners for volume/brightness control`n"
hotkeyInfo .= "Mouse wheel on top edge for virtual desktop switching`n"
MsgBox, 64, Hey Quick Keyboard v1.3 Lite, %hotkeyInfo%`nDeveloped by Halil Emre Yildiz`nGithub: @JahnStar, 20
Run, https://github.com/JahnStar/Hey-Quick-Keyboard/
return
