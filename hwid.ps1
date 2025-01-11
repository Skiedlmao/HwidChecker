Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Check-AdminRights {
    $user = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $user.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if (-not (Check-AdminRights)) {
    [System.Windows.Forms.MessageBox]::Show(
        "Please run this script as Administrator!",
        "Insufficient Privileges",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
    exit
}

$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Text = "HWID Collection & Reporting"
$mainForm.Width = 800
$mainForm.Height = 550
$mainForm.StartPosition = "CenterScreen"
$mainForm.FormBorderStyle = 'None'
$mainForm.BackColor = [System.Drawing.Color]::FromArgb(35,35,35)
$global:grabPoint = $null

$topPanel = New-Object System.Windows.Forms.Panel
$topPanel.Width = $mainForm.Width
$topPanel.Height = 40
$topPanel.Location = New-Object System.Drawing.Point(0,0)
$topPanel.BackColor = [System.Drawing.Color]::FromArgb(25,25,25)
$topPanel.Cursor = [System.Windows.Forms.Cursors]::SizeAll
$mainForm.Controls.Add($topPanel)

$topPanel.Add_MouseDown({
    param($sender, $args)
    if ($args.Button -eq [System.Windows.Forms.MouseButtons]::Left) {
        $global:grabPoint = New-Object System.Drawing.Point($args.X, $args.Y)
    }
})
$topPanel.Add_MouseMove({
    param($sender, $args)
    if ($global:grabPoint -ne $null) {
        $mainForm.Location = New-Object System.Drawing.Point(
            $mainForm.Left + $args.X - $global:grabPoint.X,
            $mainForm.Top + $args.Y - $global:grabPoint.Y
        )
    }
})
$topPanel.Add_MouseUp({
    $global:grabPoint = $null
})

$closeLabel = New-Object System.Windows.Forms.Label
$closeLabel.Text = "✕"
$closeLabel.Font = New-Object System.Drawing.Font("Segoe UI",14,[System.Drawing.FontStyle]::Bold)
$closeLabel.ForeColor = [System.Drawing.Color]::White
$closeLabel.AutoSize = $true
$closeLabel.Cursor = [System.Windows.Forms.Cursors]::Hand
$closeLabel.Location = New-Object System.Drawing.Point(760,8)
$closeLabel.Add_MouseEnter({ $closeLabel.ForeColor = [System.Drawing.Color]::FromArgb(252,92,101) })
$closeLabel.Add_MouseLeave({ $closeLabel.ForeColor = [System.Drawing.Color]::White })
$closeLabel.Add_Click({ $mainForm.Close() })
$topPanel.Controls.Add($closeLabel)

$mainPanel = New-Object System.Windows.Forms.Panel
$mainPanel.Width = 700
$mainPanel.Height = 400
$mainPanel.Location = New-Object System.Drawing.Point(50,70)
$mainPanel.BackColor = [System.Drawing.Color]::FromArgb(45,45,45)
$mainForm.Controls.Add($mainPanel)

$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "HWID Collection & Reporting"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI Semibold",16,[System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::White
$titleLabel.AutoSize = $true
$titleLabel.Location = New-Object System.Drawing.Point(20,20)
$mainPanel.Controls.Add($titleLabel)

$ignLabel = New-Object System.Windows.Forms.Label
$ignLabel.Text = "In-Game Name (IGN):"
$ignLabel.Font = New-Object System.Drawing.Font("Segoe UI",11)
$ignLabel.ForeColor = [System.Drawing.Color]::White
$ignLabel.AutoSize = $true
$ignLabel.Location = New-Object System.Drawing.Point(20,80)
$mainPanel.Controls.Add($ignLabel)

$ignBox = New-Object System.Windows.Forms.TextBox
$ignBox.Font = New-Object System.Drawing.Font("Segoe UI",11)
$ignBox.Width = 400
$ignBox.Location = New-Object System.Drawing.Point(200,77)
$mainPanel.Controls.Add($ignBox)

$cpuLabel = New-Object System.Windows.Forms.Label
$cpuLabel.Text = "CPU ID:"
$cpuLabel.Font = New-Object System.Drawing.Font("Segoe UI",11)
$cpuLabel.ForeColor = [System.Drawing.Color]::White
$cpuLabel.AutoSize = $true
$cpuLabel.Location = New-Object System.Drawing.Point(20,130)
$mainPanel.Controls.Add($cpuLabel)

$cpuBox = New-Object System.Windows.Forms.TextBox
$cpuBox.Font = New-Object System.Drawing.Font("Segoe UI",11)
$cpuBox.Width = 400
$cpuBox.ReadOnly = $true
$cpuBox.Location = New-Object System.Drawing.Point(200,127)
$mainPanel.Controls.Add($cpuBox)

$memLabel = New-Object System.Windows.Forms.Label
$memLabel.Text = "Memory Serial(s):"
$memLabel.Font = New-Object System.Drawing.Font("Segoe UI",11)
$memLabel.ForeColor = [System.Drawing.Color]::White
$memLabel.AutoSize = $true
$memLabel.Location = New-Object System.Drawing.Point(20,180)
$mainPanel.Controls.Add($memLabel)

$memBox = New-Object System.Windows.Forms.TextBox
$memBox.Font = New-Object System.Drawing.Font("Segoe UI",11)
$memBox.Width = 400
$memBox.ReadOnly = $true
$memBox.Location = New-Object System.Drawing.Point(200,177)
$mainPanel.Controls.Add($memBox)

$diskLabel = New-Object System.Windows.Forms.Label
$diskLabel.Text = "Disk Serial(s):"
$diskLabel.Font = New-Object System.Drawing.Font("Segoe UI",11)
$diskLabel.ForeColor = [System.Drawing.Color]::White
$diskLabel.AutoSize = $true
$diskLabel.Location = New-Object System.Drawing.Point(20,230)
$mainPanel.Controls.Add($diskLabel)

$diskBox = New-Object System.Windows.Forms.TextBox
$diskBox.Font = New-Object System.Drawing.Font("Segoe UI",11)
$diskBox.Width = 400
$diskBox.ReadOnly = $true
$diskBox.Location = New-Object System.Drawing.Point(200,227)
$mainPanel.Controls.Add($diskBox)

$collectButton = New-Object System.Windows.Forms.Button
$collectButton.Text = "Collect HWID Info"
$collectButton.Font = New-Object System.Drawing.Font("Segoe UI Semibold",12,[System.Drawing.FontStyle]::Bold)
$collectButton.Width = 200
$collectButton.Height = 40
$collectButton.Location = New-Object System.Drawing.Point(20,300)
$collectButton.FlatStyle = 'Flat'
$collectButton.BackColor = [System.Drawing.Color]::FromArgb(69,170,242)
$collectButton.ForeColor = [System.Drawing.Color]::White
$mainPanel.Controls.Add($collectButton)

$collectButton.Add_Click({
    $cpu  = (Get-WmiObject Win32_Processor).ProcessorId
    $mem  = (Get-WmiObject Win32_PhysicalMemory).SerialNumber -join ", "
    $disk = (Get-WmiObject Win32_DiskDrive).SerialNumber -join ", "
    $cpuBox.Text = $cpu
    $memBox.Text = $mem
    $diskBox.Text = $disk
})

$closeButton = New-Object System.Windows.Forms.Button
$closeButton.Text = "Close"
$closeButton.Font = New-Object System.Drawing.Font("Segoe UI Semibold",12,[System.Drawing.FontStyle]::Bold)
$closeButton.Width = 120
$closeButton.Height = 40
$closeButton.Location = New-Object System.Drawing.Point(280,300)
$closeButton.FlatStyle = 'Flat'
$closeButton.BackColor = [System.Drawing.Color]::FromArgb(252,92,101)
$closeButton.ForeColor = [System.Drawing.Color]::White
$mainPanel.Controls.Add($closeButton)

$closeButton.Add_Click({
    $mainForm.Close()
})

[void] $mainForm.ShowDialog()
