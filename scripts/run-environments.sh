#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Icons
CHECK_MARK="✓"
CROSS_MARK="✗"
ARROW="➜"
INFO="ℹ"
WARNING="⚠"
ROCKET="🚀"
DATABASE="💾"
API="🌐"
STOP="🛑"

# Function to print status
print_status() {
    echo -e "${BLUE}${INFO} $1${NC}"
}

print_success() {
    echo -e "${GREEN}${CHECK_MARK} $1${NC}"
}

print_error() {
    echo -e "${RED}${CROSS_MARK} $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}${WARNING} $1${NC}"
}

# Function to cleanup on exit
cleanup() {
    echo -e "\n${YELLOW}${STOP} Stopping all containers...${NC}"
    docker-compose -f docker-compose.dev.yml down
    docker-compose -f docker-compose.qa.yml down
    print_success "All environments stopped successfully"
    exit 0
}

# Set up trap for cleanup
trap cleanup SIGINT SIGTERM

# Clear screen
clear

# Print header
echo -e "${BLUE}${ROCKET} Coffee API Environment Manager${NC}"
echo -e "${BLUE}=====================================${NC}\n"

# Start development environment
print_status "Starting development environment..."
docker-compose -f docker-compose.dev.yml up -d
if [ $? -eq 0 ]; then
    print_success "Development environment started successfully"
else
    print_error "Failed to start development environment"
    exit 1
fi

# Start QA environment
print_status "Starting QA environment..."
docker-compose -f docker-compose.qa.yml up -d
if [ $? -eq 0 ]; then
    print_success "QA environment started successfully"
else
    print_error "Failed to start QA environment"
    exit 1
fi

# Print environment information
echo -e "\n${GREEN}${CHECK_MARK} Both environments are running!${NC}\n"
echo -e "${BLUE}${API} API Endpoints:${NC}"
echo -e "  ${ARROW} Development: ${GREEN}http://localhost:8000${NC}"
echo -e "  ${ARROW} QA:         ${GREEN}http://localhost:8001${NC}\n"

echo -e "${BLUE}${DATABASE} MongoDB Connections:${NC}"
echo -e "  ${ARROW} Development: ${GREEN}mongodb://localhost:27017/coffee_db_dev${NC}"
echo -e "  ${ARROW} QA:         ${GREEN}mongodb://localhost:27018/coffee_db_qa${NC}\n"

echo -e "${YELLOW}${WARNING} Press Ctrl+C to stop all environments${NC}"

# Keep script running
while true; do
    sleep 1
done 
