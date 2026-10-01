<#
.SYNOPSIS
    Clean Arab Optimizer - Ultimate Edition with Modern UI Toggles
#>
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# ???????????? ???? ?????????????? ?????????????? ?????????????? ???????????? ????????????????
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $scriptPath = if ($PSCommandPath) { $PSCommandPath } else { $MyInvocation.MyCommand.Path }
    if ($scriptPath) {
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`"" -Verb RunAs
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please run this script as Administrator!", "Admin Required")
    }
    exit
}

# Auto-Create System Restore Point BEFORE opening GUI
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Creating System Restore Point..." -ForegroundColor Yellow
Write-Host " Please wait, the menu will open shortly." -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
Checkpoint-Computer -Description "Clean Arab Auto-Checkpoint" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
Write-Host "[OK] Restore Point Created Successfully!" -ForegroundColor Green


$form = New-Object System.Windows.Forms.Form
$form.Text = "Clean Arab Optimizer - Ultimate Edition"
$form.Size = New-Object System.Drawing.Size(950, 750)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$form.ForeColor = [System.Drawing.Color]::White
$form.Font = New-Object System.Drawing.Font("Segoe UI", 10)

$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Dock = "Fill"
$tabControl.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)

$statusBar = New-Object System.Windows.Forms.StatusStrip
$statusLabel = New-Object System.Windows.Forms.ToolStripStatusLabel
$statusLabel.Text = "Ready  |  Welcome to Clean Arab Ultimate!"
$statusBar.Items.Add($statusLabel) | Out-Null
$statusBar.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$statusBar.ForeColor = [System.Drawing.Color]::White

function Set-Status($msg) { $statusLabel.Text = $msg; $statusBar.Refresh() }

# ==========================================
# UI Helpers: Toggle + Action Buttons
# ==========================================
function Add-ToggleItem ($container, $title, $onAction, $offAction) {
    $pnl = New-Object System.Windows.Forms.Panel
    $pnl.Size = New-Object System.Drawing.Size(430, 50)
    $pnl.Margin = New-Object System.Windows.Forms.Padding(10)
    $pnl.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)

    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $title
    $lbl.Location = New-Object System.Drawing.Point(10, 15)
    $lbl.Size = New-Object System.Drawing.Size(330, 25)
    $lbl.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $lbl.ForeColor = [System.Drawing.Color]::White

    $btn = New-Object System.Windows.Forms.Button
    $btn.Location = New-Object System.Drawing.Point(350, 10)
    $btn.Size = New-Object System.Drawing.Size(70, 30)
    $btn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btn.FlatAppearance.BorderSize = 0
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btn.Text = "OFF"
    $btn.BackColor = [System.Drawing.Color]::FromArgb(80, 80, 80)
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.Tag = "OFF"

    $clickBlock = {
        if ($this.Tag -eq "OFF") {
            $this.Text = "ON"
            $this.BackColor = [System.Drawing.Color]::MediumSeaGreen
            $this.Tag = "ON"
            [System.Windows.Forms.Application]::DoEvents()
            Invoke-Command $onAction
        } else {
            $this.Text = "OFF"
            $this.BackColor = [System.Drawing.Color]::FromArgb(80, 80, 80)
            $this.Tag = "OFF"
            [System.Windows.Forms.Application]::DoEvents()
            Invoke-Command $offAction
        }
    }.GetNewClosure()
    $btn.Add_Click($clickBlock)

    $pnl.Controls.Add($lbl)
    $pnl.Controls.Add($btn)
    $container.Controls.Add($pnl)
}

function Add-ActionItem ($container, $title, $color, $action) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $title
    $btn.Size = New-Object System.Drawing.Size(430, 50)
    $btn.Margin = New-Object System.Windows.Forms.Padding(10)
    $btn.BackColor = $color
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btn.FlatAppearance.BorderSize = 0
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    $clickBlock = {
        [System.Windows.Forms.Application]::DoEvents()
        Invoke-Command $action
    }.GetNewClosure()
    $btn.Add_Click($clickBlock)
    $container.Controls.Add($btn)
}

# ==========================================
# TAB 1: Apps & GitHub Downloads
# ==========================================
$tabApps = New-Object System.Windows.Forms.TabPage
$tabApps.Text = "  Apps (GitHub)  "
$tabApps.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)

$listBoxApps = New-Object System.Windows.Forms.ListBox
$listBoxApps.Location = New-Object System.Drawing.Point(20, 20)
$listBoxApps.Size = New-Object System.Drawing.Size(450, 580)
$listBoxApps.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$listBoxApps.ForeColor = [System.Drawing.Color]::White
$listBoxApps.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$listBoxApps.Font = New-Object System.Drawing.Font("Segoe UI", 13)

$apps = [ordered]@{
    "Google Chrome" = "https://raw.githubusercontent.com/Blackhawk501/-Clean-Arab2/main/ChromeSetup%20(1).exe"
    "WinRAR"        = "https://raw.githubusercontent.com/Blackhawk501/-Clean-Arab2/main/winrar-x64-723.exe"
}
foreach ($app in $apps.Keys) { [void]$listBoxApps.Items.Add($app) }

$btnInstallApp = New-Object System.Windows.Forms.Button
$btnInstallApp.Text = ">> Download && Install Selected"
$btnInstallApp.Location = New-Object System.Drawing.Point(490, 20)
$btnInstallApp.Size = New-Object System.Drawing.Size(380, 70)
$btnInstallApp.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204)
$btnInstallApp.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnInstallApp.FlatAppearance.BorderSize = 0
$btnInstallApp.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$btnInstallApp.Add_Click({
    if ($listBoxApps.SelectedItem) {
        $appName = $listBoxApps.SelectedItem
        $url = $apps[$appName]
        $fileName = [System.IO.Path]::GetFileName([uri]::UnescapeDataString($url))
        $tempExe = "$env:TEMP\$fileName"
        Set-Status "Downloading $appName from GitHub... Please wait."
        try {
            Invoke-WebRequest -Uri $url -OutFile $tempExe -UseBasicParsing
            Set-Status "Download complete. Starting installer..."
            Start-Process $tempExe -Wait
            Set-Status "Installation finished."
            [System.Windows.Forms.MessageBox]::Show("$appName installed successfully!", "Done")
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Failed to download $appName.", "Error")
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select an app first.", "Info")
    }
})

$labelInfo = New-Object System.Windows.Forms.Label
$labelInfo.Text = "Apps downloaded from your GitHub (-Clean-Arab2).`nSelect an app then click Download & Install."
$labelInfo.Location = New-Object System.Drawing.Point(490, 110)
$labelInfo.Size = New-Object System.Drawing.Size(380, 80)
$labelInfo.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$labelInfo.ForeColor = [System.Drawing.Color]::LightGray

$tabApps.Controls.AddRange(@($listBoxApps, $btnInstallApp, $labelInfo))

# ==========================================
# TAB 2: System Tweaks (Batch Mode)
# ==========================================
$tabTweaks = New-Object System.Windows.Forms.TabPage
$tabTweaks.Text = "  System Tweaks  "
$tabTweaks.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)

