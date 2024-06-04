# Imports
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[void] [System.Windows.Forms.Application]::EnableVisualStyles() 

[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')       | out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework')      | out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')             | out-null
[System.Reflection.Assembly]::LoadWithPartialName('WindowsFormsIntegration')    | out-null




#================================
# Project icon in Base 64
# [Convert]::ToBase64String((Get-Content "..\assets\Skrivanek-Rocketlaunch-Icon.ico" -Encoding Byte))
Write-Output "[STARTUP] Loading icon"

[string]$iconBase64 = 'AAABAAEAICAAAAEAIACoEAAAFgAAACgAAAAgAAAAQAAAAAEAIAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgDP/CnQ58L90OfD/dDnw/3Q58P90OfD/dDnw/3Q58P91OfDAdC7/CwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAdDjw/XQ58P90OfD/dzzx/49X9/+ha/v/qHL9/6hy/f+ha/v/kFj3/3c98f90OfD/dDnw/3Q48P0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHM48P+rdv7/rXj//614//+teP//rXj//614//+teP//rXj//614//+teP//rXj//614//+teP//q3b+/3M48P8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACpc/2JrXj//614//+teP//rXj//614//+teP//rXj//614//+teP//rXj//614//+teP//rXj//614//+teP//rXj//6l1/4kAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAK14//+teP//rXj//614//+teP//rXj//614//+teP//rXj//614//+teP//rXj//614//+teP//rXj//614//+teP//rXj//wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAerL7/2XJ+f9pxfr/kJj9/613//+teP//rXj//614//+teP//rXj//614//+teP//rXj//614//+teP//rXj//614//+teP//AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABb1vn/W9b5/1vW+f9b1vn/W9b5/1vW+f+td///rXj//614//+teP//rXj//614//+teP//rXj//614//+teP//rXj//614//8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFvW+f9b1vn/W9b5/1vW+f9b1vn/W9b5/1vW+f+off7/rXj//614//+teP//rXj//614//+teP//rXj//614//+teP//rXj//wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAW9b5/1vW+f9b1vn/W9b5/1vW+f9b1vn/W9b5/1vW+f+teP//rXj//614//+teP//rXj//614//+teP//rXj//614//+teP//AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACx7P/+W9b5/56J/v+teP//rXj//614//+teP//ip/8/1rW+f+teP//rXj//614//+teP//rXj//614//+teP//rXj//614//8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALHs//+5jv//rXj//614//+teP//rXj//614//+teP//rXj//5qN/f+teP//rXj//614//+teP//rXj//614//+teP//rXj//wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAuY7//7mO//+5jv//rXf//q14//+teP//rXj//614//+teP//k5X9/1vW+f+ci/7/rXj//614//+teP//rXj//613//9f0Pn/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC5jv//uY7//7mO//+5jv//uY3/+q14//+teP//rXj//614//+teP//W9b5/1vW+f9b1vn/W9b5/1vW+f9b1vn/W9b5/1vW+f8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALmO//+5jv//uY7//7mO//+5jv//uY7//7iM//mteP//rXj//614//+teP//W9b5/1vW+f9b1vn/W9b5/1vW+f9b1vn/W9b5/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAuY7//7mO//+5jv//uY7//7mO//+5jv//uY7//7mO//+4jP/5rXj//614//+teP//Wtb5/1vW+f9b1vn/W9b5/1vW+f9b1vn/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC5jv//uY7//7mO//+5jv//uY7//7mO//+5jv//uY7//7mO//+5jv//rXj//614//+teP//qXv+/1vW+f9b1vn/W9b5/1vW+f8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALmO//+5jv//uY7//7mO//+5jv//uY7//7mO//+5jv//uY7//7mO//+5jv//rXj//614//+teP//rXj//614//+mf/7/dLj6/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAuY7//7mO//+5jv//uY7//7mO//+5jv//uY7//7mO//+5jv//uY7//7mO//+5jv//rXj//614//+teP//rXj//614//+teP//AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC5jv//uY7//7mO//+5jv//uY7//sKc//PKrP/1y6///suu///Lrv//zK7//cqr//TAmf/srXj//a14//+teP//rXj//614//8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALmO//+6j//8y67//8uu///Lrv//y67//8uu///Lrv//y67//8uu///Lrv//y67//8uu//+5jv//uY7//7mO//+teP/8rXj//wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAyKn/98uu///Lrv//y67//8uu///Lrv//y67//8uu///Lrv//y67//8uu///Lrv//y67//8mq//i5jv//uY7//7mO//+3i//2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADLrv//y67//8uu///Lrv//y67//8uu///Lrv//y67//8uu///Lrv//y67//8uu///Lrv//y67//7mO//+5jv//uY7//7mO//8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMuu///Lrv//y67//8uu///Hp//3r3v/+K14//+teP//rXj//614//+teP//rXj//697//jGp//3uY7//bmO//+5jv//uY7//wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAzbH/JMuu//+uev/6rXj//614//3YtLHx7tOH/O3Sh//t0of/7dKH/+3Sh//u0of817Kx8614//2ncv/1k2D/+rmO//+8jf8mAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAArXj//N69pPTt0of/7dKG//bnvf/579D/+e/Q//nv0P/579D/+e/Q//nv0P/2577/7dKG/+3Sh//Xt6T0kl7//AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADpzY757dKH//nv0P/579D/+e/Q//nv0P9oIBb/aCAW/2ggFv9nHxX/+e/Q//nv0P/579D/+e/Q/+3Sh//ny475AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAO3Sh//s0IX/0XMi/92aV//579H/+e/Q//HWrP/RcyL/0XMi//jtzf/579D/+e/R/92bWf/RcyL/7NCF/+3Sh/8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAO3Sh//s0Yb/0XIh/9FzIv/BWxb/0XMi/9FzIv/RcyL/0HEh/8tpHf/RcyL/0XIh/+zRhv/t0of/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP//gALt0ofn7dKH/+fBW//RcyL/58Fb/+fBW//RcyL/58Fb/+3Sh//t0ojp//+AAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANFyIf///////////9FzIf8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAANVqFQzbbSQHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA///////gB///gAH//wAA//4AAH/+AAB//gAAf/4AAH/+AAB//gAAf/4AAH/+AAB//gAAf/4AAH/+AAB//gAAf/4AAH/+AAB//gAAf/4AAH/+AAB//gAAf/4AAH/+AAB//gAAf/8AAP//AAD//wAA//+AAf//wAP///w////+f/8='
[string]$icondark64 = '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'

