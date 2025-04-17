# Hikaro_hotkeys
Альтернатива встановленню Unicode-розкладок на Windows.

Особливості:
- Встановлення не потрібне: працює у фоні, не виводиться в лотку, закривається через Диспетчер завдань (оскільки планувалась робота 24/7 — зайва піктограма в треї не потрібна).
- Використовуються скан-коди клавіш для уникнення проблем із різними розкладками клавіатури.
- Функція встановлення будь-якого вікна програми завжди поверх інших — зручно, щоб не постійно Alt+Tab-атись, наприклад, на месенджер.
- Сповіщення біля курсора на 1,5 секунди з назвою процесу та станом AlwaysOnTop — на випадок хибного натискання.
- Можливість додати власні назви процесів до списку виключень для функції AlwaysOnTop через файл **Hikaro.ini** (створюється поруч із **.exe** після запуску).
- Автоматично створює ярлик на себе в теці **Автозавантаження** для старту разом із Windows. Перевіряє його валідність і автоматично виправляє у разі зміни розташування **.exe**.

| Комбінація  | Результат |
| - | - |
| `Ctrl`+`Alt`+`Space` | Активне вікно завжди поверх інших. Перемикається. |
| `Alt`+`/`  | … |
| `Alt`+`-`  | — |
| `Alt`+`Shift`+`-` | – |
| `Alt`+`,` | « |
| `Alt`+`.` | » |
| `Alt`+`2` | ’ (апостроф) |
| `Alt`+`8` | ° |
| `Alt`+`Shift`+`,` | «» курсор переміщається всередину лапок для подальшого друку. |

Завантажуйте готову програму у **Releases** або скомпілюйте самостійно.
