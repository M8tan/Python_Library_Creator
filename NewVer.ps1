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
$Main_Form_Create_Button.Location = New-Object System.Drawing.Point(60,350)
$Main_Form_Create_Button.Size = New-Object System.Drawing.Size(110,80)
$Main_Form.Controls.Add($Main_Form_Create_Button)

$Main_Form_Build_Button = New-Object System.Windows.Forms.Button
$Main_Form_Build_Button.Text = "Build"
$Main_Form_Build_Button.Font = New-Object System.Drawing.Font("arial", 14)
$Main_Form_Build_Button.Location = New-Object System.Drawing.Point(190,350)
$Main_Form_Build_Button.Size = New-Object System.Drawing.Size(110,80)
$Main_Form.Controls.Add($Main_Form_Build_Button)

$Main_Form_EditableBuild_Button = New-Object System.Windows.Forms.Button
$Main_Form_EditableBuild_Button.Text = "Editable build"
$Main_Form_EditableBuild_Button.Font = New-Object System.Drawing.Font("arial", 14)
$Main_Form_EditableBuild_Button.Location = New-Object System.Drawing.Point(320,350)
$Main_Form_EditableBuild_Button.Size = New-Object System.Drawing.Size(110,80)
$Main_Form.Controls.Add($Main_Form_EditableBuild_Button)

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

function Test-TOMLVersion($Search_Path){
    
    $WHLFile = Get-Item -Path "$Location\dist\*.whl" -ErrorAction SilentlyContinue

    if (-not $WHLFile) {
        Write-Host "No .whl file found. Skipping version check."
        return
    }

    $WHLName = $WHLFile.Name

    
    if ($WHLName -match '.*-(\d+\.\d+\.\d+).*\.whl') {
        $whlVersion = $matches[1]
    } else {
        Write-Host "Could not extract version from wheel filename."
        return
    }

    
    $TOML_Content = Get-Content -Path "$Location\pyproject.toml" | Select-String -Pattern 'version\s*=\s*".*?"'

    if ($TOML_Content -match 'version\s*=\s*"(.*?)"') {
        $tomlVersion = $matches[1]
    } else {
        Write-Host "No version found in pyproject.toml"
        return
    }

    
    $tomlParts = $tomlVersion -split '\.' | ForEach-Object {[int]$_}
    $whlParts = $whlVersion -split '\.' | ForEach-Object {[int]$_}

    
    $updateNeeded = $false
    for ($i = 0; $i -lt 3; $i++) {
        if ($tomlParts[$i] -gt $whlParts[$i]) {
           
            Write-Host "TOML version $tomlVersion is higher than wheel $whlVersion"
            return
        } elseif ($tomlParts[$i] -lt $whlParts[$i]) {
            $updateNeeded = $true
            break
        }
    }

    if ($updateNeeded) {
        $newVersion = "$($whlParts[0]).$($whlParts[1]).$($whlParts[2] + 1)"
        
        (Get-Content "$Location\pyproject.toml") -replace 'version\s*=\s*".*?"', "version = `"$newVersion`"" |
            Set-Content "$Location\pyproject.toml"

        Write-Host "Updated pyproject.toml to version $newVersion"
    } else {
        Write-Host "TOML version $tomlVersion is equal to wheel $whlVersion. Incrementing patch."
        $newVersion = "$($tomlParts[0]).$($tomlParts[1]).$($tomlParts[2] + 1)"
        
        (Get-Content "$Location\pyproject.toml") -replace 'version\s*=\s*".*?"', "version = `"$newVersion`"" |
            Set-Content "$Location\pyproject.toml"

        Write-Host "Updated pyproject.toml to version $newVersion"
    }
}