$flowTweaks = New-Object System.Windows.Forms.FlowLayoutPanel
$flowTweaks.Dock = "Fill"
$flowTweaks.AutoScroll = $true
$flowTweaks.Padding = New-Object System.Windows.Forms.Padding(20)

$global:BatchTweaks = [ordered]@{}

function Add-BatchToggleItem ($container, $title, $scriptBlock) {
    $pnl = New-Object System.Windows.Forms.Panel
    $pnl.Size = New-Object System.Drawing.Size(430, 50)
    $pnl.Margin = New-Object System.Windows.Forms.Padding(10)
    $pnl.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)

    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $title
    $lbl.Location = New-Object System.Drawing.Point(10, 15)
    $lbl.Size = New-Object System.Drawing.Size(330, 25)
    $lbl.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $lbl.ForeColor = [System.Drawing.Color]::White

    $btn = New-Object System.Windows.Forms.Button
    $btn.Location = New-Object System.Drawing.Point(350, 10)
    $btn.Size = New-Object System.Drawing.Size(70, 30)
    $btn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btn.FlatAppearance.BorderSize = 0
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    $btn.Text = "OFF"
    $btn.BackColor = [System.Drawing.Color]::FromArgb(80, 80, 80)
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.Tag = "OFF"

    $clickBlock = {
        if ($this.Tag -eq "OFF") {
            $this.Text = "ON"
            $this.BackColor = [System.Drawing.Color]::MediumSeaGreen
            $this.Tag = "ON"
            $global:BatchTweaks[$title] = $scriptBlock
        } else {
            $this.Text = "OFF"
            $this.BackColor = [System.Drawing.Color]::FromArgb(80, 80, 80)
            $this.Tag = "OFF"
            $global:BatchTweaks.Remove($title)
        }
        [System.Windows.Forms.Application]::DoEvents()
    }.GetNewClosure()
    $btn.Add_Click($clickBlock)

    $pnl.Controls.Add($lbl)
    $pnl.Controls.Add($btn)
    $container.Controls.Add($pnl)
}

