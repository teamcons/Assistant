


<p align="center">
  <img width="15%" align="center" src="assets/virtual-assistant.png" alt="logo">
</p>
  <h1 align="center">Assistant</h1>
<p align="center">
  A small utility sitting in the tray
</p>

A small utility sitting in the tray, which offers several handy functions lacking for windows, like hot corners, clipboard management, caffeine...

It runs on Windows Forms, and has a .exe file. You dont need special rights to start it, you dont need to install it, just put it somewhere where it wont move.


### Done and tested
- Keep awake: Toggle between preventing computer to go to sleep or not
- Hot corner overview : Hitting the top left edge triggers an overview
- Hot corner hover meta : Hitting the botton left (windows logo) opens the start menu
- Hot corner show desktop : Hitting bottom right shows desktop
- Autostart : Start Assistant with Windows
- Settings : Edit the settings file to change stuff. Careful of following powershell syntax or it breaks
- Clipboard manager : Remembers past copied elements and toggle between them. Useful if you need to copy paste
- Localization (I can German, French, and Spanish, only. Itd detect if the puter use those languages)
- Saves state : Remembers what was enabled or not
- OCR from screen

### Todo, maybe, idk
- Switch clipboard entries by scrolling on icon in tray, with a tooltip to say what new latest entry is
- Better localizations
- Paste in rapid succession to cycle through clipboard entries quickly ?
- Timer/"Make some tea" ? or Pomodoro mode ?


<table align="center" border="none">
      <td><img src="https://github.com/teamcons/Assistant/blob/main/images/Screenshot.png" /></td>
      <td><img src="https://github.com/teamcons/Assistant/blob/main/images/Screenshot with OCR and german.png" /></td>
</table>


# 💺 "Installation"

On the right on this page, go on "releases"

Download the zip folder

Uncompress it

Doubleclick on Assistant.exe

A notification should poke you to tell you Assistant has started

The exe does not work on its own, it needs the other folders
The hot corners needs their own separate executables. They do not work as background process. You can use them alone, but then need the task manager to stop them (no UI)



# 📚 Documentation


### Copy from OCR

Opens the screenshot assistant, so you can select a zone.
It will then use Windows integrated OCR engine to extract text from it.
And then put it in clipboard.

NOTE: This may make the antivirus panic a lil bit. That is because windows doesnt like random scripts accessing the screen.
You can check the sourcecode yourself, there is no funny business.

### Clipboard history

Shows the last 6 copied elements.
Click on any item to have it be the last (the one you get when pasting)
You can clear clipboard history by clicking on "Clear history"

This uses Windows native feature (what you get with Meta+V) to retrieve history

Double-clicking on the icon tray sets your clipboard as the second latest thing you copied


### Hot corners
Hot corners are zones on the screen which activates something when touched. This is useful if you want to have something by just throwing your mouse at it

 - #### Top left: Overview
Hit the top left edge of the screen.
An overview of all windows and virtual desktops will appear.
Hit it a second time to go back, or click on any window

 - #### Bottom left: Show start menu

Hover the windows logo in the bottom right.
The start menu will appear


 - #### Bottom right: Show desktop

Hit the mouse in the bottom left of the screen, that is where the "show desktop" mini button is.
It will at first hide all windows to show the desktop
hit it a second time to make all windows reappear

 - #### Top right: Close active window

Hit the mouse in the top right of the screen to close the current focused window (NOT the maximized one)
This is Alt+F4 with extra steps, so you should get a window asking for saving if it is something like Word
By default the hot corner is smaller and less reactive, in case of accidental movements


### Keep awake
When activated, the computer is prevented to go to sleep. The screen stays on.


### Start with puter
Create a shortcut in the autostart folder. If theres already one, theres a check
When Windows starts up, Assistant will start too.


# 🦺 Known bugs
Does not quit super cleanly : There is still a zombie process running, it does nothing nor take resources but locks the file so nobody can delete or move it until the process is killed, or not started at all when the puter starts




# 👌 Acknowledgments

Had a look through various sources for having a tray icon. Thanks to all of these !
- https://github.com/damienvanrobaeys/Build-PS1-Systray-Tool
- https://www.systanddeploy.com/2018/12/create-your-own-powershell.html
- https://stackoverflow.com/questions/54649456/powershell-notifyicon-context-menu
- https://adamtheautomator.com/powershell-async/


Clipboard history module by mutaguchi
https://gist.github.com/mutaguchi/019ad33e156637585a22a656d8fd3f46

Jason
https://gist.github.com/jhochwald/56cf0897fa6b82e65f12

OCR
https://github.com/daijro/PsOCRCapture

This blog for localization and its example github
https://plattsoft.net/2015/08/24/internationalization-with-import-localizeddata/
https://github.com/platta/plattsoft_PSUICultureExample

The adorable icon
<a href="https://www.flaticon.com/free-icons/virtual-assistant" title="virtual assistant icons">Virtual assistant icons created by Freepik - Flaticon</a>

OCR
<a href="https://www.flaticon.com/free-icons/ocr" title="ocr icons">Ocr icons created by Freepik - Flaticon</a>