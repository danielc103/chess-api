#!/bin/bash

# Make the script exit on error
set -e

API_URL="http://localhost:5000"

display_step() {
  echo "===================================="
  echo "STEP $1: $2"
  echo "===================================="
}

echo "===================================="
echo "Welcome to the Chess API Demo!"
echo "Where chess dreams come true, if you don't know how to play chess."
echo "===================================="

display_step 1 "Get the initial board state"
curl -s -X GET $API_URL/board | jq
echo ""
echo "Press Enter to continue..."
read

display_step 2 "Move white pawn from e2 to e4"
curl -s -X POST $API_URL/move \
  -H "Content-Type: application/json" \
  -d '{"from": "e2", "to": "e4"}' | jq
echo ""
echo "Press Enter to continue..."
read

display_step 3 "Move black pawn from d7 to d5"
curl -s -X POST $API_URL/move \
  -H "Content-Type: application/json" \
  -d '{"from": "d7", "to": "d5"}' | jq
echo ""
echo "Press Enter to continue..."
read

display_step 4 "Take black pawn with white pawn (e4 takes d5)"
# First, move the white pawn to the black pawn's position
curl -s -X POST $API_URL/move \
  -H "Content-Type: application/json" \
  -d '{"from": "e4", "to": "d5"}' | jq
echo ""
echo "The white pawn was moved to d5, remove the black pawn that was there."
echo "Press Enter to continue..."
read

display_step 5 "Remove the black pawn that was captured"
# There will be two pieces at d5 now, so we need to remove one
curl -s -X DELETE $API_URL/remove \
  -H "Content-Type: application/json" \
  -d '{"position": "d5"}' | jq
echo ""
echo "The black pawn has been captured."
echo "Press Enter to continue..."
read

display_step 6 "Get the final board state"
curl -s -X GET $API_URL/board | jq
echo ""
echo "Demo completed...profit."