function Add-SectionHeader ($container, $title) {
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $title
    $lbl.Size = New-Object System.Drawing.Size(880, 40)
    $lbl.Margin = New-Object System.Windows.Forms.Padding(10, 20, 10, 0)
    $lbl.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $lbl.ForeColor = [System.Drawing.Color]::Gold
    $lbl.BackColor = [System.Drawing.Color]::Transparent
    $lbl.TextAlign = [System.Drawing.ContentAlignment]::BottomLeft
    $container.Controls.Add($lbl)
}

$btnRunTweaks = New-Object System.Windows.Forms.Button
$btnRunTweaks.Text = "[RUN] Execute Selected Tweaks"
$btnRunTweaks.Size = New-Object System.Drawing.Size(880, 60)
$btnRunTweaks.Margin = New-Object System.Windows.Forms.Padding(10)
$btnRunTweaks.BackColor = [System.Drawing.Color]::DarkOrchid
$btnRunTweaks.ForeColor = [System.Drawing.Color]::White
$btnRunTweaks.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$btnRunTweaks.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnRunTweaks.FlatAppearance.BorderSize = 0
$btnRunTweaks.Cursor = [System.Windows.Forms.Cursors]::Hand
$btnRunTweaks.Add_Click({
    if ($global:BatchTweaks.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Please select (ON) at least one tweak first!", "Info")
        return
    }
    
    $tmpScript = "$env:TEMP\RunTweaks.ps1"
    $code = ""
    $code += "Write-Host '========================================' -ForegroundColor Cyan`n"
    $code += "Write-Host '   Clean Arab - Executing System Tweaks   ' -ForegroundColor Green`n"
    $code += "Write-Host '========================================' -ForegroundColor Cyan`n`n"
    
    foreach ($key in $global:BatchTweaks.Keys) {
        $code += "Write-Host '>> Applying: $key ...' -ForegroundColor Yellow`n"
        $code += $global:BatchTweaks[$key].ToString() + "`n"
        $code += "Write-Host '   [OK] Done.`n' -ForegroundColor Green`n"
    }
    
    $code += "Write-Host '========================================' -ForegroundColor Cyan`n"
    $code += "Write-Host 'All selected tweaks have been applied successfully!' -ForegroundColor Magenta`n"
    $code += "Write-Host 'You can close this window now...' -ForegroundColor Gray`n"
    $code += "Start-Sleep -Seconds 5`n"
    
    $code | Out-File $tmpScript -Encoding UTF8
    
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -NoProfile -File `"$tmpScript`"" -Wait
    [System.Windows.Forms.MessageBox]::Show("All selected tweaks applied successfully! (Done!)", "Success")
})
$flowTweaks.Controls.Add($btnRunTweaks)

