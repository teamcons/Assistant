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


# Imports
Add-Type -AssemblyName System.Windows.Forms

[int]$hotcorner_reactivity              = 500
[byte]$hotcorner_sensitivity            = 55
[byte]$keypress_waittime                = 5

[int]$Bottom = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height
[int]$BottomInRange = ($Bottom - $hotcorner_sensitivity)


# Test forever
while ($true)
{

    # If in the corner. We test for a range, because monitors on the left have negative X, monitors on top negative Y
    # "0" is the absolute corner of main screen.
    if (([Windows.Forms.Cursor]::Position.X -In 0..$hotcorner_sensitivity) -and
        ([Windows.Forms.Cursor]::Position.Y -In $BottomInRange..$Bottom))
    {
        # Trigger Windows + Tab (Overview)
        Write-Output "[HOT CORNER] Activated!"
        #[Windows.Forms.Cursor]::Position
        [System.Windows.Forms.SendKeys]::SendWait('^{ESC}')
        Start-Sleep -Seconds $keypress_waittime
    }
    

    Start-Sleep -Milliseconds $hotcorner_reactivity
}