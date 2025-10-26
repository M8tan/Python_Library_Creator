Add-Type -AssemblyName system.windows.forms
Add-Type -AssemblyName system.drawing
Add-Type -AssemblyName system.io

$package_name = "build"
$result = pip show $package_name 2>&1

if ($result -like "*Package(s) not found*") {
    try{
        pip install build
    } catch {
        Write-Host ""
    }
} else {
    Write-Host ""
}

#$Found_TOML = $false

$Main_Form = New-Object System.Windows.Forms.Form
$Main_Form.StartPosition = "centerscreen"
$Main_Form.Text = "PYLib creator"
$Main_Form.Size = New-Object System.Drawing.Size(500,500)

$Main_Form_Label = New-Object System.Windows.Forms.Label
$Main_Form_Label.Font = New-Object System.Drawing.Font("arial", 14)
$Main_Form_Label.Location = New-Object System.Drawing.Point(20,20)
$Main_Form_Label.Text = "Tool to create python libraries"
$Main_Form_Label.Size = New-Object System.Drawing.Size(400,80)
$Main_Form.Controls.Add($Main_Form_Label)

$Main_Form_Location_Label = New-Object System.Windows.Forms.Label
$Main_Form_Location_Label.Font = New-Object System.Drawing.Font("arial", 14)
$Main_Form_Location_Label.Location = New-Object System.Drawing.Point(20,100)
$Main_Form_Location_Label.Text = "Location of library {directory}:"
$Main_Form_Location_Label.Size = New-Object System.Drawing.Size(130,80)
$Main_Form.Controls.Add($Main_Form_Location_Label)
$Main_Form_Location_TB = New-Object System.Windows.Forms.TextBox
$Main_Form_Location_TB.Size = New-Object System.Drawing.Size(250)
$Main_Form_Location_TB.Location = New-Object System.Drawing.Point(180,150)
$Main_Form_Location_TB.Font = New-Object System.Drawing.Font("arial", 16)
$Main_Form_Location_TB.Text = "E.G C:\Projects\ADSec"
$Main_Form.Controls.Add($Main_Form_Location_TB)

$Main_Form_LibName_Label = New-Object System.Windows.Forms.Label
$Main_Form_LibName_Label.Font = New-Object System.Drawing.Font("arial", 14)
$Main_Form_LibName_Label.Location = New-Object System.Drawing.Point(20,200)
$Main_Form_LibName_Label.Text = "Library name:"
$Main_Form_LibName_Label.Size = New-Object System.Drawing.Size(150,50)
$Main_Form.Controls.Add($Main_Form_LibName_Label)
$Main_Form_LibName_TB = New-Object System.Windows.Forms.TextBox
$Main_Form_LibName_TB.Size = New-Object System.Drawing.Size(250)
$Main_Form_LibName_TB.Location = New-Object System.Drawing.Point(180,215)
$Main_Form_LibName_TB.Font = New-Object System.Drawing.Font("arial", 16)
$Main_Form_LibName_TB.Text = ""
$Main_Form.Controls.Add($Main_Form_LibName_TB)

$Main_Form_Description_Label = New-Object System.Windows.Forms.Label
$Main_Form_Description_Label.Font = New-Object System.Drawing.Font("arial", 14)
$Main_Form_Description_Label.Location = New-Object System.Drawing.Point(20,270)
$Main_Form_Description_Label.Text = "Description:"
$Main_Form_Description_Label.Size = New-Object System.Drawing.Size(150,50)
$Main_Form.Controls.Add($Main_Form_Description_Label)
$Main_Form_Description_TB = New-Object System.Windows.Forms.TextBox
$Main_Form_Description_TB.Size = New-Object System.Drawing.Size(250)
$Main_Form_Description_TB.Location = New-Object System.Drawing.Point(180,270)
$Main_Form_Description_TB.Font = New-Object System.Drawing.Font("arial", 16)
$Main_Form_Description_TB.Text = ""
$Main_Form.Controls.Add($Main_Form_Description_TB)

$Main_Form_Create_Button = New-Object System.Windows.Forms.Button
$Main_Form_Create_Button.Text = "Create"
$Main_Form_Create_Button.Font = New-Object System.Drawing.Font("arial", 14)
$Main_Form_Create_Button.Location = New-Object System.Drawing.Point(130,400)
$Main_Form_Create_Button.Size = New-Object System.Drawing.Size(100,40)
$Main_Form.Controls.Add($Main_Form_Create_Button)

