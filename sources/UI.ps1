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
    $Main_Tool_Icon.BalloonTipTitle = "Keep puter awake!"
    $Main_Tool_Icon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
    $Main_Tool_Icon.BalloonTipText = "Made by Stella ! :3 <stella.menier@gmx.de>"
    $Main_Tool_Icon.Visible = $true
    $Main_Tool_Icon.ShowBalloonTip(1000)

    Start-Process "https://github.com/teamcons/EnergyDrink"

 })


# ----------------------------------------------------
# Part - HOTCORNER
# ----------------------------------------------------        


# Toggle between halt and continue
$Menu_Toggle_HC = New-Object System.Windows.Forms.MenuItem
$Menu_Toggle_HC.Checked = $true
$Menu_Toggle_HC.Text = "Hot corner (Top left)"
$Menu_Toggle_HC.Add_Click({
    # If it was checked when clicked, stop it
    # Else, it wasnt checked, so start it
    if ($Menu_Toggle_HC.Checked) {
        Stop-Process -Id $hotcorner_topleft_ID
        $Menu_Toggle_HC.Checked = $false}
    else {
        $hotcorner_topleft_ID = (Start-Process $ScriptPath\hotcorner_topleft.exe -passthru).ID
        $Menu_Toggle_HC.Checked = $true}
 })



# ----------------------------------------------------
# Part - HOTCORNER-META
# ----------------------------------------------------        


# Toggle between halt and continue
$Menu_Toggle_HC_Meta = New-Object System.Windows.Forms.MenuItem
$Menu_Toggle_HC_Meta.Checked = $true
$Menu_Toggle_HC_Meta.Text = "Hot corner (Top left)"
$Menu_Toggle_HC_Meta.Add_Click({
    # If it was checked when clicked, stop it
    # Else, it wasnt checked, so start it
    if ($Menu_Toggle_HC_Meta.Checked) {
        Stop-Process -Id $hotcorner_winbutton_ID
        $Menu_Toggle_HC_Meta.Checked = $false}
    else {
        $hotcorner_winbutton_ID = (Start-Process $ScriptPath\hotcorner_winbutton.exe -passthru).ID
        $Menu_Toggle_HC_Meta.Checked = $true}
 })





# ----------------------------------------------------
# Part - KEEPAWAKE
# ----------------------------------------------------        


# Toggle between halt and continue
$Menu_Toggle_KA = New-Object System.Windows.Forms.MenuItem
$Menu_Toggle_KA.Checked = $true
$Menu_Toggle_KA.Text = "Keep awake"
$Menu_Toggle_KA.Add_Click({
    # If it was checked when clicked, stop it
    # Else, it wasnt checked, so start it
    if ($Menu_Toggle_KA.Checked) {
        Stop-Process -Id $keepawakeID
        $Menu_Toggle_KA.Checked = $false
        $Main_Tool_Icon.Icon = $icondark }
    else {
        $keepawakeID = (Start-Process $ScriptPath\keepawake.exe -passthru).ID
        $Menu_Toggle_KA.Checked = $true
        $Main_Tool_Icon.Icon = $icon }
 })



# ----------------------------------------------------
# Part - Add the systray menu
# ----------------------------------------------------        









# ----------------------------------------------------
# Part - ELSE
# ----------------------------------------------------        

 
# Stop everything
$Menu_Exit = New-Object System.Windows.Forms.MenuItem
$Menu_Exit.Text = "Close app"
$Menu_Exit.add_Click({
    $Main_Tool_Icon.Visible = $false

    # Stop all
    Stop-Process -Id $hotcorner_topleft_ID
    Stop-Process -Id $hotcorner_winbutton_ID
    Stop-Process -Id $keepawakeID
    $Main_Tool_Icon.Icon.Dispose();
    $Main_Tool_Icon.Dispose();
    $appContext.Dispose();
 })

$Main_Tool_Icon.ContextMenu = New-Object System.Windows.Forms.ContextMenu
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_About)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Toggle_HC)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Toggle_HC_Meta)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Toggle_KA)
$Main_Tool_Icon.contextMenu.MenuItems.AddRange($Menu_Exit)

 




# ---------------------------------------------------------------------

$Main_Tool_Icon.BalloonTipTitle = "Started !"
$Main_Tool_Icon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
$Main_Tool_Icon.BalloonTipText = "The puter is now prevented from going to sleep"
$Main_Tool_Icon.Visible = $true
$Main_Tool_Icon.ShowBalloonTip(500)

