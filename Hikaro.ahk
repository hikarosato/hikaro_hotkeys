; AutoHotkey v2
; Made by Hikaro/Галицький Розбишака
; v1.5

#NoTrayIcon
#SingleInstance Force

iniFile := A_ScriptDir "\Hikaro.ini" ; Файл виключення з правил для AlwaysOnTop функції

if !FileExist(iniFile)
{
    IniWrite("test13579.exe,test24680.exe", iniFile, "Excluded", "Processes")
}

; Допоміжна функція
IsTopMost(hwnd := "A")
{
    return (WinGetExStyle(hwnd) & 0x8) != 0
}

^!sc039:: ; Завжди поверх інших вікон (Ctrl+Alt+Space)
{
    procName := WinGetProcessName("A")
    list := IniRead(iniFile, "Excluded", "Processes", "")
    
    ; Валідація INI (щоб не впав, якщо файл зіпсований чи порожній)
    if (list = "")
        excludedProcs := []
    else
        excludedProcs := StrSplit(Trim(list, " ,"), ",")

    ; Перевірка чи процес виключений
    for proc in excludedProcs
        if (procName = Trim(proc))
            return

    ; Перемикання стану AlwaysOnTop
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

AddShortcutToStartup() ; Створення/видалення ярлика у автозапуску
{
    exePath := A_ScriptFullPath
    startupFolder := A_Startup
    shortcutName := StrReplace(A_ScriptName, ".exe", "") ".lnk"
    shortcutPath := startupFolder "\" shortcutName

    if FileExist(shortcutPath)  ; Ярлик існує
    {
        FileGetShortcut(shortcutPath, &targetPath)

        ; Якщо ярлик вказує на цей скрипт
        if (targetPath = exePath)
        {
            ; Перевіряємо, чи запущено НЕ з теки автозапуску
            if (A_ScriptDir != startupFolder)
            {
                FileDelete(shortcutPath)
                MsgBox("Програма видалена з автозапуску Windows та буде закрита.", "Hikaro Hotkeys", 0)
                ExitApp
            }
            return
        }
        else
        {
            ; Якщо ярлик був від іншої версії — оновлюємо
            FileDelete(shortcutPath)
        }
    }
    else
    {
        ; ярлик ще не існує, перший запуск
        FileCreateShortcut(exePath, shortcutPath, A_WorkingDir, "", "", exePath, 0)
		MsgBox(
			"Програма автоматично прописана в автозапуск Windows.`n`n"
			. "Для видалення з автозапуску та закриття програми`nзапустіть .exe ще раз.",
			"Hikaro Hotkeys", 0)
    }
}

AddShortcutToStartup()

; Символи
!sc035::Send("{U+2026}") ; Alt+/ (…)
!sc00C::Send("{U+2014}") ; Alt+- (—)
!+sc00C::Send("{U+2013}") ; Alt+Shift+- (–)
!sc033::Send("{U+00AB}") ; Alt+, («)
!sc034::Send("{U+00BB}") ; Alt+. (»)
!sc003::Send("{U+2019}") ; Alt+2 (’)
!sc009::Send("{U+00B0}") ; Alt+8 (°)
!+sc033::Send("{U+00AB}{U+00BB}{Left}") ; «» з курсором усередині (Alt+Shift+,)

; На випадок використання розкладки Укр (розшир.)
<^>!sc035::Send("{U+2026}") ; AltGr+/ (…)
<^>!sc00C::Send("{U+2014}") ; AltGr+- (—)
<^>!+sc00C::Send("{U+2013}") ; AltGr+Shift+- (–)
<^>!sc033::Send("{U+00AB}") ; AltGr+, («)
<^>!sc034::Send("{U+00BB}") ; AltGr+. (»)
<^>!sc003::Send("{U+2019}") ; AltGr+2 (’)
<^>!sc009::Send("{U+00B0}") ; AltGr+8 (°)
<^>!+sc033::Send("{U+00AB}{U+00BB}{Left}") ; «» з курсором усередині (AltGr+Shift+,)