Add-BatchToggleItem $flowTweaks "[CPU]  Optimize CPU - High Performance" {
    powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null
}
Add-BatchToggleItem $flowTweaks "[NET]  Boost Network & Reduce Ping" {
    ipconfig /flushdns | Out-Null; netsh winsock reset | Out-Null
    netsh int tcp set global autotuninglevel=normal | Out-Null
    $rp = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    if (Test-Path $rp) {
        Set-ItemProperty $rp "NetworkThrottlingIndex" 0xffffffff -Type DWord -Force
        Set-ItemProperty $rp "SystemResponsiveness" 0 -Type DWord -Force
    }
    $tcp = "HKLM:\SOFTWARE\Microsoft\MSMQ\Parameters"
    if (!(Test-Path $tcp)) { New-Item $tcp -Force | Out-Null }
    Set-ItemProperty $tcp "TCPNoDelay" 1 -Type DWord -Force
}
Add-BatchToggleItem $flowTweaks "[PRC]  Reduce Background Processes & Services" {
    $services = @("MapsBroker", "RetailDemo", "TrkWks", "lfsvc", "dmwappushservice", "WerSvc", "SysMain", "DiagTrack", "WSearch")
    foreach ($svc in $services) {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
    }
    $tasks = @(
        "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
        "\Microsoft\Windows\Application Experience\ProgramDataUpdater",
        "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
        "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
    )
    foreach ($task in $tasks) {
        Disable-ScheduledTask -TaskPath ($task | Split-Path) -TaskName ($task | Split-Path -Leaf) -ErrorAction SilentlyContinue
    }
}
Add-BatchToggleItem $flowTweaks "[SRH]  Disable Bing Web Search - Fast Start" {
    $s1 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
    if (!(Test-Path $s1)) { New-Item $s1 -Force | Out-Null }
    Set-ItemProperty $s1 "BingSearchEnabled" 0 -Type DWord -Force
    Set-ItemProperty $s1 "CortanaConsent" 0 -Type DWord -Force
    $s2 = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
    if (!(Test-Path $s2)) { New-Item $s2 -Force | Out-Null }
    Set-ItemProperty $s2 "DisableSearchBoxSuggestions" 1 -Type DWord -Force
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
}
Add-BatchToggleItem $flowTweaks "[SPY]  Disable Telemetry & Tracking" {
    $t = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    if (!(Test-Path $t)) { New-Item $t -Force | Out-Null }
    Set-ItemProperty $t "AllowTelemetry" 0 -Type DWord -Force
    Stop-Service DiagTrack -Force -ErrorAction SilentlyContinue
    Set-Service DiagTrack -StartupType Disabled -ErrorAction SilentlyContinue
}
Add-BatchToggleItem $flowTweaks "[AI]   Disable Copilot & Cortana" {
    $t = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot"
    if (!(Test-Path $t)) { New-Item $t -Force | Out-Null }
    Set-ItemProperty $t "TurnOffWindowsCopilot" 1 -Type DWord -Force
    $c = "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Experience"
    if (!(Test-Path $c)) { New-Item $c -Force | Out-Null }
    Set-ItemProperty $c "AllowCortana" 0 -Type DWord -Force
}
Add-BatchToggleItem $flowTweaks "[O&O]  Download & Run O&O ShutUp10++" {
    $toolPath = "$env:TEMP\OOSU10.exe"
    if (!(Test-Path $toolPath)) {
        Write-Host "Downloading O&O ShutUp10++..." -ForegroundColor Cyan
        try { Invoke-WebRequest -Uri "https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe" -OutFile $toolPath -UseBasicParsing } catch {}
    }
    if (Test-Path $toolPath) {
        Write-Host "Launching O&O ShutUp10++..." -ForegroundColor Cyan
        Start-Process $toolPath
    }
}
Add-BatchToggleItem $flowTweaks "[DEL]  Remove Microsoft Edge Completely" {
    @("msedge","MicrosoftEdgeUpdate","edge") | ForEach-Object { Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue }
    @("C:\Program Files (x86)\Microsoft\Edge\Application\*\Installer\setup.exe", "C:\Program Files\Microsoft\Edge\Application\*\Installer\setup.exe") | ForEach-Object {
        $i = Resolve-Path $_ -ErrorAction SilentlyContinue | Select-Object -Last 1
        if ($i) { Start-Process -FilePath $i.Path -ArgumentList "--uninstall --system-level --force-uninstall" -Wait -NoNewWindow -ErrorAction SilentlyContinue }
    }
    $paths = @("C:\Program Files (x86)\Microsoft\Edge", "C:\Program Files (x86)\Microsoft\EdgeUpdate")
    foreach ($p in $paths) {
        if (Test-Path $p) {
            takeown /f $p /r /d y | Out-Null
            icacls $p /grant "$($env:USERNAME):(OI)(CI)F" /t | Out-Null
            Remove-Item -Path $p -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    $r = "HKLM:\SOFTWARE\Microsoft\EdgeUpdate"
    if (!(Test-Path $r)) { New-Item $r -Force | Out-Null }
    Set-ItemProperty $r "DoNotUpdateToEdgeWithChromium" 1 -Type DWord -Force
    Set-ItemProperty $r "UpdateDefault" 0 -Type DWord -Force
}
Add-BatchToggleItem $flowTweaks "[RMV]  Remove OneDrive Completely" {
    Stop-Process -Name "OneDrive" -Force -ErrorAction SilentlyContinue
    $odSetup = if ([Environment]::Is64BitOperatingSystem) { "$env:SystemRoot\SysWOW64\OneDriveSetup.exe" } else { "$env:SystemRoot\System32\OneDriveSetup.exe" }
    if (Test-Path $odSetup) { Start-Process $odSetup -ArgumentList "/uninstall" -Wait -NoNewWindow }
    Start-Sleep -Seconds 2
    @("$env:USERPROFILE\OneDrive", "C:\OneDriveTemp", "$env:LOCALAPPDATA\Microsoft\OneDrive", "$env:PROGRAMDATA\Microsoft OneDrive") | ForEach-Object {
        if (Test-Path $_) { Remove-Item -Path $_ -Recurse -Force -ErrorAction SilentlyContinue }
    }
    $clsid = "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
    if (Test-Path $clsid) { Set-ItemProperty $clsid "System.IsPinnedToNameSpaceTree" 0 -Type DWord -Force -ErrorAction SilentlyContinue }
}
Add-BatchToggleItem $flowTweaks "[CLN]  Deep Clean Junk & Windows Disk Cleanup" {
    @("$env:TEMP\*", "$env:windir\Temp\*", "$env:windir\Prefetch\*", "$env:windir\SoftwareDistribution\Download\*") | ForEach-Object {
        Remove-Item -Path $_ -Recurse -Force -ErrorAction SilentlyContinue
    }
    $volumes = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
    if (Test-Path $volumes) {
        Get-ChildItem -Path $volumes -ErrorAction SilentlyContinue | ForEach-Object {
            Set-ItemProperty -Path $_.PSPath -Name "StateFlags1337" -Value 2 -Type DWord -Force -ErrorAction SilentlyContinue
        }
    }
    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1337" -NoNewWindow -Wait
}
Add-BatchToggleItem $flowTweaks "[RMV]  Remove Windows Bloat Apps" {
    $bloatApps = @(
        "Microsoft.3DBuilder","Microsoft.BingWeather","Microsoft.GetHelp",
        "Microsoft.Getstarted","Microsoft.MicrosoftOfficeHub",
        "Microsoft.MicrosoftSolitaireCollection","Microsoft.MixedReality.Portal",
        "Microsoft.People","Microsoft.SkypeApp","Microsoft.WindowsFeedbackHub",
        "Microsoft.WindowsMaps","Microsoft.XboxApp","Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo","MicrosoftTeams"
    )
    foreach ($app in $bloatApps) {
        try { Get-AppxPackage -Name $app -AllUsers -ErrorAction SilentlyContinue | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue 2>$null } catch {}
    }
}


$tabTweaks.Controls.Add($flowTweaks)

# ==========================================
# TAB 3: Startup Apps Manager
# ==========================================
$tabStartup = New-Object System.Windows.Forms.TabPage
$tabStartup.Text = "  Startup Manager  "
$tabStartup.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)

$listStartup = New-Object System.Windows.Forms.ListView
$listStartup.Location = New-Object System.Drawing.Point(20, 20)
$listStartup.Size = New-Object System.Drawing.Size(880, 530)
$listStartup.View = [System.Windows.Forms.View]::Details
$listStartup.FullRowSelect = $true
$listStartup.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 48)
$listStartup.ForeColor = [System.Drawing.Color]::White
$listStartup.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$listStartup.Columns.Add("App Name", 250) | Out-Null
$listStartup.Columns.Add("Hive", 80) | Out-Null
$listStartup.Columns.Add("Command / Path", 520) | Out-Null

