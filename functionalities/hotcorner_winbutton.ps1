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

[int]$hotcorner_reactivity              = 500   # In milliseconds - How often to check mouse location.
[byte]$hotcorner_sensitivity            = 50    # In pixels - Size of hot corner area
[byte]$keypress_waittime                = 2     # In seconds - How long before rearming hot corner

# Calculate positions of the hot corner area
[int]$Bottom = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height
[int]$BottomInRange = ($Bottom - $hotcorner_sensitivity)


# We check a bit further on X, because the button is off center
# This way the hot corner is a real "hover over windows logo" button
[int]$RightSide = ($hotcorner_sensitivity + 5)


# Test forever
while ($true)
{

    # If in the corner. We test for a range, because monitors on the left have negative X, monitors on top negative Y
    # "0" is the absolute corner of main screen.
    if (([Windows.Forms.Cursor]::Position.X -In 0..$RightSide ) -and
        ([Windows.Forms.Cursor]::Position.Y -In $BottomInRange..$Bottom))
    {
        # Trigger Windows + Tab (Overview)
        Write-Output "[HOT CORNER] Activated!"
        #[Windows.Forms.Cursor]::Position
        [System.Windows.Forms.SendKeys]::SendWait('^{ESC}')
        Start-Sleep -Seconds $keypress_waittime
    }
    
    # Wait before rechecking again.
    Start-Sleep -Milliseconds $hotcorner_reactivity
}