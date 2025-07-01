#!/usr/bin/env bash

# This script fetches the 24h percent change for BTC/USD from Gemini API
# and updates the label for "eth" (or whichever item) in sketchybar.

# Fetch the pricefeed JSON
response=$(curl -s 'https://api.gemini.com/v1/pricefeed')

# Extract the percentChange24h for BTCUSD and multiply by 100
# We use jq to filter the pair and output the raw 24h change, then bc for arithmetic
raw_change=$(echo "$response" | jq -r '.[] | select(.pair == "ETHUSD") | .percentChange24h')

# Calculate percentage and format to 2 decimal places
percent_change=$(printf "%.2f" "$(echo "$raw_change * 100" | bc -l)")

# Update sketchybar item (here labeled "eth") with the percentage change
sketchybar -m --set $NAME label="${percent_change}%"
