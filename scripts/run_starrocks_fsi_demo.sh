#!/bin/bash
# Run script for StarRocks FSI Demo
# This script automates the setup and execution of the StarRocks FSI Demo

# Exit on error
set -e

# Set script directory and output directory for logs
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")" 
mkdir -p "$SCRIPT_DIR/../output"

# Function to log messages
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$SCRIPT_DIR/../output/fsi_demo.log"
}

# Check if Docker is installed
check_docker() {
  log "Checking if Docker is installed..."
  if ! command -v docker &> /dev/null; then
    log "Docker is not installed. Please install Docker first."
    exit 1
  fi
  log "Docker is installed."
}

# Check if StarRocks container is running
check_starrocks() {
  log "Checking if StarRocks container is running..."
  if docker ps | grep -q starrocks; then
    log "StarRocks container is running."
    return 0
  else
    log "StarRocks container is not running."
    return 1
  fi
}

# Start StarRocks container if not running
start_starrocks() {
  if ! check_starrocks; then
    log "Starting StarRocks container..."
    
    # Check if container exists but is stopped
    if docker ps -a | grep -q starrocks; then
      docker start starrocks
      log "StarRocks container started."
    else
      # Pull and run container
      log "Pulling StarRocks container image..."
      docker pull starrocks/allin1-ubuntu
      log "Running StarRocks container..."
      docker run -d --name starrocks -p 9030:9030 -p 8030:8030 starrocks/allin1-ubuntu
      log "StarRocks container pulled and started."
    fi
    
    # Wait for StarRocks to be ready
    log "Waiting for StarRocks to be ready..."
    sleep 30
  fi
}

# Install MySQL client
install_mysql_client() {
  log "Checking if MySQL client is installed..."
  
  # Check if MySQL client is installed
  if ! command -v mysql &> /dev/null; then
    # Install MySQL client
    log "Installing MySQL client..."
    sudo apt-get update
    sudo apt-get install -y mysql-client
    log "MySQL client installed."
  else
    log "MySQL client is already installed."
  fi
}

# Run the FSI demo SQL script
run_demo() {
  log "Running the FSI demo SQL script..."
  
  # Create a temporary SQL file with the database creation and use statements
  TEMP_SQL="$SCRIPT_DIR/temp_setup.sql"
  cat > "$TEMP_SQL" << EOF
DROP DATABASE IF EXISTS globalbank;
CREATE DATABASE globalbank;
USE globalbank;
EOF

  # Run the setup SQL
  log "Setting up the globalbank database..."
  mysql -h 127.0.0.1 -P 9030 -u root < "$TEMP_SQL"
  
  # Run the demo SQL script
  log "Running the main demo script..."
  mysql -h 127.0.0.1 -P 9030 -u root < "$SCRIPT_DIR/../sql/starrocks_fsi_demo.sql"
  
  # Clean up
  rm "$TEMP_SQL"
  
  log "Demo SQL script executed successfully."
}

# Show demo instructions
show_instructions() {
  echo ""
  echo "============================================================"
  echo "StarRocks FSI Demo Setup Complete"
  echo "============================================================"
  echo ""
  echo "The demo environment is now ready. To present the demo:"
  echo ""
  echo "1. Review the demo storyline:"
  echo "   less \"$SCRIPT_DIR/../docs/DEMO_STORYLINE.md\""
  echo ""
  echo "2. Run the interactive demo script:"
  echo "   $SCRIPT_DIR/demo_starrocks_fsi.sh"
  echo ""
  echo "3. Connect to StarRocks to run demo queries manually:"
  echo "   mysql -h 127.0.0.1 -P 9030 -u root"
  echo ""
  echo "4. When connected, use the globalbank database:"
  echo "   USE globalbank;"
  echo ""
  echo "5. Run queries from the starrocks_fsi_demo.sql file as needed"
  echo "   during your presentation"
  echo ""
  echo "============================================================"
}

# Main function
main() {
  log "Starting StarRocks FSI Demo setup..."
  
  # Run setup steps
  check_docker
  start_starrocks
  install_mysql_client
  run_demo
  
  log "StarRocks FSI Demo setup completed."
  show_instructions
}

# Run main function
main