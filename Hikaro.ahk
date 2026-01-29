; AutoHotkey v2
; Made by Hikaro/Галицький Розбишака
; v1.7 - Fixed sticky modifiers
#NoTrayIcon
#SingleInstance Force

iniFile := A_ScriptDir "\Hikaro.ini" ; Файл виключення з правил для AlwaysOnTop функції
if !FileExist(iniFile)
{
    IniWrite("test13579.exe,test24680.exe", iniFile, "Excluded", "Processes")
}

IsTopMost(hwnd := "A")
{
    return (WinGetExStyle(hwnd) & 0x8) != 0
}

^!sc039::  ; Завжди поверх інших вікон (Ctrl+Alt+Space)
{
    procName := WinGetProcessName("A")
    list := IniRead(iniFile, "Excluded", "Processes", "")
    
    if (list = "")
        excludedProcs := []
    else
        excludedProcs := StrSplit(Trim(list, " ,"), ",")
    for proc in excludedProcs
        if (procName = Trim(proc))
            return
    hwnd := WinExist("A")
    WinSetAlwaysOnTop(!IsTopMost(hwnd), hwnd)
    
    msg := "Процес: " procName "`nAlwaysOnTop: " (IsTopMost(hwnd) ? "Увімк." : "Вимк.")
    ToolTip(msg)
    SetTimer(RemoveToolTip, -1500)
}

RemoveToolTip()
{
    ToolTip()
}

AddShortcutToStartup()
{
    exePath := A_ScriptFullPath
    startupFolder := A_Startup
    shortcutName := StrReplace(A_ScriptName, ".exe", "") ".lnk"
    shortcutPath := startupFolder "\" shortcutName
    if FileExist(shortcutPath)
    {
        FileGetShortcut(shortcutPath, &targetPath, &workDir, &args)
        if (targetPath = exePath && args = "/bg")
        {
            if (A_Args.Length = 0)
            {
                FileDelete(shortcutPath)
                MsgBox("Програму видалено з автозапуску Windows і закрито.", "Hikaro Hotkeys", 0)
                ExitApp
            }
            return
        }
        else
        {
            FileDelete(shortcutPath)
        }
    }
    FileCreateShortcut(exePath, shortcutPath, A_WorkingDir, "/bg", "", exePath, 0)
    MsgBox(
        "Програму додано в автозапуск Windows.`nДля видалення з автозапуску, запустіть .exe ще раз.", "Hikaro Hotkeys", 0)
}

AddShortcutToStartup()

; Перезапуск щопівгодини
SetTimer(ReLaunch, 1800000)
ReLaunch() {
    Run(A_ScriptFullPath " /bg")
    ExitApp
}

ReleaseModifiers()
{
    Send "{LCtrl up}{RCtrl up}{LAlt up}{RAlt up}{LShift up}{RShift up}{LWin up}{RWin up}"
}

; Комбінації клавіш
!sc035::  ; Alt+/ (…)
{
    Send "{U+2026}"
    ReleaseModifiers()
}

!sc00C::  ; Alt+- (—)
{
    Send "{U+2014}"
    ReleaseModifiers()
}

!+sc00C::  ; Alt+Shift+- (–)
{
    Send "{U+2013}"
    ReleaseModifiers()
}

!sc033::  ; Alt+, («)
{
    Send "{U+00AB}"
    ReleaseModifiers()
}

!sc034::  ; Alt+. (»)
{
    Send "{U+00BB}"
    ReleaseModifiers()
}

!sc029::  ; Alt+~ (')
{
    Send "{U+2019}"
    ReleaseModifiers()
}

!sc009::  ; Alt+8 (°)
{
    Send "{U+00B0}"
    ReleaseModifiers()
}

!+sc033::  ; Alt+Shift+, («» з курсором усередині)
{
    Send "{U+00AB}{U+00BB}{Left}"
    ReleaseModifiers()
}

+sc039::  ; Shift+Space (нерозривний пробіл)
{
    Send "{U+00A0}"
    ReleaseModifiers()
}

<^>!sc035::  ; AltGr+/ (…)
{
    Send "{U+2026}"
    ReleaseModifiers()
}

<^>!sc00C::  ; AltGr+- (—)
{
    Send "{U+2014}"
    ReleaseModifiers()
}

<^>!+sc00C::  ; AltGr+Shift+- (–)
{
    Send "{U+2013}"
    ReleaseModifiers()
}

<^>!sc033::  ; AltGr+, («)
{
    Send "{U+00AB}"
    ReleaseModifiers()
}

<^>!sc034::  ; AltGr+. (»)
{
    Send "{U+00BB}"
    ReleaseModifiers()
}

<^>!sc029::  ; AltGr+~ (')
{
    Send "{U+2019}"
    ReleaseModifiers()
}

<^>!sc009::  ; AltGr+8 (°)
{
    Send "{U+00B0}"
    ReleaseModifiers()
}

<^>!+sc033::  ; AltGr+Shift+, («» з курсором усередині)
{
    Send "{U+00AB}{U+00BB}{Left}"
    ReleaseModifiers()
}