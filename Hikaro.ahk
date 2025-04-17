; Autohotkey v2
; Made by Hikaro/Галицький Розбишака

#NoTrayIcon
#SingleInstance Force

iniFile := A_ScriptDir "\Hikaro.ini"

; Якщо .ini нема — створити з шаблоном
if !FileExist(iniFile)
{
    IniWrite("test13579.exe,test24680.exe", iniFile, "Excluded", "Processes")
}

; Завжди поверх інших (Ctrl+Alt+Space)
^!sc039::
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

; Символи через (Win+...)
#sc035::Send("{U+2026}") ; Win+/ (…)
#sc00C::Send("{U+2014}") ; Win+- (—)
#+sc00C::Send("{U+2013}") ; Win+Shift+- (–)
#+sc033::Send("{U+00AB}") ; Win+Shift+, («)
#+sc034::Send("{U+00BB}") ; Win+Shift+. (»)

; Авто-лапки «» з курсором всередині (Alt+Shift+, або .)
!+sc033::Send("{U+00AB}{U+00BB}{Left}")
!+sc034::Send("{U+00AB}{U+00BB}{Left}")