function Load-Startup {
    $listStartup.Items.Clear()
    $paths = @(
        @{H="HKCU";P="Software\Microsoft\Windows\CurrentVersion\Run"},
        @{H="HKLM";P="SOFTWARE\Microsoft\Windows\CurrentVersion\Run"}
    )
    foreach ($p in $paths) {
        $rp = "$($p.H):\$($p.P)"
        if (Test-Path $rp) {
            $keys = Get-ItemProperty $rp -ErrorAction SilentlyContinue
            if ($keys) {
                foreach ($prop in $keys.psobject.properties) {
                    if ($prop.Name -notin @("PSPath","PSParentPath","PSChildName","PSDrive","PSProvider")) {
                        $item = New-Object System.Windows.Forms.ListViewItem($prop.Name)
                        $item.SubItems.Add($p.H) | Out-Null
                        $item.SubItems.Add($prop.Value.ToString()) | Out-Null
                        $listStartup.Items.Add($item) | Out-Null
                    }
                }
            }
        }
    }
    Set-Status "Startup apps loaded: $($listStartup.Items.Count) found."
}
Load-Startup

$btnDisableStartup = New-Object System.Windows.Forms.Button
$btnDisableStartup.Text = "X  Remove Selected from Startup"
$btnDisableStartup.Location = New-Object System.Drawing.Point(20, 570)
$btnDisableStartup.Size = New-Object System.Drawing.Size(350, 50)
$btnDisableStartup.BackColor = [System.Drawing.Color]::DarkRed
$btnDisableStartup.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnDisableStartup.FlatAppearance.BorderSize = 0
$btnDisableStartup.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$btnDisableStartup.Add_Click({
    if ($listStartup.SelectedItems.Count -gt 0) {
        $sel = $listStartup.SelectedItems[0]; $name = $sel.Text; $hive = $sel.SubItems[1].Text
        $rp = if ($hive -eq "HKCU") { "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" } else { "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" }
        Remove-ItemProperty $rp -Name $name -Force -ErrorAction SilentlyContinue
        Set-Status "$name removed from startup."
        Load-Startup
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select an app first.", "Info")
    }
})

