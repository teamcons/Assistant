#================================================================================================================================

#----------------INFO----------------
#
# CC-BY-SA-NC Stella Ménier <stella.menier@gmx.de>
# Hot corners
#
# Usage: powershell.exe -executionpolicy bypass -file ".\hotcorner.ps1"
# CTRL-C to stop it
#
#-------------------------------------


    #===============================================
    #                Initialization                =
    #===============================================

#========================================
# Get all important variables in place 

# Needed at start for OCR
using namespace Windows.Graphics.Imaging

param(
    [string]$hotcorner_where                = "topleft",
    [string]$hotcorner_what                 = "overview",
    [int]$hotcorner_reactivity              = 400,   # In milliseconds - How often to check mouse location.
    [byte]$hotcorner_sensitivity            = 30    # In pixels - Size of hot corner area
    )


if ($hotcorner_where -eq "help")
{

    Write-Host @"
Hot corner for Windows
by Stella Ménier - stella.menier@gmx.de

Usage:
.\hotcorner.ps1 where what reactivity sensitivity

**Where:** Where the hot corner is situated
-    topleft: Top, left corner of the screen
-    topright: Top, right corner of the screen
-    bottomleft: Bottom, left
-    bottomright: Bottom, left
-    topcenter: Center of the screen, at the top edge
-    leftcenter: Center left edge
-    rightcenter: Center right edge
-    bottomcenter: Center, bottom edge
default is topleft

**What:** what the hotcorner triggers. It should be one of the following
-    "overview": Shows an overview of all windows and desktop
-    "winbutton": Window menu
-    "showdesktop": Shows desktop
-    "desktopright": Jump to Desktop on the right
-    "desktopleft": Jump to Desktop on the left
-    "closewindow": Close currently focused window (Dangerous !)
-    "showclipboard": Show clipboard history
-    "smallerwindow": unmaximizes, if already unmaximized, minimize it
-    "screenshot": Take a screenshot
-    "capslock": Toggle caps lock
-    "alttab": Hit Alt+Tab once
-    "explorer": Opens Explorer
-    "lock": Locks the session
-    "OCR": Select part of screen, immediately transfer result to clipboard
default is overview


**reactivity:** How aggressively the program checks the corner has been hit. In milliseconds.
default is 400
more means the hot corner sometimes do not trigger/react, less means your CPU needs coffee

**sensitivity:** how huge in pixels the hot corner area is
default is 30
more can be disruptive, less you will need to hit the corner more frankly/accurately


"@

}

#if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript")
#    { $global:ScriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition }
#else
#    {$global:ScriptPath = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0]) 
#    if (!$ScriptPath){ $global:ScriptPath = "." } }


# Try loading settings if any
#Import-Module $ScriptPath\settings.ps1 2>$null





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


# Screen info.
$WIDTH  = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width
$HEIGHT = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height

