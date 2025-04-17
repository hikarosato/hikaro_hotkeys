; Autohotkey 1.1 Unicode 64-bit
; Made by Hikaro/Галицький Розбишака

#NoTrayIcon
#NoEnv
#SingleInstance force

; == Завжди поверх інших (Ctrl+Alt+Space) ==
^!sc039::
WinGet, procName, ProcessName, A
excludedProcs := ["test135.exe", "test246.exe"]
for _, proc in excludedProcs
    if (procName = proc)
        return

WinGet, ExStyle, ExStyle, A
isTop := ExStyle & 0x8
WinSet, Alwaysontop, % isTop ? "off" : "on", A

WinGet, ExStyle, ExStyle, A
isTop := ExStyle & 0x8

WinGet, procName, ProcessName, A
msg := "Процес: " procName "`nAlwaysOnTop: " (isTop ? "Увімк." : "Вимк.")
ToolTip % msg

SetTimer, RemoveToolTip, -1500
return

RemoveToolTip:
ToolTip
return

; Символи через (Win+...)
#sc035::Send {U+2026} ; Win+/ (…)
#sc00C::Send {U+2014} ; Win+- (—)
#+sc00C::Send {U+2013} ; Win+Shift+- (–)
#+sc033::Send {U+00AB} ; Win+Shift+, («)
#+sc034::Send {U+00BB} ; Win+Shift+. (»)

; Авто-лапки «» з курсором всередині (Alt+Shift+, або .)
!+sc033::Send {U+00AB}{U+00BB}{Left}
!+sc034::Send {U+00AB}{U+00BB}{Left}
