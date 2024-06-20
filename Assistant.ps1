#================================================================================================================================

#----------------INFO----------------
#
# CC-BY-SA-NC Stella Ménier <stella.menier@gmx.de>
# Project creator for Skrivanek GmbH
#
# Usage: powershell.exe -executionpolicy bypass -file ".\Rocketlaunch.ps1"
# Usage: Compiled form, just double-click.
#
#-------------------------------------


    #===============================================
    #                Initialization                =
    #===============================================

#========================================
# Get all important variables in place 

# Grab script location in a way that is compatible with PS2EXE
if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript")
    { $global:ScriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition }
else
    {$global:ScriptPath = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0]) 
    if (!$ScriptPath){ $global:ScriptPath = "." } }





# When executed at windows start, location is not in the script folder
Set-Location -Path $ScriptPath


# Load and parse the JSON configuration file
$script:settings = Get-Content $ScriptPath\parts\state.json -Raw -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue | ConvertFrom-Json -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue

# legacy #$script:settings = Import-LocalizedData -FileName settings.psd1 -BaseDirectory $ScriptPath\parts


# Get localization
$script:text = Import-LocalizedData -FileName interface.psd1 -BaseDirectory $ScriptPath\localizations

# Load everything we need
#Import-Module $ScriptPath\parts\text.ps1
Import-Module $ScriptPath\parts\utils.ps1
Import-Module $ScriptPath\parts\UI.ps1




    #===============================================
    #                Initialization                =
    #===============================================

#========================================
# Get all important variables in place 



# Start the subprocesses
if ($settings.TopLeftOverview.Enabled -eq "true")
{
    Start-Process -FilePath $ScriptPath\parts\hotcorner_topleft.exe -ArgumentList $settings.TopLeftOverview.reactivity,$settings.TopLeftOverview.sensitivity 
    $Menu_Toggle_HotCorner_TopLeft.Checked          = $true
}

if ($settings.WindowsButton.Enabled -eq "true") 
{
    Start-Process  -FilePath $ScriptPath\parts\hotcorner_winbutton.exe -ArgumentList $settings.WindowsButton.reactivity,$settings.WindowsButton.sensitivity
    $Menu_Toggle_HotCorner_WinButton.Checked = $true
}


if ($settings.ShowDesktop.Enabled -eq "true") 
{
    Start-Process  -FilePath $ScriptPath\parts\hotcorner_bottomright_showdesktop.exe -ArgumentList $settings.ShowDesktop.reactivity,$settings.ShowDesktop.sensitivity
    $Menu_Toggle_HotCorner_ShowDesktop.Checked = $true
}

if ($settings.CloseActiveWindow.Enabled -eq "true") 
{
    Start-Process  -FilePath $ScriptPath\parts\hotcorner_topright_close.exe -ArgumentList $settings.CloseActiveWindow.reactivity,$settings.CloseActiveWindow.sensitivity
    $Menu_Toggle_HotCorner_Close.Checked = $true
}


if ($settings.KeepAwake.Enabled -eq "true")
{
    Start-Process -FilePath $ScriptPath\parts\keepawake.exe
    $Menu_Toggle_KeepAwake.Checked = $true
    $Main_Tool_Icon.Icon = $icon
}
else {
    $Main_Tool_Icon.Icon = $icondark
}


# Tell user we started
$Main_Tool_Icon.BalloonTipTitle = $text.TopUI.NotifyStartTitle
$Main_Tool_Icon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
$Main_Tool_Icon.BalloonTipText = $text.TopUI.NotifyStartText
$Main_Tool_Icon.Visible = $true
$Main_Tool_Icon.ShowBalloonTip(200)



# Force garbage collection just to start slightly lower RAM usage.
[System.GC]::Collect()

# Create an application context for it to all run within.
# This helps with responsiveness, especially when clicking Exit.
$appContext = New-Object System.Windows.Forms.ApplicationContext
[void][System.Windows.Forms.Application]::Run($appContext)


