# TinyCAD Library Update Script

$localPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$localActive = $localPath + "\Active"
$localInactive = $localPath + "\Inactive"

# prompt to include inactive
$excludeInactive = [System.Windows.Forms.MessageBox]::Show("Register Inactive libraries?", "TinyCAD Library Updater", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question, [System.Windows.Forms.MessageBoxDefaultButton]::Button2) -eq 7

$libs = ""
Get-ChildItem -Path $localPath -Include "*.TCLib" -File -Recurse |
    sort -Property "Name" | 
    foreach {
        if (-not ($excludeInactive -and $_.DirectoryName -match "inactive")) {
            $libs += $_.DirectoryName + "\" + [System.IO.Path]::GetFileNameWithoutExtension($_.Name) + ","
        }
	}
$libs = $libs.Remove($libs.Length-1, 1)

# set libraries
[Microsoft.Win32.Registry]::SetValue("HKEY_CURRENT_USER\Software\TinyCAD\TinyCAD\1x20", "Libraries", $libs, [Microsoft.Win32.RegistryValueKind]::String)
