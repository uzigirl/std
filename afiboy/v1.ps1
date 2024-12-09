param (
    [string]$paramValue  # Define the parameter to accept input
)

# Check if the parameter was received
if ([string]::IsNullOrWhiteSpace($paramValue)) {
    Write-Host "Error: No parameter received!"
} else {
    Write-Host "Parameter received from parent script: $paramValue"

    # Example condition
    If ($paramValue -eq "nextValue") {
        Write-Host "Parameter matches the expected value."
    } else {
        Write-Host "Parameter does not match. Received: $paramValue"
    }
}