$btnRefreshStartup = New-Object System.Windows.Forms.Button
$btnRefreshStartup.Text = "Refresh List"
$btnRefreshStartup.Location = New-Object System.Drawing.Point(390, 570)
$btnRefreshStartup.Size = New-Object System.Drawing.Size(150, 50)
$btnRefreshStartup.BackColor = [System.Drawing.Color]::FromArgb(63, 63, 70)
$btnRefreshStartup.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnRefreshStartup.FlatAppearance.BorderSize = 0
$btnRefreshStartup.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$btnRefreshStartup.Add_Click({ Load-Startup })

$tabStartup.Controls.AddRange(@($listStartup, $btnDisableStartup, $btnRefreshStartup))

# ==========================================
# TAB 4: WinUtil Debloat
# ==========================================
$tabWinUtil = New-Object System.Windows.Forms.TabPage
$tabWinUtil.Text = "  WinUtil Debloat  "
$tabWinUtil.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)

$flowWU = New-Object System.Windows.Forms.FlowLayoutPanel
$flowWU.Dock = "Fill"
$flowWU.AutoScroll = $true
$flowWU.Padding = New-Object System.Windows.Forms.Padding(20)

Add-ToggleItem $flowWU "[UI]   Enable Dark Mode System-Wide" {
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" 0 -Type DWord -Force
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" 0 -Type DWord -Force
    Set-Status "Dark Mode ON"
} {
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" 1 -Type DWord -Force
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" 1 -Type DWord -Force
    Set-Status "Light Mode ON"
}

