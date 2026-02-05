; AutoHotkey v2
; v1.8 - Оптимізовано стабільність, прибрано конфліктний перезапуск
#NoTrayIcon
#SingleInstance Force
#UseHook True              ; Примусове використання хука (вирішує проблему "залипання")
InstallKeybdHook()         ; Встановлення хука клавіатури для кращого відстеження

iniFile := A_ScriptDir "\Hikaro.ini"
if !FileExist(iniFile)
    IniWrite("test13579.exe,test24680.exe", iniFile, "Excluded", "Processes")

IsTopMost(hwnd := "A") => (WinGetExStyle(hwnd) & 0x8) != 0

; --- Гарячі клавіші ---

^!sc039:: ; Ctrl+Alt+Space (AlwaysOnTop)
{
    procName := WinGetProcessName("A")
    list := IniRead(iniFile, "Excluded", "Processes", "")
    excludedProcs := (list = "") ? [] : StrSplit(Trim(list, " ,"), ",")
    
    for proc in excludedProcs
        if (procName = Trim(proc))
            return
            
    hwnd := WinExist("A")
    WinSetAlwaysOnTop(!IsTopMost(hwnd), hwnd)
    ToolTip("Процес: " procName "`nAlwaysOnTop: " (IsTopMost(hwnd) ? "Увімк." : "Вимк."))
    SetTimer(() => ToolTip(), -1500)
}

; --- Функція вставки символів ---

SendUnicode(code) {
    ; Чекаємо, поки користувач відпустить клавіші, щоб не було "залипання"
    KeyWait "Alt"
    KeyWait "Ctrl"
    SendText code ; SendText надійніший для юнікоду в v2
}

; --- Список комбінацій ---

!sc035:: SendUnicode("…")         ; Alt + /
!sc00C:: SendUnicode("—")         ; Alt + -
!+sc00C:: SendUnicode("–")        ; Alt + Shift + -
!sc033:: SendUnicode("«")         ; Alt + ,
!sc034:: SendUnicode("»")         ; Alt + .
!sc029:: SendUnicode("’")         ; Alt + ~
!sc009:: SendUnicode("°")         ; Alt + 8
!+sc033:: {                       ; Alt + Shift + ,
    SendText "«»"
    Send "{Left}"
}

; Дублювання для AltGr (правий Alt)
<^>!sc035:: SendUnicode("…")
<^>!sc00C:: SendUnicode("—")
<^>!+sc00C:: SendUnicode("–")
<^>!sc033:: SendUnicode("«")
<^>!sc034:: SendUnicode("»")
<^>!sc029:: SendUnicode("’")
<^>!sc009:: SendUnicode("°")
<^>!+sc033:: {
    SendText "«»"
    Send "{Left}"
}

; --- Автозапуск ---

AddShortcutToStartup() {
    shortcutPath := A_Startup "\" StrReplace(A_ScriptName, ".exe", "") ".lnk"
    if (A_Args.Length > 0 && A_Args[1] = "/bg")
        return

    if FileExist(shortcutPath) {
        if (MsgBox("Програма вже в автозапуску. Видалити?", "Hikaro Hotkeys", "YesNo") = "Yes") {
            FileDelete(shortcutPath)
            MsgBox("Видалено.")
            ExitApp()
        }
        return
    }
    
    FileCreateShortcut(A_ScriptFullPath, shortcutPath, A_WorkingDir, "/bg")
    MsgBox("Додано в автозапуск.")
}

AddShortcutToStartup()