

# 💽 Assistant

### All the stuff

A small utility which offers several functions lacking for windows

### Done and tested
- Keep awake: Toggle between preventing computer to go to sleep or not
- Hot corner top left : Hitting the top left edge triggers an overview
- Hot corner hover meta : Hitting the botton left (windows logo) opens the start menu
- Autostart : Start Assistant with Windows
- Settings : Edit the settings file to change stuff
- Summon windows clipboard manager


### Todo, maybe, idk
- Have a settings GUI, or at least an entry to open the file in an editor
- Localization. I have to centralize text in a module, for that, first


  <table align="center" border="none">
      <td><img src="https://github.com/teamcons/Assistant/blob/main/images/Screenshot.png"" /></td>
</table>


# Installation

On the right on this page, go on "releases"
Download the zip folder
Uncompress it
Click on Assistant.exe
A notification should poke you to tell you Assistant has started

The exe does not work on its own, it needs the other folders


# Documentation

### View clipboard

Simulate Meta + V to open the clipboard manager and see past entries
Useless if you know of the shortcut, but nice


### Hot corner: Top left
The program constantly checks whether the mouse is in the top left
Simulate Meta + D

### Hot corner: Hover meta

The program constantly checks whether the mouse is in the bottom
Simulates Meta

### Keep awake

The computer is prevented to go to sleep by simulating a keypress on F15.
This key shouldnt be used by any program nor appear on the keyboard but... If there is weird behavior it could come from here.


### Start with puter
Create a shortcut in the autostart folder. If theres already one, theres a check


# Known bugs

Does not quit super cleanly : There is still a zombie process running, it does nothing nor take resources but locks the file.




# Acknowledgments

Had a look through various sources for having a tray icon. Thanks to all of these !
- https://github.com/damienvanrobaeys/Build-PS1-Systray-Tool
- https://www.systanddeploy.com/2018/12/create-your-own-powershell.html
- https://stackoverflow.com/questions/54649456/powershell-notifyicon-context-menu
- https://adamtheautomator.com/powershell-async/

The icons are from the same website... I should do my owns. Thanks nonetheless !

The soda can icon
<a href="https://www.flaticon.com/free-icons/soda" title="soda icons">Soda icons created by Chanut-is-Industries - Flaticon</a>



