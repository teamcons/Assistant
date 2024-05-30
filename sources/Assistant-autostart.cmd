
#%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\startup.cmd

#PowerShell -Command "Set-ExecutionPolicy Unrestricted CurrentUser" >> "%TEMP%\StartupLog.txt" 2>&1
PowerShell %USERPROFILE%\Desktop\script.ps1 >> "%TEMP%\StartupLog.txt" 2>&1