# phew
# Rebuild an image from base 64
$iconBytes = [Convert]::FromBase64String($iconBase64)
$stream = [System.IO.MemoryStream]::new($iconBytes, 0, $iconBytes.Length)
$icon = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($stream).GetHIcon()))

$iconBytes = [Convert]::FromBase64String($icondark64)
$streamdark = [System.IO.MemoryStream]::new($iconBytes, 0, $iconBytes.Length)
$icondark = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($streamdark).GetHIcon()))




# ----------------------------------------------------
# Part - Add the systray menu
# ----------------------------------------------------        


# Display an icon in tray
$Main_Tool_Icon = New-Object System.Windows.Forms.NotifyIcon
$Main_Tool_Icon.Text = "Assistant"
$Main_Tool_Icon.Icon = $icon
$Main_Tool_Icon.Visible = $true
$Main_Tool_Icon.Add_Click({                    
    If ($_.Button -eq [Windows.Forms.MouseButtons]::Left) {
        $Main_Tool_Icon.GetType().GetMethod("ShowContextMenu",[System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::NonPublic).Invoke($Main_Tool_Icon,$null)
    }
})



# About in notification bubble
$Menu_About = New-Object System.Windows.Forms.MenuItem
$Menu_About.Text = "About Assistant + doc"
$Menu_About.add_Click({
    Start-Process "https://github.com/teamcons/Assistant"
 })


# ----------------------------------------------------
# Part - HOTCORNER
# ----------------------------------------------------        


# Toggle between halt and continue
$Menu_Toggle_HotCorner_TopLeft = New-Object System.Windows.Forms.MenuItem
$Menu_Toggle_HotCorner_TopLeft.Checked = $true
$Menu_Toggle_HotCorner_TopLeft.Text = "Top left edge triggers overview"
$Menu_Toggle_HotCorner_TopLeft.Add_Click({
    # If it was checked when clicked, stop it
    # Else, it wasnt checked, so start it
    if ($Menu_Toggle_HotCorner_TopLeft.Checked) {
        #Stop-Process -Id $hotcorner_topleft_ID
        Stop-Process -Name hotcorner_topleft
        $Menu_Toggle_HotCorner_TopLeft.Checked = $false}
    else {
        Start-Process $ScriptPath\functionalities\hotcorner_topleft.exe
        $Menu_Toggle_HotCorner_TopLeft.Checked = $true
    
        $hotcorner_topleft_ID}
 })



# ----------------------------------------------------
# Part - HOTCORNER-META
# ----------------------------------------------------        


# Toggle between halt and continue
$Menu_Toggle_HotCorner_WinButton = New-Object System.Windows.Forms.MenuItem
$Menu_Toggle_HotCorner_WinButton.Checked = $false
$Menu_Toggle_HotCorner_WinButton.Text = "Open windows start menu if hovered"
$Menu_Toggle_HotCorner_WinButton.Add_Click({
    # If it was checked when clicked, stop it
    # Else, it wasnt checked, so start it
    if ($Menu_Toggle_HotCorner_WinButton.Checked) {
        Stop-Process -Name hotcorner_winbutton
        $Menu_Toggle_HotCorner_WinButton.Checked = $false}
    else {
        Start-Process $ScriptPath\functionalities\hotcorner_winbutton.exe
        $Menu_Toggle_HotCorner_WinButton.Checked = $true}


 })





# ----------------------------------------------------
# Part - KEEPAWAKE
# ----------------------------------------------------        


# Toggle between halt and continue
$Menu_Toggle_KeepAwake = New-Object System.Windows.Forms.MenuItem
$Menu_Toggle_KeepAwake.Checked = $true
$Menu_Toggle_KeepAwake.Text = "Keep puter awake"
$Menu_Toggle_KeepAwake.Add_Click({
    # If it was checked when clicked, stop it
    # Else, it wasnt checked, so start it
    if ($Menu_Toggle_KeepAwake.Checked) {
        #Stop-Process -Id $keepawakeID
        Stop-Process -Name keepawake
        $Menu_Toggle_KeepAwake.Checked = $false
        $Main_Tool_Icon.Icon = $icondark }
    else {
        Start-Process $ScriptPath\functionalities\keepawake.exe
        $Menu_Toggle_KeepAwake.Checked = $true
        $Main_Tool_Icon.Icon = $icon }
 })



# ----------------------------------------------------
# Part - Add the systray menu
# ----------------------------------------------------        

$autostart = -join($env:APPDATA,"\Microsoft\Windows\Start Menu\Programs\Startup")
$WshShell = New-Object -ComObject WScript.Shell


# Toggle between halt and continue
$Menu_Toggle_Autostart = New-Object System.Windows.Forms.MenuItem
$Menu_Toggle_Autostart.Text = "Start with puter"
$Menu_Toggle_Autostart.Checked = (Test-Path $autostart\Assistant.lnk)
$Menu_Toggle_Autostart.Add_Click({
    # If it was checked when clicked, delete autostart shortcut
    # Else, it wasnt checked, so create autostart shortcut
    if ($Menu_Toggle_Autostart.Checked) {
        Remove-Item $autostart\Assistant.lnk
        $Menu_Toggle_Autostart.Checked = $false}
    else {
        $Shortcut = $WshShell.CreateShortcut( -join($autostart,"\Assistant.lnk"))
        $Shortcut.IconLocation = (-join($ScriptPath,"\assets\soft-drink.ico"))
        $Shortcut.TargetPath = (-join($ScriptPath,"\Assistant.exe"))
        $Shortcut.Save()
        $Menu_Toggle_Autostart.Checked = $true }
 })


# ----------------------------------------------------
# Part - ELSE
# ----------------------------------------------------        

# Timer
$timer = {
    Start-Sleep -seconds ($settings.Timer.Duration * 60)
    $Main_Tool_Icon.BalloonTipTitle = "Hey!"
    $Main_Tool_Icon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
    $Main_Tool_Icon.BalloonTipText = "Wake up!"
    $Main_Tool_Icon.Visible = $true
    $Main_Tool_Icon.ShowBalloonTip(500)
    $Menu_Toggle_Timer.Checked = $false
}


# Toggle between halt and continue
$Menu_Toggle_Timer = New-Object System.Windows.Forms.MenuItem
$Menu_Toggle_Timer.Text = -join("Notify me in ",$settings.Timer.Duration,"mn")
$Menu_Toggle_Timer.Checked = $false
$Menu_Toggle_Timer.Add_Click({
    # If it was checked when clicked, stop time
    # Else, it wasnt checked, so start timer
    if ($Menu_Toggle_Timer.Checked) {
        Stop-Job -Name "timer"
        $Menu_Toggle_Timer.Checked = $false}
    else {
        Start-Job -ScriptBlock $timer -Name "timer"
        $Menu_Toggle_Timer.Checked = $true}
 })
 



# ----------------------------------------------------
# Part - ELSE
# ----------------------------------------------------        


# Stop everything
$Menu_Exit = New-Object System.Windows.Forms.MenuItem
$Menu_Exit.Text = "Quit Assistant"
$Menu_Exit.add_Click({
    $Main_Tool_Icon.Visible = $false

    # Stop everything that needs stopping
    if ($Menu_Toggle_HotCorner_TopLeft.Checked)     {Stop-Process -Name hotcorner_topleft}
    if ($Menu_Toggle_HotCorner_WinButton.Checked)   {Stop-Process -Name hotcorner_winbutton}
    if ($Menu_Toggle_KeepAwake.Checked)             {Stop-Process -Name keepawake}

    $Main_Tool_Icon.Icon.Dispose();
    $Main_Tool_Icon.Dispose();
    $appContext.Dispose();
 })

$Main_Tool_Icon.ContextMenu = New-Object System.Windows.Forms.ContextMenu
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_About)
$Main_Tool_Icon.ContextMenu.MenuItems.Add("-");
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Toggle_HotCorner_TopLeft)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Toggle_HotCorner_WinButton)
$Main_Tool_Icon.ContextMenu.MenuItems.Add("-");
#$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Toggle_Timer)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Toggle_KeepAwake)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Toggle_Autostart)
$Main_Tool_Icon.ContextMenu.MenuItems.Add("-");
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Exit)

 

# ---------------------------------------------------------------------
