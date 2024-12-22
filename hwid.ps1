Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function fu2 {
    $cu = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $cu.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if (-not (fu2)) {
    [System.Windows.Forms.MessageBox]::Show(
        "Please run this script as Administrator!",
        "Insufficient Privileges",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
    exit
}

$f = New-Object System.Windows.Forms.Form
$f.Text = "HWID Collection & Reporting"
$f.Width = 800
$f.Height = 550
$f.StartPosition = "CenterScreen"
$f.FormBorderStyle = 'None'
$f.BackColor = [System.Drawing.Color]::FromArgb(35,35,35)
$global:g = $null

$t = New-Object System.Windows.Forms.Panel
$t.Width = $f.Width
$t.Height = 40
$t.Location = New-Object System.Drawing.Point(0,0)
$t.BackColor = [System.Drawing.Color]::FromArgb(25,25,25)
$t.Cursor = [System.Windows.Forms.Cursors]::SizeAll
$f.Controls.Add($t)

$t.Add_MouseDown({
    param($s,$e)
    if($e.Button -eq [System.Windows.Forms.MouseButtons]::Left){
        $global:g = New-Object System.Drawing.Point($e.X,$e.Y)
    }
})
$t.Add_MouseMove({
    param($s,$e)
    if($global:g -ne $null){
        $f.Location = New-Object System.Drawing.Point($f.Left + $e.X - $global:g.X, $f.Top + $e.Y - $global:g.Y)
    }
})
$t.Add_MouseUp({ $global:g = $null })

$c = New-Object System.Windows.Forms.Label
$c.Text = "✕"
$c.Font = New-Object System.Drawing.Font("Segoe UI",14,[System.Drawing.FontStyle]::Bold)
$c.ForeColor = [System.Drawing.Color]::White
$c.AutoSize = $true
$c.Cursor = [System.Windows.Forms.Cursors]::Hand
$c.Location = New-Object System.Drawing.Point(760,8)
$c.Add_MouseEnter({ $c.ForeColor = [System.Drawing.Color]::FromArgb(252,92,101) })
$c.Add_MouseLeave({ $c.ForeColor = [System.Drawing.Color]::White })
$c.Add_Click({ $f.Close() })
$t.Controls.Add($c)

$p = New-Object System.Windows.Forms.Panel
$p.Width = 700
$p.Height = 400
$p.Location = New-Object System.Drawing.Point(50,70)
$p.BackColor = [System.Drawing.Color]::FromArgb(45,45,45)
$f.Controls.Add($p)

$l0 = New-Object System.Windows.Forms.Label
$l0.Text = "HWID Collection & Reporting"
$l0.Font = New-Object System.Drawing.Font("Segoe UI Semibold",16,[System.Drawing.FontStyle]::Bold)
$l0.ForeColor = [System.Drawing.Color]::White
$l0.AutoSize = $true
$l0.Location = New-Object System.Drawing.Point(20,20)
$p.Controls.Add($l0)

$l1 = New-Object System.Windows.Forms.Label
$l1.Text = "In-Game Name (IGN):"
$l1.Font = New-Object System.Drawing.Font("Segoe UI",11)
$l1.ForeColor = [System.Drawing.Color]::White
$l1.AutoSize = $true
$l1.Location = New-Object System.Drawing.Point(20,80)
$p.Controls.Add($l1)

$tb1 = New-Object System.Windows.Forms.TextBox
$tb1.Font = New-Object System.Drawing.Font("Segoe UI",11)
$tb1.Width = 400
$tb1.Location = New-Object System.Drawing.Point(200,77)
$p.Controls.Add($tb1)

$l2 = New-Object System.Windows.Forms.Label
$l2.Text = "CPU ID:"
$l2.Font = New-Object System.Drawing.Font("Segoe UI",11)
$l2.ForeColor = [System.Drawing.Color]::White
$l2.AutoSize = $true
$l2.Location = New-Object System.Drawing.Point(20,130)
$p.Controls.Add($l2)

$tb2 = New-Object System.Windows.Forms.TextBox
$tb2.Font = New-Object System.Drawing.Font("Segoe UI",11)
$tb2.Width = 400
$tb2.ReadOnly = $true
$tb2.Location = New-Object System.Drawing.Point(200,127)
$p.Controls.Add($tb2)

$l3 = New-Object System.Windows.Forms.Label
$l3.Text = "Memory Serial(s):"
$l3.Font = New-Object System.Drawing.Font("Segoe UI",11)
$l3.ForeColor = [System.Drawing.Color]::White
$l3.AutoSize = $true
$l3.Location = New-Object System.Drawing.Point(20,180)
$p.Controls.Add($l3)

$tb3 = New-Object System.Windows.Forms.TextBox
$tb3.Font = New-Object System.Drawing.Font("Segoe UI",11)
$tb3.Width = 400
$tb3.ReadOnly = $true
$tb3.Location = New-Object System.Drawing.Point(200,177)
$p.Controls.Add($tb3)

$l4 = New-Object System.Windows.Forms.Label
$l4.Text = "Disk Serial(s):"
$l4.Font = New-Object System.Drawing.Font("Segoe UI",11)
$l4.ForeColor = [System.Drawing.Color]::White
$l4.AutoSize = $true
$l4.Location = New-Object System.Drawing.Point(20,230)
$p.Controls.Add($l4)

$tb4 = New-Object System.Windows.Forms.TextBox
$tb4.Font = New-Object System.Drawing.Font("Segoe UI",11)
$tb4.Width = 400
$tb4.ReadOnly = $true
$tb4.Location = New-Object System.Drawing.Point(200,227)
$p.Controls.Add($tb4)

$bu = New-Object System.Windows.Forms.Button
$bu.Text = "Collect HWID Info"
$bu.Font = New-Object System.Drawing.Font("Segoe UI Semibold",12,[System.Drawing.FontStyle]::Bold)
$bu.Width = 200
$bu.Height = 40
$bu.Location = New-Object System.Drawing.Point(20,300)
$bu.FlatStyle = 'Flat'
$bu.BackColor = [System.Drawing.Color]::FromArgb(69,170,242)
$bu.ForeColor = [System.Drawing.Color]::White
$p.Controls.Add($bu)

$bu.Add_Click({
    $cpu  = (Get-WmiObject Win32_Processor).ProcessorId
    $mem  = (Get-WmiObject Win32_PhysicalMemory).SerialNumber -join ", "
    $disk = (Get-WmiObject Win32_DiskDrive).SerialNumber -join ", "

    $tb2.Text = $cpu
    $tb3.Text = $mem
    $tb4.Text = $disk
})

$bc = New-Object System.Windows.Forms.Button
$bc.Text = "Close"
$bc.Font = New-Object System.Drawing.Font("Segoe UI Semibold",12,[System.Drawing.FontStyle]::Bold)
$bc.Width = 120
$bc.Height = 40
$bc.Location = New-Object System.Drawing.Point(280,300)
$bc.FlatStyle = 'Flat'
$bc.BackColor = [System.Drawing.Color]::FromArgb(252,92,101)
$bc.ForeColor = [System.Drawing.Color]::White
$p.Controls.Add($bc)

$bc.Add_Click({ $f.Close() })

[void] $f.ShowDialog()
