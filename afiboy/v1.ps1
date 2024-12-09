param (
    [string]$param  # Define parameter block to accept input
)

# Check if the parameter is passed correctly
if ([string]::IsNullOrWhiteSpace($param)) {
    Write-Host "Error: No parameter received!"
} else {
    Write-Host "Parameter received from parent script: $param"

    # Example usage of the parameter
    If ($param -eq "nextValue") {
        Write-Host "Parameter matches the expected value."
    } else {
        Write-Host "Parameter does not match. Received: $param"
    }
}
