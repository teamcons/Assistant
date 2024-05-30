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
[byte]$hotcorner_sensitivity            = 40
[byte]$keypress_waittime                = 5



# This is very ugly
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

while ($true) {

    #[Windows.Forms.Cursor]::Position
    # If in the corner
    if ( ([Windows.Forms.Cursor]::Position.X -le $hotcorner_sensitivity) -and ([Windows.Forms.Cursor]::Position.Y -le $hotcorner_sensitivity))
    {
        # Trigger Windows + Tab (Overview)
        Write-Output "[HOT CORNER] Activated!"
        [KeySends.KeySend]::KeyDown("LWin")
        [KeySends.KeySend]::KeyUp("LWin")
        Start-Sleep -Seconds $keypress_waittime
    }
    
    Start-Sleep -Milliseconds $hotcorner_reactivity
}