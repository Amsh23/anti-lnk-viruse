# ============================
# Allow script execution (session only)
# ============================
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# ============================
# Disable AutoPlay / AutoRun (System-wide)
# Equivalent to:
# Turn off AutoPlay → All drives
# Set default behavior → Do not execute autorun commands
# ============================

Write-Host "Configuring system AutoPlay policies..."

# Ensure policy key exists
New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Explorer" -Force | Out-Null

# Turn off AutoPlay for all drives
Set-ItemProperty `
    -Path "HKLM:\Software\Policies\Microsoft\Windows\Explorer" `
    -Name "NoDriveTypeAutoRun" `
    -Value 255 `
    -Type DWord

# Disable Autorun commands
Set-ItemProperty `
    -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
    -Name "NoAutorun" `
    -Value 1 `
    -Type DWord

Write-Host "AutoPlay / AutoRun disabled successfully."





# Detect all removable drives
$usbDrives = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 }

if (!$usbDrives) {
    Write-Host "No USB drives detected."
    Read-Host "Press Enter to exit"
    exit
}

# Show all detected USB drives
Write-Host "Detected USB drives:"
$usbDrives | ForEach-Object { Write-Host " - $($_.DeviceID)\" }

# Ask user to select the target drive
$selectedDrive = Read-Host "Enter the drive letter of the USB you want to clean (e.g., E)"

# Validate selected drive
if (-not ($usbDrives.DeviceID -contains "${selectedDrive}:")) {
    Write-Host "Invalid drive or not a USB."
    Read-Host "Press Enter to exit"
    exit
}

$path = "${selectedDrive}:\"
Write-Host "`n=== Target USB: $path ==="

# =====================
# 1) Delete LNK files
# =====================
$lnkFiles = Get-ChildItem $path -Recurse -Force -ErrorAction SilentlyContinue |
            Where-Object { $_.Extension -ieq ".lnk" }

foreach ($file in $lnkFiles) {
    $ans = Read-Host "Delete LNK: $($file.FullName) ? (y/n)"
    if ($ans -eq 'y') {
        Remove-Item $file.FullName -Force
        Write-Host "Deleted."
    } else {
        Write-Host "Skipped."
    }
}

# =====================
# 2) Delete autorun.inf
# =====================
$autorun = "${path}autorun.inf"
if (Test-Path $autorun) {
    $ans = Read-Host "Delete autorun: $autorun ? (y/n)"
    if ($ans -eq 'y') {
        Remove-Item $autorun -Force
        Write-Host "Deleted."
    } else {
        Write-Host "Skipped."
    }
}

# =====================
# 3) Unhide all files
# =====================
$ans = Read-Host "Unhide ALL files in $path ? (y/n)"
if ($ans -eq 'y') {
    cmd /c "attrib -h -r -s `"$path*`" /s /d"
    Write-Host "Attributes restored."
} else {
    Write-Host "Skipped unhide."
}

Write-Host "`nDone. No action was taken without your confirmation."
Read-Host "Press Enter to exit"
