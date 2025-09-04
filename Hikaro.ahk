; AutoHotkey v2
; Made by Hikaro/Галицький Розбишака
; v1.5.2

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
        "Програма автоматично додана в автозапуск Windows.`n`n"
      . "Для видалення з автозапуску, запустіть .exe ще раз.",
        "Hikaro Hotkeys", 0)
}

AddShortcutToStartup()

; Символи
!sc035::SendInput("{U+2026}")  ; Alt+/ (…)
!sc00C::SendInput("{U+2014}")  ; Alt+- (—)
!+sc00C::SendInput("{U+2013}")  ; Alt+Shift+- (–)
!sc033::SendInput("{U+00AB}")  ; Alt+, («)
!sc034::SendInput("{U+00BB}")  ; Alt+. (»)
!sc003::SendInput("{U+2019}")  ; Alt+2 (’)
!sc009::SendInput("{U+00B0}")  ; Alt+8 (°)
!+sc033::SendInput("{U+00AB}{U+00BB}{Left}")  ; «» з курсором усередині (Alt+Shift+,)

; На випадок використання розкладки Українська (розширена)
<^>!sc035::SendInput("{U+2026}")  ; AltGr+/ (…)
<^>!sc00C::SendInput("{U+2014}")  ; AltGr+- (—)
<^>!+sc00C::SendInput("{U+2013}")  ; AltGr+Shift+- (–)
<^>!sc033::SendInput("{U+00AB}")  ; AltGr+, («)
<^>!sc034::SendInput("{U+00BB}")  ; AltGr+. (»)
<^>!sc003::SendInput("{U+2019}")  ; AltGr+2 (’)
<^>!sc009::SendInput("{U+00B0}")  ; AltGr+8 (°)
<^>!+sc033::SendInput("{U+00AB}{U+00BB}{Left}")  ; «» з курсором усередині (AltGr+Shift+,)
