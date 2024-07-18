
if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript")
    { $global:ScriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition }
else
    {$global:ScriptPath = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0]) 
    if (!$ScriptPath){ $global:ScriptPath = "." } }

<# 
#========================
# ENERGYDRINK
#<# 
ps2exe `
-inputFile $ScriptPath\Assistant.ps1 `
-iconFile $ScriptPath\assets\soft-drink.ico `
-noConsole `
-noOutput `
-exitOnCancel `
-title "Assistant" `
-description "Helps you" `
-company "teamcons" `
-copyright "GPL-3.0 Stella - stella.menier@gmx.de" `
-version 0.9 `
-Verbose `
-outputFile $ScriptPath\Assistant.exe
 #>

#========================
# ENERGYDRINK

<# 

ps2exe `
-inputFile $ScriptPath\parts\hotcorner_topleft.ps1 `
-iconFile $ScriptPath\assets\soft-drink.ico `
-noConsole `
-noOutput `
-exitOnCancel `
-title "Hotcorner topleft" `
-description "Top left hot corner" `
-company "teamcons" `
-copyright "GPL-3.0 Stella - stella.menier@gmx.de" `
-version 0.9 `
-Verbose `
-outputFile $ScriptPath\parts\hotcorner_topleft.exe



ps2exe `
-inputFile $ScriptPath\parts\hotcorner_winbutton.ps1 `
-iconFile $ScriptPath\assets\soft-drink.ico `
-noConsole `
-noOutput `
-exitOnCancel `
-title "Warm edge" `
-description "Top left hot corner" `
-company "teamcons" `
-copyright "GPL-3.0 Stella - stella.menier@gmx.de" `
-version 0.9 `
-Verbose `
-outputFile $ScriptPath\parts\hotcorner_winbutton.exe

ps2exe `
-inputFile $ScriptPath\parts\hotcorner_bottomright_showdesktop.ps1 `
-iconFile $ScriptPath\assets\soft-drink.ico `
-noConsole `
-noOutput `
-exitOnCancel `
-title "Warm edge" `
-description "Bottom right show desktop" `
-company "teamcons" `
-copyright "GPL-3.0 Stella - stella.menier@gmx.de" `
-version 0.9 `
-Verbose `
-outputFile $ScriptPath\parts\hotcorner_bottomright_showdesktop.exe


ps2exe `
-inputFile $ScriptPath\parts\hotcorner_topright_close.ps1 `
-iconFile $ScriptPath\assets\soft-drink.ico `
-noConsole `
-noOutput `
-exitOnCancel `
-title "Warm edge" `
-description "Top right close active window" `
-company "teamcons" `
-copyright "GPL-3.0 Stella - stella.menier@gmx.de" `
-version 0.9 `
-Verbose `
-outputFile $ScriptPath\parts\hotcorner_topright_close.exe



ps2exe `
-inputFile $ScriptPath\parts\keepawake.ps1 `
-iconFile $ScriptPath\assets\soft-drink.ico `
-noConsole `
-noOutput `
-exitOnCancel `
-title "Warm edge" `
-description "Top left hot corner" `
-company "teamcons" `
-copyright "GPL-3.0 Stella - stella.menier@gmx.de" `
-version 0.9 `
-Verbose `
-outputFile $ScriptPath\parts\keepawake.exe

 #> #>

ps2exe `
-inputFile $ScriptPath\parts\doOCR.ps1 `
-iconFile $ScriptPath\assets\soft-drink.ico `
-noConsole `
-noOutput `
-exitOnCancel `
-title "do OCR" `
-description "OCR on the screen, output to clipboard" `
-company "teamcons" `
-copyright "GPL-3.0 Stella - stella.menier@gmx.de" `
-version 0.9 `
-Verbose `
-outputFile $ScriptPath\parts\doOCR.exe