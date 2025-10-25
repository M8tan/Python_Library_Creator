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

"@
New-Item -Path $Creation_Path -ItemType directory -Name $Library_Creation_Name -Confirm:$false -ErrorAction Stop
New-Item -Path "$Creation_Path\$Library_Creation_Name" -ItemType file -Name pyproject.toml -Value $TOML_Content -Confirm:$false -ErrorAction Stop
New-Item -Path "$Creation_Path\$Library_Creation_Name" -ItemType file -Name README.md -Value $Library_Description -Confirm:$false -ErrorAction Stop
New-Item -Path "$Creation_Path\$Library_Creation_Name" -ItemType directory -Name $Library_Creation_Name -Confirm:$false -ErrorAction Stop
New-Item -Path "$Creation_Path\$Library_Creation_Name\$Library_Creation_Name" -ItemType file -Name __init__.py -Value "from .$Library_Creation_Name import *" -Confirm:$false -ErrorAction Stop
New-Item -Path "$Creation_Path\$Library_Creation_Name\$Library_Creation_Name" -ItemType file -Name "$Library_Creation_Name.py" -Confirm:$false -ErrorAction Stop


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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQURpDvhKA9bl26XOmpyG+jLEag
# nUygggMGMIIDAjCCAeqgAwIBAgIQfuUMOodC171JJFV/Av8OFDANBgkqhkiG9w0B
# AQsFADAZMRcwFQYDVQQDDA5QU0dDZXJ0aWZpY2F0ZTAeFw0yNTEwMjUxNzA0Mzla
# Fw0yNjEwMjUxNzI0MzlaMBkxFzAVBgNVBAMMDlBTR0NlcnRpZmljYXRlMIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6pjmeTnLo5tgev1oXaibWZ24iXZF
# IRR1EWWT1u0Pny5X5GPzJ7eU5O1uQHfpwlkFWJNj4/rbX/NZVkl92AkjjCdnB1SC
# lyffUeMFIje7P01CG8PdPPcrggslA5dD3LujyWGSMiCCTsCg7fcKGaria40yYnVu
# Ejbd9W0YWbfFjqszzTIjKgSsepHZf5FCOJ9qf3V5hWP4o8RWk0nelzlCtrXCw4LZ
# YF72UegOP+/FPmnnEI1tmMbgPei01HR6DLjaq2N20e4QhR0aZuHbxUQSwd4oDq/s
# jGfNVtN0e7SY6mXG2DKkiHU1N272bSo4CTZZbceAsSESUBha08IaxXp7pQIDAQAB
# o0YwRDAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0O
# BBYEFGh6icZe5VHDFoO7nekOVqI5NnNKMA0GCSqGSIb3DQEBCwUAA4IBAQBvpNjC
# PlesnF99OHNhNSqy9WHxoRDtkGXukdOKufiUAS5lviYnW+jD9yL8wNwRLjMSdNwe
# mJO6Mie/773BZcQ3irOn7ZgDgLov2zAwWsR4YdUniT39IeP5ZGcxNDFzAx7Tu1LN
# ENVfbmJWwX9dl/qnKI3wOCPX9lJyY+LdRTreUjVjuBlD5sN585zzA0knUkk4siR6
# SdfiGkgipXULtiGJuXK6dqQZr/1TKyBY5coeXcjRWKj8K5L3wecn+lo18BysDzHk
# zM6Tyulw4Pyqvven/OBr9Gv4Vu5WTuFKGmuEjtBBXeFXSVYPIwEiJtmXz8I4AkJg
# NYsY9tasiX0fBD2wMYIBzjCCAcoCAQEwLTAZMRcwFQYDVQQDDA5QU0dDZXJ0aWZp
# Y2F0ZQIQfuUMOodC171JJFV/Av8OFDAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIB
# DDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEE
# AYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUie2mZsm+MoIE
# SzNs/4q+iRz4ZJUwDQYJKoZIhvcNAQEBBQAEggEAgeUuDofFXqQRnjRoK5nDSBvR
# 7YcPT+H5iBpuuTfSnf60JWGOASbjoz+YsmZMmjpVfNo0SHiGrB/FgpBREYJ+cdFG
# zmyuUyB96Dw5J8EB79fEKhxZ17tNibp+kNr9RhgRy+eed+jMFt9+1AOMA8kfsv6Y
# xD4oCjdsDPsReN+0BxBaJFIXpgFd43AgIRQtQbUMulgSvAlmfbI89sYUyhrsuB+9
# hhWCDKoJ7dy7P7/HLkA54sxJHDxzXjJauZqVWWunziEvQsm47IAtDXYSlCYDkJam
# lKbsxbzYH+U6/xvmhq59dJAgQ+v7X8k3MHOxkTDoyxbfNtvxt8xTojoULaTosg==
# SIG # End signature block
