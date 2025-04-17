; Autohotkey v2
; Made by Hikaro/Галицький Розбишака

#NoTrayIcon
#SingleInstance Force

iniFile := A_ScriptDir "\Hikaro.ini"

if !FileExist(iniFile)
{
    IniWrite("test13579.exe,test24680.exe", iniFile, "Excluded", "Processes")
}

^!sc039:: ; Завжди поверх інших (Ctrl+Alt+Space)
{
    procName := WinGetProcessName("A")
    list := IniRead(iniFile, "Excluded", "Processes", "")
    excludedProcs := StrSplit(list, ",")
    
    for proc in excludedProcs
        if (procName = Trim(proc))
            return

    exStyle := WinGetExStyle("A")
    isTop := (exStyle & 0x8)
    WinSetAlwaysOnTop(!isTop, "A")

    exStyle := WinGetExStyle("A")
    isTop := (exStyle & 0x8)

    msg := "Процес: " procName "`nAlwaysOnTop: " (isTop ? "Увімк." : "Вимк.")
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
        FileGetShortcut(shortcutPath, &targetPath)

        if (targetPath = exePath)
            return
        else
            FileDelete(shortcutPath)
    }

    FileCreateShortcut(exePath, shortcutPath, A_WorkingDir, "", "Autostart " A_ScriptName, exePath, 0)
}

AddShortcutToStartup()

!sc035::Send("{U+2026}") ; Alt+/ (…)
!sc00C::Send("{U+2014}") ; Alt+- (—)
!+sc00C::Send("{U+2013}") ; Alt+Shift+- (–)
!sc033::Send("{U+00AB}") ; Alt+, («)
!sc034::Send("{U+00BB}") ; Alt+. (»)
!sc003::Send("{U+2019}") ; Alt+2 (’)
!sc009::Send("{U+00B0}") ; Alt+8 (°)
!+sc033::Send("{U+00AB}{U+00BB}{Left}") ; «» з курсором всередині (Alt+Shift+,)
