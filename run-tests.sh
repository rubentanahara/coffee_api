#!/bin/bash

# Configuration
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
REPORTS_DIR="reports"
COLLECTION_FILE="coffee_api.postman_collection.json"
ENVIRONMENTS=("dev" "qa")
PORTS=("8000" "8001")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to log messages
log_message() {
    local level=$1
    local message=$2
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    case $level in
        "INFO")
            echo -e "${GREEN}[INFO]${NC} $timestamp - $message"
            ;;
        "WARNING")
            echo -e "${YELLOW}[WARNING]${NC} $timestamp - $message"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} $timestamp - $message"
            ;;
    esac
}

# Function to check if a port is in use
check_port() {
    local port=$1
    if lsof -i :$port > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Function to run tests for a specific environment
run_tests() {
    local env=$1
    local port=$2
    local env_file="coffee_api_${env}.postman_environment.json"
    local report_file="${REPORTS_DIR}/${env}_report_${TIMESTAMP}.html"
    
    log_message "INFO" "Starting tests for $env environment (Port: $port)"
    
    # Check if environment file exists
    if [ ! -f "$env_file" ]; then
        log_message "ERROR" "Environment file $env_file not found"
        return 1
    fi
    
    # Check if port is available
    if ! check_port $port; then
        log_message "WARNING" "Port $port is not in use. Make sure the API server is running."
    fi
    
    # Run Newman tests
    log_message "INFO" "Running Newman tests for $env environment..."
    newman run "$COLLECTION_FILE" \
        -e "$env_file" \
        -r cli,htmlextra \
        --reporter-htmlextra-export "$report_file" \
        --reporter-htmlextra-title "Coffee API Tests - $env Environment" \
        --reporter-htmlextra-darkTheme \
        --reporter-htmlextra-showMarkdownLinks \
        --reporter-htmlextra-timezone "UTC" \
        --verbose
    
    # Check if tests were successful
    if [ $? -eq 0 ]; then
        log_message "INFO" "Tests completed successfully for $env environment"
        log_message "INFO" "Report generated: $report_file"
    else
        log_message "ERROR" "Tests failed for $env environment"
    fi
}

# Create necessary directories
mkdir -p "$REPORTS_DIR" "$LOG_DIR"

# Check if Newman is installed
if ! command -v newman &> /dev/null; then
    log_message "ERROR" "Newman is not installed. Please install it using: npm install -g newman newman-reporter-htmlextra"
    exit 1
fi

# Check if collection file exists
if [ ! -f "$COLLECTION_FILE" ]; then
    log_message "ERROR" "Collection file $COLLECTION_FILE not found"
    exit 1
fi

# Main execution
log_message "INFO" "Starting test execution at $(date)"
log_message "INFO" "Test run ID: $TIMESTAMP"

# Run tests for each environment
for i in "${!ENVIRONMENTS[@]}"; do
    run_tests "${ENVIRONMENTS[$i]}" "${PORTS[$i]}"
done

# Summary
log_message "INFO" "Test execution completed at $(date)"
log_message "INFO" "Reports are available in the $REPORTS_DIR directory"
log_message "INFO" "Logs are available in the $LOG_DIR directory"

# Print summary of generated reports
echo -e "\n${GREEN}Test Reports Summary:${NC}"
for env in "${ENVIRONMENTS[@]}"; do
    echo -e "${YELLOW}$env Environment:${NC} $REPORTS_DIR/${env}_report_${TIMESTAMP}.html"
done