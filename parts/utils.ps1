


using namespace Windows.Graphics.Imaging
# Imports
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


# ----------------------------------------------------
# Part - Add the systray menu
# ----------------------------------------------------        



# Stop EVERYTHING
$quit = {
    $Main_Tool_Icon.Visible = $false

    # Stop everything that needs stopping
    if ($Menu_Toggle_HotCorner_TopLeft.Checked)
        {
        Stop-Process -Name hotcorner_topleft
        $settings.TopLeftOverview.Enabled = "true"
        }
    else {$settings.TopLeftOverview.Enabled = "false"}


    if ($Menu_Toggle_HotCorner_WinButton.Checked)
        {
        Stop-Process -Name hotcorner_winbutton
        $settings.WindowsButton.Enabled = "true"
        }
    else {$settings.WindowsButton.Enabled = "false"}

    if ($Menu_Toggle_HotCorner_ShowDesktop.Checked)
        {
        Stop-Process -Name hotcorner_bottomright_showdesktop
        $settings.ShowDesktop.Enabled = "true"
        }
    else {$settings.ShowDesktop.Enabled = "false"}


    if ($Menu_Toggle_HotCorner_Close.Checked)
        {
        Stop-Process -Name hotcorner_topright_close
        $settings.CloseActiveWindow.Enabled = "true"
        }
    else {$settings.CloseActiveWindow.Enabled = "false"}


    if ($Menu_Toggle_KeepAwake.Checked)
        {
        Stop-Process -Name keepawake
        $settings.KeepAwake.Enabled = "true"
        }
    else
        {$settings.KeepAwake.Enabled = "false"}


    Write-Output $settings | ConvertTo-Json | Out-File -Encoding "UTF8" $ScriptPath\parts\state.json

    

    $Main_Tool_Icon.Icon.Dispose();
    $Main_Tool_Icon.Dispose();
    $appContext.Dispose();
 }


# ----------------------------------------------------
# Part - Add the systray menu
# ----------------------------------------------------        


<#
Get-ClipboardHistory: Get the texts contained in the clipboard history.
Clear-ClipboardHistory: Clearing the clipboard history

In PowerShell 7.1 or later, use the following command to install Microsoft.Windows.SDK.NET.Ref with administrative privileges.
Find-Package -ProviderName NuGet -Source https://www.nuget.org/api/v2 -Name Microsoft.Windows.SDK.NET.Ref | Install-Package
#>

$needsSDK = $PSVersionTable.PSVersion -ge "7.1.0" 

if ($needsSDK)
{
    $sdkLib = Split-Path -Path (
        Get-Package -ProviderName NuGet -Name Microsoft.Windows.SDK.NET.Ref |
            Select-Object -ExpandProperty Source) -Parent |
        Join-Path -ChildPath "\lib"
    Add-Type -Path "$sdkLib\Microsoft.Windows.SDK.NET.dll"
    Add-Type -Path "$sdkLib\WinRT.Runtime.dll"
}
else
{
    Add-Type -AssemblyName System.Runtime.WindowsRuntime
}

$clipboard = if ($needsSDK)
{
    [Windows.ApplicationModel.DataTransfer.Clipboard]
}
else
{
    [Windows.ApplicationModel.DataTransfer.Clipboard, Windows.ApplicationModel.DataTransfer, ContentType = WindowsRuntime]
}

