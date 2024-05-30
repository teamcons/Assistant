# Imports
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[void] [System.Windows.Forms.Application]::EnableVisualStyles() 

[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')       | out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework')      | out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')             | out-null
[System.Reflection.Assembly]::LoadWithPartialName('WindowsFormsIntegration')    | out-null





# ----------------------------------------------------
# Part - Add the systray menu
# ----------------------------------------------------        


# Display an icon in tray
$Main_Tool_Icon = New-Object System.Windows.Forms.NotifyIcon
$Main_Tool_Icon.Text = "EnergyDrink"
$Main_Tool_Icon.Icon = $icon
$Main_Tool_Icon.Visible = $true
$Main_Tool_Icon.Add_Click({                    
    If ($_.Button -eq [Windows.Forms.MouseButtons]::Left) {
        $Main_Tool_Icon.GetType().GetMethod("ShowContextMenu",[System.Reflection.BindingFlags]::Instance -bor [System.Reflection.BindingFlags]::NonPublic).Invoke($Main_Tool_Icon,$null)
    }
})



# About in notification bubble
$Menu_About = New-Object System.Windows.Forms.MenuItem
$Menu_About.Text = "About"
$Menu_About.add_Click({
    Start-Process "https://github.com/teamcons/EnergyDrink"
 })


# ----------------------------------------------------
# Part - HOTCORNER
# ----------------------------------------------------        


# Toggle between halt and continue
$Menu_Toggle_HotCorner_TopLeft = New-Object System.Windows.Forms.MenuItem
$Menu_Toggle_HotCorner_TopLeft.Checked = $true
$Menu_Toggle_HotCorner_TopLeft.Text = "Hot corner (Top left overview)"
$Menu_Toggle_HotCorner_TopLeft.Add_Click({
    # If it was checked when clicked, stop it
    # Else, it wasnt checked, so start it
    if ($Menu_Toggle_HotCorner_TopLeft.Checked) {
        #Stop-Process -Id $hotcorner_topleft_ID
        Stop-Process -Name hotcorner_topleft
        $Menu_Toggle_HotCorner_TopLeft.Checked = $false}
    else {
        $hotcorner_topleft_ID = (Start-Process $ScriptPath\functionalities\hotcorner_topleft.exe -passthru).ID
        $Menu_Toggle_HotCorner_TopLeft.Checked = $true
    
        $hotcorner_topleft_ID}
 })



# ----------------------------------------------------
# Part - HOTCORNER-META
# ----------------------------------------------------        


# Toggle between halt and continue
$Menu_Toggle_HotCorner_WinButton = New-Object System.Windows.Forms.MenuItem
$Menu_Toggle_HotCorner_WinButton.Checked = $false
$Menu_Toggle_HotCorner_WinButton.Text = "Hot corner (Windows button)"
$Menu_Toggle_HotCorner_WinButton.Add_Click({
    # If it was checked when clicked, stop it
    # Else, it wasnt checked, so start it
    if ($Menu_Toggle_HotCorner_WinButton.Checked) {
        #Stop-Process -Id $hotcorner_winbutton_ID
        Stop-Process -Name hotcorner_winbutton
        $Menu_Toggle_HotCorner_WinButton.Checked = $false}
    else {
        $hotcorner_winbutton_ID = (Start-Process $ScriptPath\functionalities\hotcorner_winbutton.exe -passthru).ID
        $Menu_Toggle_HotCorner_WinButton.Checked = $true}


 })





# ----------------------------------------------------
# Part - KEEPAWAKE
# ----------------------------------------------------        


# Toggle between halt and continue
$Menu_Toggle_KeepAwake = New-Object System.Windows.Forms.MenuItem
$Menu_Toggle_KeepAwake.Checked = $true
$Menu_Toggle_KeepAwake.Text = "Keep puter awake"



# ----------------------------------------------------
# Part - Add the systray menu
# ----------------------------------------------------        

$autostart = -join($env:APPDATA,"\Microsoft\Windows\Start Menu\Programs\Startup")
$WshShell = New-Object -ComObject WScript.Shell


# Detect whether autostart is there
$Menu_Toggle_Autostart = (Test-Path $autostart\Assistant.lnk)



# Toggle between halt and continue
$Menu_Toggle_Autostart = New-Object System.Windows.Forms.MenuItem
$Menu_Toggle_Autostart.Text = "Autostart"
$Menu_Toggle_Autostart.Add_Click({
    # If it was checked when clicked, delete autostart shortcut
    # Else, it wasnt checked, so create autostart shortcut
    if ($Menu_Toggle_Autostart.Checked) {
        Remove-Item $autostart\Assistant.lnk
        $Menu_Toggle_Autostart.Checked = $false}
    else {
        $Shortcut = $WshShell.CreateShortcut( -join($autostart,"\Assistant.lnk"))
        $Shortcut.TargetPath = -join($ScriptPath,"\Assistant.exe")
        $Shortcut.Save()
        $Menu_Toggle_Autostart.Checked = $true }
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
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Toggle_HotCorner_TopLeft)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Toggle_HotCorner_WinButton)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Toggle_KeepAwake)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Toggle_Autostart)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Exit)

 

# ---------------------------------------------------------------------

