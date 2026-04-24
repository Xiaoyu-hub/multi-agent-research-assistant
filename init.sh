#!/bin/bash

# =============================================================================
# init.sh - Multi-Agent Research Assistant Initialization
# =============================================================================
# Run this script at the start of every session to ensure the environment
# is properly set up and the FastAPI server is running.
# =============================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Initializing Multi-Agent Research Assistant...${NC}"

# Check Python version
python_version=$(python3 --version 2>&1 | awk '{print $2}')
echo "Python version: $python_version"

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install dependencies if needed
if [ ! -f "venv/.installed" ]; then
    echo "Installing dependencies..."
    pip install -r requirements.txt
    touch venv/.installed
else
    echo "Dependencies already installed"
fi

# Check .env file
if [ ! -f ".env" ]; then
    echo -e "${RED}Warning: .env file not found${NC}"
    echo "Creating from template..."
    cp .env.example .env 2>/dev/null || echo "Please create .env with required API keys"
fi

# Check for required API keys
if grep -q "your_api_key_here" .env 2>/dev/null; then
    echo -e "${RED}Warning: Please update .env with real API keys${NC}"
fi

# Kill existing server on port 8000 if any
if lsof -ti:8000 >/dev/null 2>&1; then
    echo "Stopping existing server on port 8000..."
    kill $(lsof -ti:8000) 2>/dev/null || true
    sleep 1
fi

# Start FastAPI server in background
echo "Starting FastAPI server..."
python -m uvicorn src.app:app --host 0.0.0.0 --port 8000 --reload &
SERVER_PID=$!

# Wait for server to be ready
echo "Waiting for server to start..."
max_attempts=15
attempt=0
while [ $attempt -lt $max_attempts ]; do
    if curl -s http://localhost:8000/api/v1/health >/dev/null 2>&1; then
        break
    fi
    attempt=$((attempt + 1))
    sleep 1
    echo -n "."
done

echo ""

if [ $attempt -eq $max_attempts ]; then
    echo -e "${RED}✗ Server failed to start${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Initialization complete!${NC}"
echo -e "${GREEN}✓ FastAPI server running at http://localhost:8000 (PID: $SERVER_PID)${NC}"
echo -e "${GREEN}✓ API docs available at http://localhost:8000/docs${NC}"
echo ""
echo "Ready to continue development."