#!/bin/sh

# Script to run Docker command 10 times and move log files
# Usage: ./go_resourse.sh

echo "Starting Go resource monitoring script..."

for i in $(seq 1 10); do
    # Format iteration number with leading zeros (001, 002, etc.)
    ITERATION=$(printf "%03d" $i)
    
    echo "Running iteration $ITERATION/010..."
    
    # Run the Docker command
    cat generator/inputs/008_transacoes_1000000.json | docker run --rm --name stocktax-go-runner --cpus="1.0" --memory="1024m" -i stocktax-go-modified
    
    # Check if the log file exists and move it
    if [ -f "go_input_008_.log" ]; then
        mv "go_input_008_.log" "resource_logs/go_input_008_execution_${ITERATION}.log"
        echo "Moved log file to resource_logs/go_input_008_execution_${ITERATION}.log"
    else
        echo "Warning: Log file go_input_008_.log not found for iteration $ITERATION"
    fi
    
    echo "Completed iteration $ITERATION"
    echo "---"
done

echo "All iterations completed!" 