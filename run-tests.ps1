# Configuration
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$ReportsDir = "reports"
$CollectionFile = "coffee_api.postman_collection.json"
$Environments = @("dev", "qa")
$Ports = @("8000", "8001")

# Function to log messages
function Write-LogMessage {
    param(
        [string]$Level,
        [string]$Message
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    switch ($Level) {
        "INFO" {
            Write-Host "[INFO] $timestamp - $Message" -ForegroundColor Green
        }
        "WARNING" {
            Write-Host "[WARNING] $timestamp - $Message" -ForegroundColor Yellow
        }
        "ERROR" {
            Write-Host "[ERROR] $timestamp - $Message" -ForegroundColor Red
        }
    }
}

# Function to check if a port is in use
function Test-PortInUse {
    param(
        [string]$Port
    )
    
    try {
        $listener = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Any, $Port)
        $listener.Start()
        $listener.Stop()
        return $false
    }
    catch {
        return $true
    }
}

# Function to run tests for a specific environment
function Invoke-EnvironmentTests {
    param(
        [string]$Environment,
        [string]$Port
    )
    
    $envFile = "coffee_api_${Environment}.postman_environment.json"
    $reportFile = "$ReportsDir\${Environment}_report_$Timestamp.html"
    
    Write-LogMessage -Level "INFO" -Message "Starting tests for $Environment environment (Port: $Port)"
    
    # Check if environment file exists
    if (-not (Test-Path $envFile)) {
        Write-LogMessage -Level "ERROR" -Message "Environment file $envFile not found"
        return $false
    }
    
    # Check if port is available
    if (-not (Test-PortInUse -Port $Port)) {
        Write-LogMessage -Level "WARNING" -Message "Port $Port is not in use. Make sure the API server is running."
    }
    
    # Run Newman tests
    Write-LogMessage -Level "INFO" -Message "Running Newman tests for $Environment environment..."
    
    try {
        $newmanArgs = @(
            "run", $CollectionFile,
            "-e", $envFile,
            "-r", "htmlextra",
            "--reporter-htmlextra-export", $reportFile,
            "--reporter-htmlextra-title", "Coffee API Tests - $Environment Environment",
            "--reporter-htmlextra-darkTheme",
            "--reporter-htmlextra-showMarkdownLinks",
            "--reporter-htmlextra-timezone", "UTC"
        )
        
        $result = newman $newmanArgs
        
        if ($LASTEXITCODE -eq 0) {
            Write-LogMessage -Level "INFO" -Message "Tests completed successfully for $Environment environment"
            Write-LogMessage -Level "INFO" -Message "Report generated: $reportFile"
            return $true
        }
        else {
            Write-LogMessage -Level "ERROR" -Message "Tests failed for $Environment environment"
            return $false
        }
    }
    catch {
        Write-LogMessage -Level "ERROR" -Message "Error running tests: $_"
        return $false
    }
}

# Create necessary directories
New-Item -ItemType Directory -Force -Path $ReportsDir | Out-Null
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

# Check if Newman is installed
if (-not (Get-Command newman -ErrorAction SilentlyContinue)) {
    Write-LogMessage -Level "ERROR" -Message "Newman is not installed. Please install it using: npm install -g newman newman-reporter-htmlextra"
    exit 1
}

# Check if collection file exists
if (-not (Test-Path $CollectionFile)) {
    Write-LogMessage -Level "ERROR" -Message "Collection file $CollectionFile not found"
    exit 1
}

# Main execution
Write-LogMessage -Level "INFO" -Message "Starting test execution at $(Get-Date)"
Write-LogMessage -Level "INFO" -Message "Test run ID: $Timestamp"

# Run tests for each environment
$success = $true
for ($i = 0; $i -lt $Environments.Count; $i++) {
    $envSuccess = Invoke-EnvironmentTests -Environment $Environments[$i] -Port $Ports[$i]
    $success = $success -and $envSuccess
}

# Summary
Write-LogMessage -Level "INFO" -Message "Test execution completed at $(Get-Date)"
Write-LogMessage -Level "INFO" -Message "Reports are available in the $ReportsDir directory"
Write-LogMessage -Level "INFO" -Message "Logs are available in the $LogDir directory"

# Print summary of generated reports
Write-Host "`nTest Reports Summary:" -ForegroundColor Green
foreach ($env in $Environments) {
    Write-Host "$env Environment: $ReportsDir\${env}_report_$Timestamp.html" -ForegroundColor Yellow
}

# Set exit code based on test results
if (-not $success) {
    exit 1
} 