

Add-Type -AssemblyName System.Windows.Forms

# Press "F15" every 5mn
while ($true) {
    [System.Windows.Forms.SendKeys]::SendWait('+{F15}')
    Start-Sleep -seconds (5 * 60)
}