Add-ToggleItem $flowWU "[EXT]  Show File Extensions in Explorer" {
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0 -Type DWord -Force
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Set-Status "File extensions visible."
} {
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 1 -Type DWord -Force
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Set-Status "File extensions hidden."
}

Add-ToggleItem $flowWU "[HDN]  Show Hidden Files & Folders" {
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1 -Type DWord -Force
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Set-Status "Hidden files visible."
} {
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 2 -Type DWord -Force
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Set-Status "Hidden files hidden."
}

Add-ToggleItem $flowWU "[UPD]  Disable Windows Auto Updates" {
    $wu = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    if (!(Test-Path $wu)) { New-Item $wu -Force | Out-Null }
    Set-ItemProperty $wu "NoAutoUpdate" 1 -Type DWord -Force
    Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
    Set-Service wuauserv -StartupType Disabled -ErrorAction SilentlyContinue
    Set-Status "Windows Update disabled."
} {
    $wu = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    if (Test-Path $wu) { Remove-ItemProperty $wu "NoAutoUpdate" -Force -ErrorAction SilentlyContinue }
    Set-Service wuauserv -StartupType Automatic -ErrorAction SilentlyContinue
    Start-Service wuauserv -ErrorAction SilentlyContinue
    Set-Status "Windows Update enabled."
}

Add-ToggleItem $flowWU "[NTF]  Disable Notification Banners" {
    $np = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications"
    if (!(Test-Path $np)) { New-Item $np -Force | Out-Null }
    Set-ItemProperty $np "ToastEnabled" 0 -Type DWord -Force
    Set-Status "Notifications disabled."
} {
    $np = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications"
    Set-ItemProperty $np "ToastEnabled" 1 -Type DWord -Force
    Set-Status "Notifications enabled."
}

Add-ToggleItem $flowWU "[VBS]  Disable VBS & Core Isolation - FPS Boost" {
    $vbs = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard"
    if (!(Test-Path $vbs)) { New-Item $vbs -Force | Out-Null }
    Set-ItemProperty $vbs "EnableVirtualizationBasedSecurity" 0 -Type DWord -Force
    Set-Status "VBS disabled. Restart to apply."
    [System.Windows.Forms.MessageBox]::Show("VBS Disabled! Restart PC to apply (FPS Boost).", "Info")
} {
    $vbs = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard"
    Set-ItemProperty $vbs "EnableVirtualizationBasedSecurity" 1 -Type DWord -Force
    Set-Status "VBS enabled."
}

Add-ToggleItem $flowWU "[GPU]  Gaming GPU Priority Tweak" {
    $gp = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
    if (!(Test-Path $gp)) { New-Item $gp -Force | Out-Null }
    Set-ItemProperty $gp "GPU Priority" 8 -Type DWord -Force
    Set-ItemProperty $gp "Priority" 6 -Type DWord -Force
    Set-Status "GPU Priority maxed for gaming."
} {
    $gp = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
    Set-ItemProperty $gp "GPU Priority" 2 -Type DWord -Force
    Set-ItemProperty $gp "Priority" 2 -Type DWord -Force
    Set-Status "GPU Priority set to default."
}