function await
{
    param($AsyncTask, [Type]$ResultType)

    $method = [WindowsRuntimeSystemExtensions].GetMember("GetAwaiter") |
        where {$_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1'} |
        select -First 1
    $method.MakeGenericMethod($ResultType).
    Invoke($null, @($AsyncTask)).
    GetResult()
}

function Get-ClipboardHistory
{
    $type = if ($script:needsSDK)
    {
        [Windows.ApplicationModel.DataTransfer.ClipboardHistoryItemsResult]
    }
    else
    {
        [Windows.ApplicationModel.DataTransfer.ClipboardHistoryItemsResult, Windows.ApplicationModel.DataTransfer, ContentType = WindowsRuntime]
    }

    $result = await $script:clipboard::GetHistoryItemsAsync() $type
    
    $outItems = if ($script:needsSDK)
    {
        @($result.Items.AdditionalTypeData.Values)
    }
    else
    {
        @($result.Items)
    }

    $outItems |
        where {$_.Content.Contains("Text")} |
        foreach {await $_.Content.GetTextAsync() ([string])}
}

function Clear-ClipboardHistory
{
    $script:clipboard::ClearHistory() | Out-Null
}








# ----------------------------------------------------
# Part - Add the systray menu
# ----------------------------------------------------        

function ellipsify {

    param ($text)

    $length = 30

    if ($text.Length -lt $length )
    {
        return $text
    }
    else {
        [string]$new = $text[0..($length - 3)] -join ""
        return -join($new,"...")
    }
}



Function Clipboard_generate_entries {
    param ($menu)

    # Rebuild
    $menu.MenuItems.Clear()
    $menu.MenuItems.Add($clear)
    $menu.MenuItems.Add("-")

    # Fetch
    $script:clipboard_history = Get-ClipboardHistory

    # Case where it's empty
    if ($clipboard_history -eq $null )
    {
        $entry = New-Object System.Windows.Forms.MenuItem
        $entry.Text = $text.Clipboard.Empty
        $menu.MenuItems.Add($entry)
    }
    # Case where theres only one thing
    elseif ($clipboard_history -is [string])
    {
        $entry = New-Object System.Windows.Forms.MenuItem
        if ($clipboard_history.trim(" ").Length -eq 0 )
        {
            $entry.Text = $text.Clipboard.Whitespace
        }
        else {
            $entry.Text = -join("1. ", (ellipsify $clipboard_history))
        }
        $menu.MenuItems.Add($entry)
    }
    else {
        
        # Build new entries
        foreach ($i in 1..6)
        {
            if ($clipboard_history[($i - 1)] -eq $null)
            {
                Write-Output "no"
                break
            }
            elseif (($clipboard_history[($i - 1)]).trim(" ").Length -eq 0)
            {
                $entry = New-Object System.Windows.Forms.MenuItem
                $entry.Text = -join($i,". ",$text.Clipboard.Whitespace)
                $menu.MenuItems.Add($entry)
            }
            else {
                $entry = New-Object System.Windows.Forms.MenuItem
                $entry.Text = -join($i,". ",( ellipsify $clipboard_history[($i - 1)] ))
                $menu.MenuItems.Add($entry)
            }

        }

        # Cannot automate scriptblocks
        # We start from 2, 0 and 1 are "empty clipboard" and the separator
        #try {$menu.MenuItems[2].Add_Click({Set-Clipboard $clipboard_history[0]})} catch {Write-Output "no"}
        try {$menu.MenuItems[3].Add_Click({Set-Clipboard $clipboard_history[1]})} catch {Write-Output "no"}
        try {$menu.MenuItems[4].Add_Click({Set-Clipboard $clipboard_history[2]})} catch {Write-Output "no"}
        try {$menu.MenuItems[5].Add_Click({Set-Clipboard $clipboard_history[3]})} catch {Write-Output "no"}
        try {$menu.MenuItems[6].Add_Click({Set-Clipboard $clipboard_history[4]})} catch {Write-Output "no"}
        try {$menu.MenuItems[7].Add_Click({Set-Clipboard $clipboard_history[5]})} catch {Write-Output "no"}
        try {$menu.MenuItems[8].Add_Click({Set-Clipboard $clipboard_history[6]})} catch {Write-Output "no"}


    } # end of the great ifelse


} # End of Clipboard_generate_entries









function  OCRCapture {

  Write-Host ('*'*40)
  # Get old clipboard
  $oldClipboard = [System.Windows.Forms.Clipboard]::GetDataObject()
  # Reset clipboard
  [System.Windows.Forms.Clipboard]::SetText(' ')

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
  [System.Windows.Forms.Clipboard]::SetDataObject($oldClipboard)
  
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
  Write-Host '> Running OCR'
  (((Await $ocrEngine.RecognizeAsync($softwareBitmap)([Windows.Media.Ocr.OcrResult])).Lines |
    ForEach-Object {$_.Text}) -Join "`n")
  Write-Host '> Completed successfully'
}







# Extract from image, copy to clipboard if successful
Function OCR_ToClipboard {

    $o = ((&{OCRCapture}).Trim())

    if ($o -eq '') {

        # Tell user we started
        $Main_Tool_Icon.BalloonTipTitle = $text.TopUI.Appname
        $Main_Tool_Icon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Error
        $Main_Tool_Icon.BalloonTipText = $text.OCR.Failed
        $Main_Tool_Icon.ShowBalloonTip(200)


    }
    else {

        [System.Windows.Forms.Clipboard]::SetText($o)
        
        # Tell user we started
        $Main_Tool_Icon.BalloonTipTitle = $text.TopUI.Appname
        $Main_Tool_Icon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
        $Main_Tool_Icon.BalloonTipText = -join($text.OCR.Success,$o)
        $Main_Tool_Icon.ShowBalloonTip(200)

    }

    
}




