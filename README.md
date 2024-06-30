# Hey Quick Keyboard v1.2

Hey Quick Keyboard is an AutoHotkey script that adds useful shortcuts and improves computer usability on Windows. With this script, you can use the numpad keys, tab keys, screenshot key, power keys, mouse keys, and more with different key combinations on your keyboard. For laptop users, it allows effortless navigation in 3D modeling software through keyboard shortcuts that simulate mouse middle-click and numpad functions.

<meta name="description" content="Enhance your Windows computer usability with Hey Quick Keyboard, an AutoHotkey script that provides useful shortcuts for numpad, tab, screenshot, power, and mouse operations.">
<meta name="keywords" content="AutoHotkey, Windows shortcuts, keyboard shortcuts, shutdown timer, computer usability, numpad, tab, screenshot, power, mouse, Hey Quick Keyboard, blender with laptop keyboard, unity with laptop keyboard">
<meta name="author" content="Halil Emre Yildiz">

## Features

- You can toggle the script on or off with Win + CapsLock (It is enabled by default.)
- To use the numpad keys, you can press the number keys from 0 to 9 without pressing Shift, Win or AltGr keys. You can also create Alt codes with the Alt key and use numpad operators, please check the [Shortcuts](#shortcuts) section below.
- To use the tab keys, you can use Pause for switch a window that displays all open windows, PgUp and PgDn switches between open windows in Windows from left to right or the opposite.
- To take a screenshot of the entire screen and saves it to the Pictures\Screenshots folder, you can use PrtSc. And Ctrl + PrtSc takes a screenshot and copies it to the clipboard.
- For Windows operations, Ctrl + Alt + F4 force quit the active window, Win + F5 restarts Explorer and clears temp files.
- For power operations, Win + F1 opens hibernate timer, Win + F2 opens restart timer, Win + F3 opens sleep timer, Win + F4 opens shutsdown timer and Win + F6 opens logout timer.
- For mouse operations, you can use the Menu Key as a middle click and Left Alt + arrow keys as a scroll wheel for mouse operations. To move the mouse, use RCtrl + Arrows. To click, use RCtrl + Z for left click, RCtrl + Y for middle click, and RCtrl + C for right click.
- You can turn off the screen witg Win + F12 and turn it on with Win + ESC.
- You can quickly ask questions to the AI ​​with Windows + C via [Hey Chat VBS](https://github.com/JahnStar/Hey-Chat-VBS) and play a role in MsgBox.
- Added hot corners for desktops and apps.

## Installation

To run this script, you just need to execute the "HeyQuickKeyboard.exe". If you want to run the script automatically on Windows startup, you can right-click on the icon in the lower right corner and check the "Run on Startup" option.

## Usage

You can find all the shortcuts that this script provides in the [Shortcuts](#shortcuts) section below. You can also quickize or change any of these shortcuts by editing the script file with a text editor and compile with [Ahk2Exe](https://github.com/AutoHotkey/Ahk2Exe).

## Hotkeys

| Key Combination | Function | Action |
| ---- | ---- | ---- |
| **-Windows-** | Manage windows or tasks | Close, restart, or clear windows or processes |
| Win + C | Ask AI with [Hey Chat VBS](https://github.com/JahnStar/Hey-Chat-VBS) | Quickly ask the selected text and speak to the AI |
| Win + S | Text to Speech | Speech selected text using Narrator |
| Win + F | Quick Search | Search selected text on google |
| Win + T | Quick Translate | Translate selected text with google translate |
| Ctrl + Alt + F4 | Taskkill | Force quit the current window or application |
| Win + F5 | Restart Explorer | Restart the Explorer to refresh the desktop and taskbar |
| Win + F5 (As Admin) | Clear Temp Files (As Admin) | Delete temporary files with [Clear-TempFiles.ps1](https://github.com/Bromeego/Clean-Temp-Files/) |
| Win + F12 | Turn off the display | Lock and turn screen off |
| Win + ESC | Turn on the display | Unlock and turn screen on |
| **-Power-** | Set a timer for power options | Apply power actions after a specific time |
| Win + F1 | Hibernate Timer | Set a timer to Hibernate after a specified time |
| Win + F2 | Restart Timer | Set a timer to Restart after a specified time |
| Win + F3 | Sleep Timer | Set a timer to Sleep after a specified time |
| Win + F4 | Shutdown Timer | Set a timer to Shutdown after a specified time |
| Win + F6 | Logout Timer | Set a timer to Logout after a specified time |
| **-Tab-** | Switch between windows or tabs | Cycle through open applications or browser tabs |
| Pause | Ctrl + Shift + Tab | Switch and display windows |
| PgUp | Alt + Tab | Switch to the previous window |
| PgDn | Alt + Shift + Tab | Switch to the next window |
| **-Screenshot-** | Capture the screen or a part of it | Save or copy an image of the screen |
| PrtSc | Win + PrtSc | Take a screenshot and save it in the Pictures folder |
| Ctrl + PrtSc | PrtSc | Take a screenshot and copy it to the clipboard |
| **-Numpad-** | Emulate the numpad keys | Type numbers or symbols |
| Win + CapsLock | Suspend | Toggle the script on or off |
| 0-9 (without Shift, Win or AltrGr) | Numpad 0-9 | Type numbers from 0 to 9 |
| Alt + . | Numpad . | Type a decimal point |
| Alt + / | Numpad / | Type a division sign |
| Alt + - | Numpad - | Type a subtraction sign |
| Alt + , | Numpad + | Type an addition sign |
| Ctrl + - | Ctrl + Numpad - | Zoom out |
| Ctrl + , | Ctrl + Numpad + | Zoom in |
| **-Mouse-** | Emulate the mouse buttons or wheel | Click or scroll with the keyboard |
| RCtrl + Arrows | Mouse movement | Move the mouse cursor with the arrow keys |
| RCtrl + M | Jump to the Middle | Move the mouse cursor in the middle |
| RCtrl + Z | Left Click | Perform a mouse left click |
| RCtrl + Y / Menu Key | Middle Click | Perform a mouse middle click |
| RCtrl + C | Right Click | Perform a mouse right click |
| Ctrl + Alt + Up/Down Arrow | Scroll Wheel | Scroll up or down |
|  |  |  |

### Note

HeyQuickKeyboard.exe is not a virus: Defender may flag the compiled .exe as a virus due to the nature of AutoHotkey scripts.
To verify, compile from the .ahk using AHK2Exe.

## Contact

If you have any questions, suggestions or feedback about this script, please contact me on [Github].

## License

MIT License

Copyright (c) 2023 Halil Emre Yildiz

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