# Take where the user wants their hotcorner
# Calculate from there the screen region to keep watch of
switch ($hotcorner_where)
{
    # Edges
    "topleft" {
        $X_from     = 0
        $X_to       = $hotcorner_sensitivity
        $Y_from     = 0
        $Y_to       = $hotcorner_sensitivity

      }
    "topright" {
        $X_from     = $WIDTH - $hotcorner_sensitivity
        $X_to       = $WIDTH
        $Y_from     = 0
        $Y_to       = $hotcorner_sensitivity

      }
    "bottomright" {
        $X_from     = $WIDTH - $hotcorner_sensitivity
        $X_to       = $WIDTH
        $Y_from     = $HEIGHT - $hotcorner_sensitivity
        $Y_to       = $HEIGHT
      }
    "bottomleft" {
        $X_from     = 0
        $X_to       = $hotcorner_sensitivity
        $Y_from     = $HEIGHT - $hotcorner_sensitivity
        $Y_to       = $HEIGHT
      }

      # Middles
      "topcenter" {
        $X_from     = (($WIDTH / 2) - ($hotcorner_sensitivity/2))
        $X_to       = (($WIDTH / 2) + ($hotcorner_sensitivity/2))
        $Y_from     = 0
        $Y_to       = $hotcorner_sensitivity
      }

      "leftcenter" {
        $X_from     = 0
        $X_to       = $hotcorner_sensitivity
        $Y_from     = (($HEIGHT / 2) - ($hotcorner_sensitivity/2))
        $Y_to       = (($HEIGHT / 2) + ($hotcorner_sensitivity/2))
      }

      "rightcenter" {
        $X_from     = $WIDTH - $hotcorner_sensitivity
        $X_to       = $WIDTH
        $Y_from     = (($HEIGHT / 2) - ($hotcorner_sensitivity/2))
        $Y_to       = (($HEIGHT / 2) + ($hotcorner_sensitivity/2))
      }

    # Will anypony ever use this ??
      "bottomcenter" {
        $X_from     = (($WIDTH / 2) - ($hotcorner_sensitivity/2))
        $X_to       = (($WIDTH / 2) + ($hotcorner_sensitivity/2))
        $Y_from     = $HEIGHT - $hotcorner_sensitivity
        $Y_to       = $HEIGHT
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

    "explorer"   # Win + E
    {
        function action {
            [KeySends.KeySend]::KeyDown("LWin")
            [KeySends.KeySend]::KeyDown("E")
            [KeySends.KeySend]::KeyUp("LWin")
            [KeySends.KeySend]::KeyUp("E") 
        }
    }


    "lock"   # Win + L
    {
        function action {
            [KeySends.KeySend]::KeyDown("LWin")
            [KeySends.KeySend]::KeyDown("L")
            [KeySends.KeySend]::KeyUp("LWin")
            [KeySends.KeySend]::KeyUp("L") 
        }
    }

    "OCR"   # Homemade
    {
            # need             using namespace Windows.Graphics.Imaging

            # Make sure all required assemblies are loaded before any class definitions use them
            Add-Type -AssemblyName System.Windows.Forms, System.Drawing, System.Runtime.WindowsRuntime
            
            # WinRT assemblies are loaded indirectly
            $null = [Windows.Media.Ocr.OcrEngine, Windows.Foundation, ContentType = WindowsRuntime]
            $null = [Windows.Foundation.IAsyncOperation`1, Windows.Foundation, ContentType = WindowsRuntime]
            $null = [Windows.Graphics.Imaging.SoftwareBitmap, Windows.Foundation, ContentType = WindowsRuntime]
            $null = [Windows.Graphics.Imaging.BitmapDecoder, Windows.Foundation, ContentType = WindowsRuntime]
            $null = [Windows.Storage.Streams.RandomAccessStream, Windows.Storage.Streams, ContentType = WindowsRuntime]
            
            # Some WinRT assemblies such as [Windows.Globalization.Language] are loaded indirectly by returning the object types
            $null = [Windows.Media.Ocr.OcrEngine]::AvailableRecognizerLanguages
        
            # Find the awaiter method
            $getAwaiterBaseMethod = [WindowsRuntimeSystemExtensions].GetMember('GetAwaiter').
            Where({$PSItem.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1'}, 'First')[0]
        
            # Define awaiter function
            Function Await {
            param($AsyncTask, $ResultType)
            $getAwaiterBaseMethod.
                MakeGenericMethod($ResultType).
                Invoke($null, @($AsyncTask)).
                GetResult()
            }
            # Auto language detection: 
            $ocrEngine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
            #$ocrEngine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromLanguage('en-US')
        
        
        function action {
            Write-Host ('*'*40)
            # Get old clipboard
            #$oldClipboard = [System.Windows.Forms.Clipboard]::GetDataObject()
            # Reset clipboard
            #[System.Windows.Forms.Clipboard]::SetText(' ')
        
            # Take screenshot
            if (Test-Path -Path $env:SYSTEMROOT"\System32\SnippingTool.exe") {
            # Run snipping tool (Windows 10)
            Write-Host '> Executing Snipping Tool'
            [Diagnostics.Process]::Start('SnippingTool.exe', '/clip').WaitForExit()
            } else {
            # Run snip & sketch (Windows 11)
            Write-Host '> Executing Snip & Sketch'
            Start-Process 'explorer.exe' 'ms-screenclip:' -Wait
            }
            
            # Wait for image to be copied to clipboard
            Write-Host '> Waiting for image'
            $timeout = New-TimeSpan -Seconds 10
            $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
            do {
            $clipboard = [System.Windows.Forms.Clipboard]::GetDataObject()
            Start-Sleep 0.01   # Avoid overloading the CPU
            if ($stopwatch.elapsed -gt $timeout) {
                Write-Output 'Failed to copy image to clipboard.'
                Write-Host '> Failed. Aborting...'
                [System.Windows.Forms.Clipboard]::SetDataObject($oldClipboard)
                return
            }
            } until ($clipboard.ContainsImage())
            
            # Get image
            $bmp = $clipboard.getimage()
            # Restore old clipboard
            #[System.Windows.Forms.Clipboard]::SetDataObject($oldClipboard)
            
            # If softwareBitmap has a width/height under 150px, extend the image
            $minPx = 150
            if (($bmp.Height -lt $minPx) -or ($bmp.Width -lt $minPx)) {
            $nh = [math]::max($bmp.Height, $minPx)
            $nw = [math]::max($bmp.Width, $minPx)
            Write-Host ([String]::Concat('> Extending image (',$bmp.Width,',',$bmp.Height,') -> (',$nw,',',$nh,') px'))
            $graphics = [Drawing.Graphics]::FromImage(($newBmp = [Drawing.Bitmap]::new($nw, $nh)))
            $graphics.Clear($bmp.GetPixel(0, 0))
            if (($bmp.Height -lt $minPx) -and ($bmp.Width -lt $minPx)) {
                $sf = ([math]::min(([math]::floor($minPx / [math]::max($bmp.Width, $bmp.Height))), 3))
                if ($sf -gt 1) {Write-Host ([String]::Concat('> Scaling image by ',$sf,'x'))}
            } else {
                $sf = 1
            }
            $sw = ($sf * $bmp.Width)
            $sh = ($sf * $bmp.Height)
            $graphics.DrawImage($bmp, ([math]::floor(($nw-$sw)/2)), ([math]::floor(($nh-$sh)/2)), $sw, $sh)
            $bmp = $newBmp.Clone()
            $newBmp.Dispose()
            $graphics.Dispose()
            }
        
            # Save bmp to memory stream
            Write-Host '> Converting image format to SoftwareBitmap'
            $memStream = [IO.MemoryStream]::new()
            $bmp.Save($memStream, 'Bmp')
        
            # Build SoftwareBitmap
            $r = [IO.WindowsRuntimeStreamExtensions]::AsRandomAccessStream($memStream)
            $params = @{
            AsyncTask  = [BitmapDecoder]::CreateAsync($r)
            ResultType = [BitmapDecoder]
            }
            $bitmapDecoder = Await @params
            $params = @{ 
            AsyncTask = $bitmapDecoder.GetSoftwareBitmapAsync()
            ResultType = [SoftwareBitmap]
            }
            $softwareBitmap = Await @params
            $memStream.Dispose()
            $r.Dispose()
        
            # Run OCR
            $resuLt = (Await $ocrEngine.RecognizeAsync($softwareBitmap) ([Windows.Media.Ocr.OcrResult]))
        
            Set-Clipboard $result.Text
        
        }
      






    }
}








    #=========================================
    #                MAINLOOP                =
    #=========================================

#========================================
# The test is Forever
Write-Output "[HOT CORNER] Ready!"
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