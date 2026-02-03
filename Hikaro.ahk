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

; Функція для відправки символу з юнікоду + відпускання модифікаторів
SendUnicode(code) {
    Send "{Blind}" code
    Send "{LCtrl up}{RCtrl up}{LAlt up}{RAlt up}{LShift up}{RShift up}{LWin up}{RWin up}"
}

; Комбінації клавіш
!sc035:: SendUnicode("{U+2026}")       ; Alt + / (…)
!sc00C:: SendUnicode("{U+2014}")       ; Alt + - (—)
!+sc00C:: SendUnicode("{U+2013}")      ; Alt + Shift + - (–)
!sc033:: SendUnicode("{U+00AB}")       ; Alt + , («)
!sc034:: SendUnicode("{U+00BB}")       ; Alt + . (»)
!sc029:: SendUnicode("{U+2019}")       ; Alt + ~ (’)
!sc009:: SendUnicode("{U+00B0}")       ; Alt + 8 (°)
!+sc033:: SendUnicode("{U+00AB}{U+00BB}{Left}") ; Alt + Shift + , («» з курсором усередині)

<^>!sc035:: SendUnicode("{U+2026}")     ; AltGr + / (…)
<^>!sc00C:: SendUnicode("{U+2014}")     ; AltGr + - (—)
<^>!+sc00C:: SendUnicode("{U+2013}")    ; AltGr + Shift + - (–)
<^>!sc033:: SendUnicode("{U+00AB}")     ; AltGr + , («)
<^>!sc034:: SendUnicode("{U+00BB}")     ; AltGr + . (»)
<^>!sc029:: SendUnicode("{U+2019}")     ; AltGr + ~ (’)
<^>!sc009:: SendUnicode("{U+00B0}")     ; AltGr + 8 (°)
<^>!+sc033:: SendUnicode("{U+00AB}{U+00BB}{Left}") ; AltGr + Shift + , («» з курсором усередині)
