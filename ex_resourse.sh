#!/bin/sh

# Script to run Docker command 10 times and move log files
# Usage: ./ex_resourse.sh

echo "Starting Elixir resource monitoring script..."

for i in $(seq 1 10); do
    # Format iteration number with leading zeros (001, 002, etc.)
    ITERATION=$(printf "%03d" $i)
    
    echo "Running iteration $ITERATION/010..."
    
    # Run the Docker command
    cat generator/inputs/007_transacoes_1000000.json | docker run --rm --name stocktax-elixir-runner --cpus="1.0" --memory="1024m" -i stocktax-elixir-modified
    
    # Check if the log file exists and move it
    if [ -f "ex_input_007_.log" ]; then
        mv "ex_input_007_.log" "resource_logs/ex_input_007_execution_${ITERATION}.log"
        echo "Moved log file to resource_logs/ex_input_007_execution_${ITERATION}.log"
    else
        echo "Warning: Log file ex_input_007_.log not found for iteration $ITERATION"
    fi
    
    echo "Completed iteration $ITERATION"
    echo "---"
done

echo "All iterations completed!" 