Add-ToggleItem $flowWU "[AIM]  Disable Mouse Acceleration - Raw Input" {
    Set-ItemProperty "HKCU:\Control Panel\Mouse" "MouseSpeed" "0" -Force
    Set-Status "Mouse acceleration OFF - Raw Input active."
} {
    Set-ItemProperty "HKCU:\Control Panel\Mouse" "MouseSpeed" "1" -Force
    Set-Status "Mouse acceleration ON."
}

Add-ToggleItem $flowWU "[SVC]  Stop Heavy Background Services" {
    @("SysMain","WSearch","RetailDemo") | ForEach-Object {
        Stop-Service $_ -Force -ErrorAction SilentlyContinue
        Set-Service $_ -StartupType Disabled -ErrorAction SilentlyContinue
    }
    Set-Status "Heavy services stopped."
} {
    @("SysMain","WSearch") | ForEach-Object {
        Set-Service $_ -StartupType Automatic -ErrorAction SilentlyContinue
        Start-Service $_ -ErrorAction SilentlyContinue
    }
    Set-Status "Services restored."
}

$tabWinUtil.Controls.Add($flowWU)

# ==========================================
# TAB 5: Gaming & Fixes
# ==========================================
$tabFixes = New-Object System.Windows.Forms.TabPage
$tabFixes.Text = "  Gaming & Fixes  "
$tabFixes.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)

$flowFixes = New-Object System.Windows.Forms.FlowLayoutPanel
$flowFixes.Dock = "Fill"
$flowFixes.AutoScroll = $true
$flowFixes.Padding = New-Object System.Windows.Forms.Padding(20)

Add-ToggleItem $flowFixes "[CTX]  Restore Win 10 Classic Context Menu" {
    New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Force | Out-Null
    Set-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Name "(Default)" -Value "" -Force
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Set-Status "Win 10 Context Menu enabled."
} {
    Remove-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Recurse -Force -ErrorAction SilentlyContinue
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Set-Status "Win 11 Context Menu restored."
}

Add-ActionItem $flowFixes "[VCR]  Install Visual C++ Redist - All in One" ([System.Drawing.Color]::FromArgb(0,122,204)) {
    Start-Process "cmd.exe" -ArgumentList "/c winget install --id Microsoft.VCRedist.2015+.x64 -e --accept-package-agreements --accept-source-agreements" -Wait
    [System.Windows.Forms.MessageBox]::Show("Visual C++ Redistributable Installed!", "Done")
}

Add-ActionItem $flowFixes "[DX]   Install DirectX - For Gaming" ([System.Drawing.Color]::FromArgb(0,122,204)) {
    Start-Process "cmd.exe" -ArgumentList "/c winget install --id Microsoft.DirectX -e --accept-package-agreements --accept-source-agreements" -Wait
    [System.Windows.Forms.MessageBox]::Show("DirectX Installed!", "Done")
}

Add-ActionItem $flowFixes "[SFC]  Repair Windows Corrupt Files - SFC & DISM" ([System.Drawing.Color]::FromArgb(100,30,30)) {
    [System.Windows.Forms.MessageBox]::Show("This will open a black window. Takes 5-10 minutes, let it finish!", "Info")
    Start-Process "cmd.exe" -ArgumentList "/c DISM /Online /Cleanup-Image /RestoreHealth && sfc /scannow && pause"
}

Add-ActionItem $flowFixes "[NET]  Deep Network Reset - Fix Connection Issues" ([System.Drawing.Color]::FromArgb(100,60,0)) {
    Start-Process "cmd.exe" -ArgumentList "/c ipconfig /release && ipconfig /renew && ipconfig /flushdns && netsh winsock reset && netsh int ip reset && pause"
    [System.Windows.Forms.MessageBox]::Show("Deep Network Reset done! Restart PC to fully apply.", "Done")
}

$tabFixes.Controls.Add($flowFixes)

# ==========================================
# Build Form
# ==========================================
$tabControl.Controls.AddRange(@($tabApps, $tabTweaks, $tabStartup, $tabWinUtil, $tabFixes))
$form.Controls.Add($tabControl)
$form.Controls.Add($statusBar)
$form.ShowDialog() | Out-Null

