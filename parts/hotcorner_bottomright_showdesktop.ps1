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

param(
    [int]$hotcorner_reactivity              = 400,   # In milliseconds - How often to check mouse location.
    [byte]$hotcorner_sensitivity            = 50    # In pixels - Size of hot corner area
    )

# Imports
Add-Type -AssemblyName System.Windows.Forms


# Calculate positions of the hot corner area
[int]$Bottom                            = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height
[int]$BottomInRange                     = ($Bottom - 48) # Size of bar

# Calculate positions of the hot corner area
[int]$Right                            = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width
[int]$RightInRange                     = ($Right - 16) # Do not use sensitivity : We risk activating on hovering date





    #==========================================
    #                Functions                =
    #==========================================

#========================================
# This is very ugly, but we cannot send "Meta + Tab" otherwise
# We basically code in another language what we need, and slorp it in our code as a function
#https://www.itcodar.com/csharp/sending-windows-key-using-sendkeys.html
$source = @"
using System;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using System.Windows.Forms;
namespace KeySends
{
    public class KeySend
    {
        [DllImport("user32.dll")]
        public static extern void keybd_event(byte bVk, byte bScan, int dwFlags, int dwExtraInfo);
        private const int KEYEVENTF_EXTENDEDKEY = 1;
        private const int KEYEVENTF_KEYUP = 2;
        public static void KeyDown(Keys vKey)
        {
            keybd_event((byte)vKey, 0, KEYEVENTF_EXTENDEDKEY, 0);
        }
        public static void KeyUp(Keys vKey)
        {
            keybd_event((byte)vKey, 0, KEYEVENTF_EXTENDEDKEY | KEYEVENTF_KEYUP, 0);
        }
    }
}
"@
Add-Type -TypeDefinition $source -ReferencedAssemblies "System.Windows.Forms"




    #=========================================
    #                MAINLOOP                =
    #=========================================

#========================================
# The test is Forever
while ($true)
{

    # If in the corner. We test for a range, because monitors on the left have negative X, monitors on top negative Y
    # "0" is the absolute corner of main screen.
    if (([Windows.Forms.Cursor]::Position.X -In $RightInRange..$Right) -and
        ([Windows.Forms.Cursor]::Position.Y -In $BottomInRange..$Bottom))
    {
        # Trigger Windows + Tab (Overview)
        Write-Output "[HOT CORNER] Activated!"
        #[Windows.Forms.Cursor]::Position
        [KeySends.KeySend]::KeyDown("LWin")
        [KeySends.KeySend]::KeyDown("D")
        [KeySends.KeySend]::KeyUp("LWin")
        [KeySends.KeySend]::KeyUp("D")


        # wait for people to leave the button
        Write-Output "[HOT CORNER] Wait for rearming..."
        while   (([Windows.Forms.Cursor]::Position.X -In $RightInRange..$Right) -and
                ([Windows.Forms.Cursor]::Position.Y -In $BottomInRange..$Bottom))
        {
            Start-Sleep -Milliseconds $hotcorner_reactivity
        }
        Write-Output "[HOT CORNER] Ready!"




    } # End of if hits the corner


    # If not in the corner, wait.
    # This could be without "else", with the effect for the hot corner to be slightly less reactive just after rearming
    else {
            # Wait before rechecking again.
            # Else we'd just burn the cpu checking constantly
            Start-Sleep -Milliseconds $hotcorner_reactivity
    }




} # End of testing forever without end