$Main_Form_Build_Button = New-Object System.Windows.Forms.Button
$Main_Form_Build_Button.Text = "Build"
$Main_Form_Build_Button.Font = New-Object System.Drawing.Font("arial", 14)
$Main_Form_Build_Button.Location = New-Object System.Drawing.Point(240,400)
$Main_Form_Build_Button.Size = New-Object System.Drawing.Size(100,40)
$Main_Form.Controls.Add($Main_Form_Build_Button)

$Main_Form_Help_Button = New-Object System.Windows.Forms.Button
$Main_Form_Help_Button.Text = "?"
$Main_Form_Help_Button.Font = New-Object System.Drawing.Font("arial", 14)
$Main_Form_Help_Button.Location = New-Object System.Drawing.Point(440,20)
$Main_Form_Help_Button.Size = New-Object System.Drawing.Size(40,40)
$Main_Form.Controls.Add($Main_Form_Help_Button)

function Search-TOML($Search_Path){
$Chosen_Directory_Content = Get-ChildItem -Path $Search_Path | where {$_.Name -like "pyproject.toml"}
if($Chosen_Directory_Content -eq $null){
return $false
} else {
return $true
}
}
function Search-WHL($Search_Path){
$Chosen_Directory_Content = Get-ChildItem -Path $Search_Path | where {$_.Extension -like ".whl"}
if($Chosen_Directory_Content -eq $null){
return $false
} else {
return $Chosen_Directory_Content
}
}
function Create-Structure($Creation_Path, $Library_Creation_Name, $Library_Description){
try{
$TOML_Content = @"
[build-system]
requires = ["setuptools>=61.0"]
build-backend = "setuptools.build_meta"

[project]
name = "$Library_Creation_Name"
version = "0.1.0"
description = "$Library_Description"
readme = "README.md"
license = "MIT"
requires-python = ">=3.8"
#authors = [{ name = "", email = ""}]
#You can un-comment the authors part and enter your details
[tool.setuptools.packages.find]
where = ["src"]


"@
New-Item -Path $Creation_Path -ItemType directory -Name $Library_Creation_Name -Confirm:$false -ErrorAction Stop
New-Item -Path "$Creation_Path\$Library_Creation_Name" -ItemType file -Name pyproject.toml -Value $TOML_Content -Confirm:$false -ErrorAction Stop
New-Item -Path "$Creation_Path\$Library_Creation_Name" -ItemType file -Name README.md -Value $Library_Description -Confirm:$false -ErrorAction Stop
New-Item -Path "$Creation_Path\$Library_Creation_Name" -ItemType directory -Name src -Confirm:$false -ErrorAction Stop
New-Item -Path "$Creation_Path\$Library_Creation_Name\src" -ItemType directory -Name $Library_Creation_Name -Confirm:$false -ErrorAction Stop
New-Item -Path "$Creation_Path\$Library_Creation_Name\src\$Library_Creation_Name" -ItemType file -Name __init__.py -Value "from .$Library_Creation_Name import *" -Confirm:$false -ErrorAction Stop
New-Item -Path "$Creation_Path\$Library_Creation_Name\src\$Library_Creation_Name" -ItemType file -Name "$Library_Creation_Name.py" -Confirm:$false -ErrorAction Stop


} catch {
([System.Windows.Forms.MessageBox]::Show("Unknown error", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
}
}

$Main_Form_Help_Button.add_click({
([System.Windows.Forms.MessageBox]::Show("*** If you want to create a brand new library - enter the directory in which you want to generate the library structure {e.g - c:\Projects\Python}, the name you chose for the library {e.g - mystringformatter}, a short description {e.g - a library to format strings in python} and press create. Then, you can go to the new directory {e.g - c:\Projects\Python\mystringformatter\mystringformatter} and open the library file {e.g - mystringformatter.py}, edit it and continue in your way. *** If you already have a structured library and want to make it an actually installable and importable library - enter the root path {e.g - c:\Projects\Python\mystringformatter} and press build. Notice - it requires the python 'build' library. We will try to unstall it using pip, if not installed already.", "Guide", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information))

})

$Main_Form_Create_Button.add_click({

$Library_Location = $Main_Form_Location_TB.Text
$Library_Name = $Main_Form_LibName_TB.Text
$Library_Description = $Main_Form_Description_TB.Text
if($Library_Location -notlike $null -and $Library_Name -notlike $null -and $Library_Description -notlike $null){
Create-Structure -Creation_Path $Library_Location -Library_Creation_Name $Library_Name -Library_Description $Library_Description
([System.Windows.Forms.MessageBox]::Show("Created the library $Library_Name in $Library_Location", "Done", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information))
} else {
([System.Windows.Forms.MessageBox]::Show("Please fill in the required details", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
}
})

$Main_Form_Build_Button.add_click({

$Library_Location = $Main_Form_Location_TB.Text
if (Test-Path -Path $Library_Location){
$Found_TOML = Search-TOML -Search_Path $Library_Location
if ($Found_TOML){
cd $Library_Location
python -m build
$Library_WHL = Search-WHL -Search_Path "$Library_Location\dist"
if($Library_WHL -ne $false){
pip install "dist\$Library_WHL"
([System.Windows.Forms.MessageBox]::Show("Build process succeeded", "Done", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information))
} else {
([System.Windows.Forms.MessageBox]::Show("No WHL file, problem with build library", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
}
} else {
([System.Windows.Forms.MessageBox]::Show("pyproject.toml file not found", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
}
} else {
([System.Windows.Forms.MessageBox]::Show("Path not found", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))

}

})

$Main_Form.ShowDialog()

# ([System.Windows.Forms.MessageBox]::Show("File or directory not found \ No password set", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))


# SIG # Begin signature block
# MIIFagYJKoZIhvcNAQcCoIIFWzCCBVcCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUeYORnZR9X6ipdZdExy7cey/Q
# 20KgggMGMIIDAjCCAeqgAwIBAgIQM4NUsN5cJZ5FZ731vM5glTANBgkqhkiG9w0B
# AQsFADAZMRcwFQYDVQQDDA5QU0dDZXJ0aWZpY2F0ZTAeFw0yNTEwMjYwODUwNTha
# Fw0yNjEwMjYwOTEwNThaMBkxFzAVBgNVBAMMDlBTR0NlcnRpZmljYXRlMIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAs/pBPlyyneeJdjNWUHYT1isEn617
# txFATR6BuXZtmiXaWuR0x15H/VXBBV6zTUR6kYFIGnzVMj1Ay4szyiDj8oodIQ5c
# rRYBskYMOufUMQ2hqrbgfPXT42Li+irTQWYrn6ZBF+UcdBXoUe5HBN9OemqrA+Pt
# WicoAQ/m4u54dm+hL1jmXIjbew5NL+9j+kE4GN539w3cofKVxp502i4gasVBfjqf
# wECqfONAgC1i2N1Yh2i/6GmvsO96eK3vVQX8P9EtlI/HcARXCulDOa/c0wdgt0no
# 3GD25QAbKrh+r0z/xFW1k2V+VJMKuBOKzgSlQyoM2r9SvBa5nfSwV05KgQIDAQAB
# o0YwRDAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0O
# BBYEFHkVpMRHBoKqY3wwhB+P90pWLe2pMA0GCSqGSIb3DQEBCwUAA4IBAQCGgRTd
# YEo4YJ/rLmPsljuR0mtFkYgZN85t8vbaMcGFtDc6C18MCxN62P3VIVxaGyaA8nKW
# Uoy0f8nKiO9jIF45nEZHd2Uod0vvVO/OKUhBHXKv0OR7w6PgZtodROcpITlsqs47
# +4cJOmBOSM8HRO854fBxHPRd0ABlWgVVRj4h/VBLbEQd+ODaBJ3O7KMhLLEHZIEk
# rEuZ+ZkV/h2cSj1R7ThFplYXS1tPGEmQJh81wdcQX6Pu9dPyuT1hCKj2o7JaXUcA
# u8LbL50XB7poyND5yFkLRbkZ2BfyikUD2R3dbCXiSxbOQN+lMzteHjzmya1BEVYC
# AxzCEDtZXUFbld+nMYIBzjCCAcoCAQEwLTAZMRcwFQYDVQQDDA5QU0dDZXJ0aWZp
# Y2F0ZQIQM4NUsN5cJZ5FZ731vM5glTAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIB
# DDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEE
# AYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQURNJL9TKH2NYO
# +OlX5MLtes2U+jIwDQYJKoZIhvcNAQEBBQAEggEAoZBEvn3MjBIBIWTWHsEP41LY
# 6uC0LeE10wCBSa+G5ntrAUBB31+18wxxxN7WeYLVXqMO3DFu4h2OLgq6ZkqewM5Z
# qNEABhdd/a6sVqKeOHUct1KmXSG+umV1MxA3G5b7ZkuUoePM7/bnsWyc5+Wf1+72
# LU9c9Dn3VklrBC6OsP0TWRT58SBaVgQwKA1t9LRvnDMGYTmqMu20vWIoekeW6OgR
# USwVXxClMxAUycxHfZkzUZfmk31deEFeAnVF9EDB5Nf78ZY0JvvkxuNYE34XtVZ7
# G7PhCzHVF+ikSDOFej4pTRcrJgBOwVv6wpleZaxDbHgAJtGzF5/ZVLUBEURnCg==
# SIG # End signature block
