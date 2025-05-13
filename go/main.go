package main

import (
	"encoding/json"
	"fmt"
	"io"
	"os"

	"stocktax/tax"
)

func main() {
	// Read input from stdin
	data, err := io.ReadAll(os.Stdin)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading input: %v\n", err)
		os.Exit(1)
	}

	var operations []tax.Operation
	if err := json.Unmarshal(data, &operations); err != nil {
		fmt.Fprintf(os.Stderr, "Error parsing JSON: %v\n", err)
		os.Exit(1)
	}

	taxDue := tax.Calculate(operations)

	// Output the result
	result, err := json.Marshal(taxDue)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error formatting output: %v\n", err)
		os.Exit(1)
	}

	fmt.Println(string(result))
}
