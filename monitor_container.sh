#!/bin/sh

# Output file
OUTPUT_FILE="ex_input_007_.log"

# Interval in seconds (0.05s = 50ms)
INTERVAL=0.05

# Print header
echo "Timestamp,CPU %,Memory Usage,Memory Limit" > "$OUTPUT_FILE"

# Loop until interrupted
while true; do
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S.%3N")
    
    # Get stats (no stream for single snapshot)
    docker stats --no-stream --format "{{.CPUPerc}},{{.MemUsage}}" stocktax-elixir-runner 2>/dev/null | \
    awk -v ts="$TIMESTAMP" -F '[ /]+' '{printf "%s,%s,%s,%s\n", ts, $1, $2, $4}' >> "$OUTPUT_FILE"
    
    sleep $INTERVAL
done
