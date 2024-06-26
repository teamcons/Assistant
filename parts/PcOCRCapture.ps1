<#
.SYNOPSIS
   Simple OCR screen capture UI
.DESCRIPTION
   Select a region of your screen to scan with the "Capture" button
   Returns recognized text in an input field
#>

using namespace Windows.Graphics.Imaging

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


Function OCRCapture {
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
  $resuLt = (Await $ocrEngine.RecognizeAsync($softwareBitmap) ([Windows.Media.Ocr.OcrResult]))

  try { Set-Clipboard $result.Text}
  catch {Set-Clipboard $text.OCR.Failed}

}
