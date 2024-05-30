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


# Imports
Add-Type -AssemblyName System.Windows.Forms

[int]$hotcorner_reactivity              = 500
[byte]$hotcorner_sensitivity            = 20
[byte]$keypress_waittime                = 5



# This is very ugly, but we cannot send "Meta + Tab" otherwise
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



# Test forever
while ($true)
{

    #[Windows.Forms.Cursor]::Position
    # If in the corner. We test for a range, because monitors on the left have negative X, monitors on top negative Y
    # "0" is the absolute corner of main screen.
    if (([Windows.Forms.Cursor]::Position.X -In 0..$hotcorner_sensitivity) -and
        ([Windows.Forms.Cursor]::Position.Y -In 0..$hotcorner_sensitivity))
    {
        # Trigger Windows + Tab (Overview)
        Write-Output "[HOT CORNER] Activated!"
        #[Windows.Forms.Cursor]::Position
        [KeySends.KeySend]::KeyDown("LWin")
        [KeySends.KeySend]::KeyDown("Tab")
        [KeySends.KeySend]::KeyUp("LWin")
        [KeySends.KeySend]::KeyUp("Tab")
        Start-Sleep -Milliseconds $hotcorner_reactivity
    }
    
    Start-Sleep -Milliseconds $hotcorner_reactivity
}