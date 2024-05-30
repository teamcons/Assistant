
if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript")
    { $global:ScriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition }
else
    {$global:ScriptPath = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0]) 
    if (!$ScriptPath){ $global:ScriptPath = "." } }


#========================
# ENERGYDRINK
#<# 
ps2exe `
-inputFile $ScriptPath\sources\energydrink.ps1 `
-iconFile $ScriptPath\assets\soft-drink.ico `
-noConsole `
-noOutput `
-exitOnCancel `
-title "EnergyDrink" `
-description "Keep puter awake!" `
-company "teamcons" `
-copyright "GPL-3.0 Stella - stella.menier@gmx.de" `
-version 0.9 `
-Verbose `
-outputFile $ScriptPath\energydrink.exe
 #>

#========================
# ENERGYDRINK
#<# 
ps2exe `
-inputFile $ScriptPath\sources\warmedge.ps1 `
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
-outputFile $ScriptPath\warmedge.exe
