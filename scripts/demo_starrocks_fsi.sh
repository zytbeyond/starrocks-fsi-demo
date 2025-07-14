#!/bin/bash
# Interactive StarRocks FSI Demo Script
# This script runs the StarRocks FSI demo with explanations and pauses for audience engagement

# Set colors for better visual presentation
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Function to display section headers
header() {
  echo -e "\n${BLUE}${BOLD}============================================================================${NC}"
  echo -e "${BLUE}${BOLD}$1${NC}"
  echo -e "${BLUE}${BOLD}============================================================================${NC}\n"
}

# Function to display feature highlights
feature() {
  echo -e "\n${ORANGE}${BOLD}★ KEY FEATURE: $1 ★${NC}\n"
  echo -e "${ORANGE}$2${NC}\n"
}

# Function to display explanations
explain() {
  echo -e "${YELLOW}${BOLD}$1${NC}\n"
}

# Function to display SQL commands
show_sql() {
  echo -e "${CYAN}${BOLD}SQL:${NC}"
  echo -e "${CYAN}$1${NC}\n"
}

# Function to display results
show_result() {
  echo -e "${GREEN}${BOLD}RESULT:${NC}\n"
}

# Function to pause for audience engagement
pause() {
  if [ "$1" ]; then
    sleep "$1"
  else
    sleep 2
  fi
}

# Function to wait for user to press Enter
wait_for_enter() {
  echo -e "${PURPLE}${BOLD}Press Enter to continue...${NC}"
  read
}

# Function to run SQL and display results
run_sql() {
  show_sql "$1"
  pause 1
  show_result
  mysql -h 127.0.0.1 -P 9030 -u root -e "$1" --table
  pause 2
}

# Check if StarRocks is running
check_starrocks() {
  if ! mysql -h 127.0.0.1 -P 9030 -u root -e "SELECT 1" &>/dev/null; then
    echo -e "${RED}${BOLD}ERROR: StarRocks is not running or not accessible.${NC}"
    echo -e "${RED}Please start StarRocks first with: ./run_starrocks_fsi_demo.sh${NC}"
    exit 1
  fi
}

# Main demo function
run_demo() {
  clear
  header "STARROCKS FINANCIAL SERVICES INDUSTRY DEMO"
  
  explain "Welcome to the StarRocks Financial Services Industry Demo. This demonstration will show how StarRocks enables real-time risk management for financial institutions."
  explain "We'll showcase the three key features that make StarRocks ideal for financial services:"
  explain "1. Primary Key Tables for real-time updates with high query performance"
  explain "2. Automatic Materialized Views (AutoMV) for intelligent query optimization"
  explain "3. Dual Materialized View Approach for balancing real-time consistency and complex analytics"
  wait_for_enter

  # Demo steps are implemented in the full version
  # This is a simplified version for GitHub
  explain "This is a simplified version of the demo script."
  explain "Please refer to the full documentation for detailed steps."
  
  header "DEMO COMPLETED"
  explain "Thank you for watching the StarRocks Financial Services Industry Demo."
}

# Check if StarRocks is running and run the demo
check_starrocks
run_demo