$Main_Form_Help_Button.add_click({
([System.Windows.Forms.MessageBox]::Show("*** If you want to create a brand new library - enter the directory in which you want to generate the library structure {e.g - c:\Projects\Python}, the name you chose for the library {e.g - mystringformatter}, a short description {e.g - a library to format strings in python} and press create. Then, you can go to the new directory {e.g - c:\Projects\Python\mystringformatter\mystringformatter} and open the library file {e.g - mystringformatter.py}, edit it and continue in your way. *** If you already have a structured library and want to make it an actually installable and importable library - enter the root path {e.g - c:\Projects\Python\mystringformatter} and press build. Notice - it requires the python 'build' library. We will try to install it using pip, if not installed already. *** If you want to create an editable build {for development stages} fill in the root directory and press Editable build. It will install the library, you can also continue and re-build it in the future. Then, when it's ready, perform the actual Build process and use it as needed.", "Guide", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information))

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
Test-TOMLVersion -Search_Path $Library_Location
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

$Main_Form_EditableBuild_Button.add_click({
$Library_Location = $Main_Form_Location_TB.Text


if($Library_Location -notlike $null){
$Library_Location_Exists = Test-Path $Library_Location
if($Library_Location_Exists){
$Found_TOML = Search-TOML -Search_Path $Library_Location
if($Found_TOML){
try{
Test-TOMLVersion -Search_Path $Library_Location
Remove-Item -Path "$Library_Location\dist" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$Library_Location\*.egg-info" -Recurse -Force -ErrorAction SilentlyContinue
pip install -e $Library_Location
([System.Windows.Forms.MessageBox]::Show("Installed the library $Library_Location in an editable way", "Done", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information))
} catch {
([System.Windows.Forms.MessageBox]::Show("Unknown error", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
}
} else {
([System.Windows.Forms.MessageBox]::Show("Path not found - pyproject.toml not in $Library_Location", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
}
} else {
([System.Windows.Forms.MessageBox]::Show("Path not found", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error))
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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUatfqteMLu0dzau+Wf7Z4Rjui
# gXygggMGMIIDAjCCAeqgAwIBAgIQM67VkxDWtqZAEpivZmVUGTANBgkqhkiG9w0B
# AQsFADAZMRcwFQYDVQQDDA5QU0dDZXJ0aWZpY2F0ZTAeFw0yNTEwMjYxMjAxMTZa
# Fw0yNjEwMjYxMjIxMTZaMBkxFzAVBgNVBAMMDlBTR0NlcnRpZmljYXRlMIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2CjTn+2/CAWUf5zKnx9SVPypXn0s
# +AyIV5lxvT0h6haWA/1QODeVyBpo0wc/sjqEIZeKPuRJOWzbw3px94gxqqXgeZly
# 3vrbsr+EQEtVdLysevblrQOnmOgw2a3wvbrFMCWYbdyxvTjRzi8bVFUszdRGBnAx
# 3YDCQA+fp2Mmtzln813LTvGmwRw9VE4rC0gkIuQ2uceAdnkIklu5VM0V2lq04/SC
# LMSw5uX5ELRFFzC+LNZYMnxEd+JOSl0g0bpmBw+Jl/0JupLz6lB0Mq3wMB4Xv9ja
# 0qP6oP9F/AcW8DdTzLQh+qOr6i256Bm+rLxjdUZnqjJpm6apDZOabLQLmQIDAQAB
# o0YwRDAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0O
# BBYEFB1+7mJ3/kX8gWF5y+QxA/aFyh8HMA0GCSqGSIb3DQEBCwUAA4IBAQCEr5yE
# dSFlpdLjjLsV2GtBlLHaDA0t+b2RHUa+LweR1iaGE1E/CpS2fZyQDZxPPT2rgk+L
# 1zkl8hiCQh5bf2P6gYBv/LKi8mshpaQv6TkcSZwcBeNZwJ6GPnBXYxPGoXasZ3j4
# GB94k4mXvQzz68xw50Qz7PNrijINuCBnIQO4SCe4Jb46mDHzW7m95Q7VTj1Lwkle
# GfCA/SMWHTtogVbbr2EbeibTgHW9PnpWxrrug/pCccuyEMKHGwPlxP6G0KlKS41u
# HSSWH2+OwOJrl21DZmOO0p0+/5HcHJcC/KAoq8GMU87ImmIOfPYCwmGAZG0reJHm
# eAOy3eBd2wng/Ld0MYIBzjCCAcoCAQEwLTAZMRcwFQYDVQQDDA5QU0dDZXJ0aWZp
# Y2F0ZQIQM67VkxDWtqZAEpivZmVUGTAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIB
# DDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEE
# AYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUf1gbMd/datW4
# 0xGZbHzfnm24BVkwDQYJKoZIhvcNAQEBBQAEggEAWkG3BpMlTLTjw/VCS5f7vbnb
# HPn3PWi9OAu2eSrwcXUk4hB4uTa9P23G4TdXtK+xTI0XwO//j2n55mWb+oE6C09i
# m+ENZn+8zSCxXhmwgcEkR5deUy/xqJlMJB1dueINL3+PmfCeScpwXeLx4Y5gRgz2
# oRo7sVVH7nppWlOrmiAxHcuxxKD1qwVzdbDtK+YG8Gs7gSB4QbMRkAZFyJ4YUEZ+
# VeGvLNK3q3hvaHTbv841a4B5T/hOnApSSp6J/uyiXR8xG6Lju7dic1oVah9DGEuy
# vDT0sgs5NrHH3wWsl76warWb/K4y6K+t76EeefmnZbtUmAGuc5FwR8kcV2H55g==
# SIG # End signature block
