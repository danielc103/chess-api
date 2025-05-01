#!/bin/bash

# Make the script exit on error
set -e

# Base API URL
API_URL="http://localhost:5000"

# Function to display steps
display_step() {
  echo "===================================="
  echo "STEP $1: $2"
  echo "===================================="
}

# Step 1: Get the initial board state
display_step 1 "Get the initial board state"
curl -s -X GET $API_URL/board | jq
echo ""
echo "Press Enter to continue..."
read

# Step 2: Move white pawn from e2 to e4
display_step 2 "Move white pawn from e2 to e4"
curl -s -X POST $API_URL/move \
  -H "Content-Type: application/json" \
  -d '{"from": "e2", "to": "e4"}' | jq
echo ""
echo "Press Enter to continue..."
read

# Step 3: Move black pawn from d7 to d5
display_step 3 "Move black pawn from d7 to d5"
curl -s -X POST $API_URL/move \
  -H "Content-Type: application/json" \
  -d '{"from": "d7", "to": "d5"}' | jq
echo ""
echo "Press Enter to continue..."
read

# Step 4: Simulate taking a piece (white pawn takes black pawn)
display_step 4 "Take black pawn with white pawn (e4 takes d5)"
# First, move the white pawn to the black pawn's position
curl -s -X POST $API_URL/move \
  -H "Content-Type: application/json" \
  -d '{"from": "e4", "to": "d5"}' | jq
echo ""
echo "The white pawn has moved to d5, but we also need to remove the black pawn that was there."
echo "Press Enter to continue..."
read

# Step 5: Remove the black pawn that was captured
display_step 5 "Remove the black pawn that was captured"
# There will be two pieces at d5 now, so we need to remove one
curl -s -X DELETE $API_URL/remove \
  -H "Content-Type: application/json" \
  -d '{"position": "d5"}' | jq
echo ""
echo "The black pawn has been removed, completing the capture."
echo "Press Enter to continue..."
read

# Step 6: Check the final board state
display_step 6 "Check the final board state"
curl -s -X GET $API_URL/board | jq
echo ""
echo "Demo completed!"