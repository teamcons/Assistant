
if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript")
    { $global:ScriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition }
else
    {$global:ScriptPath = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0]) 
    if (!$ScriptPath){ $global:ScriptPath = "." } }


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
<# 
#========================
# ENERGYDRINK
#<# 
ps2exe `
-inputFile $ScriptPath\functionalities\hotcorner_topleft.ps1 `
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
-outputFile $ScriptPath\functionalities\hotcorner_topleft.exe


ps2exe `
-inputFile $ScriptPath\functionalities\hotcorner_winbutton.ps1 `
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
-outputFile $ScriptPath\functionalities\hotcorner_winbutton.exe


ps2exe `
-inputFile $ScriptPath\functionalities\keepawake.ps1 `
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
-outputFile $ScriptPath\functionalities\keepawake.exe #>