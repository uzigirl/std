# Define a parameter block to accept the input parameter
param (
    [string]$param  # The 'param' variable passed from the parent script
)

# Alternative way to get the parameter if not using param block
# $param = $args[0]

# Display the parameter value
Write-Host "Parameter received from parent script: $param"

# Example usage of the parameter
If ($param -eq "nextValue") {
    Write-Host "Parameter matches the expected value."
} else {
    Write-Host "Parameter does not match. Received: $param"
}
