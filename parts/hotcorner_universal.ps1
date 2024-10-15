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
    [string]$hotcorner_where                = "topleft",
    [string]$hotcorner_what                 = "overview",
    [int]$hotcorner_reactivity              = 400,   # In milliseconds - How often to check mouse location.
    [byte]$hotcorner_sensitivity            = 30    # In pixels - Size of hot corner area
    )




    #==========================================
    #                Functions                =
    #==========================================

#========================================
# This is very ugly, but we cannot send "Meta + Stuff" otherwise and it gives much more flexibility than proper powershell
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
Add-Type -AssemblyName System.Windows.Forms




# Take where the user wants their hotcorner
# Calculate from there the screen region to keep watch of
switch ($hotcorner_where)
{
    "topleft" {
        $X_from     = 0
        $X_to       = $hotcorner_sensitivity
        $Y_from     = 0
        $Y_to       = $hotcorner_sensitivity

      }
    "topright" {
        $X_from     = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width - $hotcorner_sensitivity
        $X_to       = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width
        $Y_from     = 0
        $Y_to       = $hotcorner_sensitivity

      }
    "bottomright" {
        $X_from     = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width - $hotcorner_sensitivity
        $X_to       = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width
        $Y_from     = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height - $hotcorner_sensitivity
        $Y_to       = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height
      }
    "bottomleft" {
        $X_from     = 0
        $X_to       = $hotcorner_sensitivity
        $Y_from     = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height - $hotcorner_sensitivity
        $Y_to       = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height

      }
}



# Take what the user want to activate
# Define key combos for it
# We dont want a function which tests each time everything, thats useless
# So we define a function depending on what we need

# Some keycodes: https://learn.microsoft.com/en-us/office/vba/language/reference/user-interface-help/keycode-constants
switch ($hotcorner_what) {


    "overview"    # Win + tab
    {
        function action {
            [KeySends.KeySend]::KeyDown("LWin")
            [KeySends.KeySend]::KeyDown("Tab")
            [KeySends.KeySend]::KeyUp("LWin")
            [KeySends.KeySend]::KeyUp("Tab")
        }
    }


    "winbutton"    # Win
    {
        function action {
            [KeySends.KeySend]::KeyDown("LWin")
            [KeySends.KeySend]::KeyUp("LWin")
        }
    }


    "showdesktop"   # Win + D
    {
        function action {
            [KeySends.KeySend]::KeyDown("LWin")
            [KeySends.KeySend]::KeyDown("D")
            [KeySends.KeySend]::KeyUp("LWin")
            [KeySends.KeySend]::KeyUp("D")
        }
    }

    "desktopright"  # Win + Ctrl + Right arrow
    {
        function action {
            [KeySends.KeySend]::KeyDown("LWin")
            [KeySends.KeySend]::KeyDown(0x11)
            [KeySends.KeySend]::KeyDown(0x27)
            [KeySends.KeySend]::KeyUp("LWin")
            [KeySends.KeySend]::KeyUp(0x11)
            [KeySends.KeySend]::KeyUp(0x27)            
        }
    }

    "desktopleft"   # Win + Ctrl + Left arrow
    {
        function action {
            [KeySends.KeySend]::KeyDown("LWin")
            [KeySends.KeySend]::KeyDown(0x11)
            [KeySends.KeySend]::KeyDown(0x25)
            [KeySends.KeySend]::KeyUp("LWin")
            [KeySends.KeySend]::KeyUp(0x11)
            [KeySends.KeySend]::KeyUp(0x25)            
        }
    }


    "closewindow"    # Alt + F4
    {
        function action {
            [System.Windows.Forms.SendKeys]::SendWait('%{F4}')
        }
    }


    "showclipboard"  # Win + V
    {
        function action {
            [KeySends.KeySend]::KeyDown("LWin")
            [KeySends.KeySend]::KeyDown("V")
            [KeySends.KeySend]::KeyUp("LWin")
            [KeySends.KeySend]::KeyUp("V")
        }
    }


    "smallerwindow"   # Win + Down arrow
    {
        function action {
            [KeySends.KeySend]::KeyDown("LWin")
            [KeySends.KeySend]::KeyDown(0x28)
            [KeySends.KeySend]::KeyUp("LWin")
            [KeySends.KeySend]::KeyUp(0x28)            
        }
    }

    "screenshot"   # Printscreen
    {
        function action {
            [KeySends.KeySend]::KeyDown(0x2A)
            [KeySends.KeySend]::KeyUp(0x2A)            
        }
    }

    "capslock"   # Capslock
    {
        function action {
            [KeySends.KeySend]::KeyDown(0x14)
            [KeySends.KeySend]::KeyUp(0x14)            
        }
    }

    "alttab"   # Alttab
    {
        function action {
            [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')       
        }
    }
}








    #=========================================
    #                MAINLOOP                =
    #=========================================

#========================================
# The test is Forever
while ($true)
{

    # If in the corner. We test for a range, because monitors on the left have negative X, monitors on top negative Y
    # "0" is the absolute corner of main screen.
    if (([Windows.Forms.Cursor]::Position.X -In $X_from..$X_to) -and
        ([Windows.Forms.Cursor]::Position.Y -In $Y_from..$Y_to))
    {
        # Trigger
        Write-Output "[HOT CORNER] Activated!"
        action


        # wait for people to leave the button
        # Else depending on reactivity we'd just spam the keypress
        Write-Output "[HOT CORNER] Wait for rearming..."
        while   (([Windows.Forms.Cursor]::Position.X -In $X_from..$X_to) -and
                ([Windows.Forms.Cursor]::Position.Y -In $Y_from..$Y_to))
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