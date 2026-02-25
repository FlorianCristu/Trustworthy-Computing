Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Sandbox Tool GUI"
$form.Size = New-Object System.Drawing.Size(640, 220)
$form.StartPosition = "CenterScreen"

$labelExe = New-Object System.Windows.Forms.Label
$labelExe.Text = "Executable (.exe):"
$labelExe.Location = New-Object System.Drawing.Point(12, 20)
$labelExe.AutoSize = $true
$form.Controls.Add($labelExe)

$textExe = New-Object System.Windows.Forms.TextBox
$textExe.Location = New-Object System.Drawing.Point(120, 16)
$textExe.Size = New-Object System.Drawing.Size(400, 24)
$form.Controls.Add($textExe)

$btnBrowse = New-Object System.Windows.Forms.Button
$btnBrowse.Text = "Browse..."
$btnBrowse.Location = New-Object System.Drawing.Point(530, 14)
$btnBrowse.Size = New-Object System.Drawing.Size(85, 28)
$form.Controls.Add($btnBrowse)

$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Text = "Run in Sandbox"
$btnRun.Location = New-Object System.Drawing.Point(120, 60)
$btnRun.Size = New-Object System.Drawing.Size(160, 32)
$form.Controls.Add($btnRun)

$chkNetworking = New-Object System.Windows.Forms.CheckBox
$chkNetworking.Text = "Enable networking"
$chkNetworking.Location = New-Object System.Drawing.Point(300, 66)
$chkNetworking.AutoSize = $true
$chkNetworking.Checked = $false   # default to disabled (matches your current config)
$form.Controls.Add($chkNetworking)

$status = New-Object System.Windows.Forms.Label
$status.Text = "Status: Ready"
$status.Location = New-Object System.Drawing.Point(120, 110)
$status.AutoSize = $true
$form.Controls.Add($status)

$openFile = New-Object System.Windows.Forms.OpenFileDialog
$openFile.Filter = "Executable (*.exe)|*.exe|All files (*.*)|*.*"
$openFile.Title = "Select an executable to run in Windows Sandbox"

$btnBrowse.Add_Click({
    if ($openFile.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textExe.Text = $openFile.FileName
    }
})

$btnRun.Add_Click({
    $exePath = $textExe.Text.Trim()

    if ([string]::IsNullOrWhiteSpace($exePath) -or -not (Test-Path $exePath)) {
        [System.Windows.Forms.MessageBox]::Show("Please select a valid .exe file first.", "Missing executable",
            [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning) | Out-Null
        return
    }

    $scriptDir = $PSScriptRoot
    $runner = Join-Path $scriptDir "run_sandbox.ps1"

    if (-not (Test-Path $runner)) {
        [System.Windows.Forms.MessageBox]::Show("Cannot find run_sandbox.ps1 in the automation folder.", "Missing script",
            [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
        return
    }

    try {
        $status.Text = "Status: Launching Windows Sandbox..."
        # Call your existing working script (engine) without changing it
       if ($chkNetworking.Checked) {
    & powershell -ExecutionPolicy Bypass -File $runner -FilePath $exePath -EnableNetworking
}
else {
    & powershell -ExecutionPolicy Bypass -File $runner -FilePath $exePath
}
        $status.Text = "Status: Sandbox launched. Check output file after closing Sandbox."
    }
    catch {
        $status.Text = "Status: Error"
        [System.Windows.Forms.MessageBox]::Show($_.Exception.Message, "Error",
            [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error) | Out-Null
    }
})

[void]$form.ShowDialog()