package tax

import (
	"testing"
)

func TestCalculate(t *testing.T) {
	testCases := []struct {
		name       string
		operations []Operation
		expected   float64
	}{
		{
			name: "Case 1 - Sells under 20000 threshold",
			operations: []Operation{
				{Type: "buy", UnitCost: 10.00, Amount: 100},
				{Type: "sell", UnitCost: 15.00, Amount: 50},
				{Type: "sell", UnitCost: 15.00, Amount: 50},
			},
			expected: 0.0,
		},
		{
			name: "Case 2 - Profit and loss operations",
			operations: []Operation{
				{Type: "buy", UnitCost: 10.00, Amount: 10000},
				{Type: "sell", UnitCost: 20.00, Amount: 5000},
				{Type: "sell", UnitCost: 5.00, Amount: 5000},
			},
			expected: 7500.0,
		},
		{
			name: "Case 3 - Mixed profit and loss with tax",
			operations: []Operation{
				{Type: "buy", UnitCost: 100.00, Amount: 1000},
				{Type: "sell", UnitCost: 50.00, Amount: 500},
				{Type: "sell", UnitCost: 200.00, Amount: 300},
			},
			expected: 750.0,
		},
		{
			name: "Case 4 - Loss offsetting profit",
			operations: []Operation{
				{Type: "buy", UnitCost: 100.00, Amount: 1000},
				{Type: "buy", UnitCost: 250.00, Amount: 500},
				{Type: "sell", UnitCost: 150.00, Amount: 1000},
			},
			expected: 0.0,
		},
		{
			name: "Case 5 - Sequential operations with tax due",
			operations: []Operation{
				{Type: "buy", UnitCost: 100.00, Amount: 1000},
				{Type: "buy", UnitCost: 250.00, Amount: 500},
				{Type: "sell", UnitCost: 150.00, Amount: 1000},
				{Type: "sell", UnitCost: 250.00, Amount: 500},
			},
			expected: 7500.0,
		},
		{
			name: "Case 6 - Complex operations with losses and profits",
			operations: []Operation{
				{Type: "buy", UnitCost: 100.00, Amount: 1000},
				{Type: "sell", UnitCost: 20.00, Amount: 500},
				{Type: "sell", UnitCost: 200.00, Amount: 200},
				{Type: "sell", UnitCost: 200.00, Amount: 200},
				{Type: "sell", UnitCost: 250.00, Amount: 100},
			},
			expected: 2250.0,
		},
		{
			name: "Case 7 - Extended operations with multiple buys/sells",
			operations: []Operation{
				{Type: "buy", UnitCost: 100.00, Amount: 1000},
				{Type: "sell", UnitCost: 20.00, Amount: 500},
				{Type: "sell", UnitCost: 200.00, Amount: 200},
				{Type: "sell", UnitCost: 200.00, Amount: 200},
				{Type: "sell", UnitCost: 250.00, Amount: 100},
				{Type: "buy", UnitCost: 200.00, Amount: 1000},
				{Type: "sell", UnitCost: 150.00, Amount: 500},
				{Type: "sell", UnitCost: 300.00, Amount: 435},
				{Type: "sell", UnitCost: 300.00, Amount: 65},
			},
			expected: 5025.0,
		},
		{
			name: "Case 8 - High profit operations",
			operations: []Operation{
				{Type: "buy", UnitCost: 100.00, Amount: 1000},
				{Type: "sell", UnitCost: 500.00, Amount: 1000},
				{Type: "buy", UnitCost: 200.00, Amount: 1000},
				{Type: "sell", UnitCost: 500.00, Amount: 1000},
			},
			expected: 105000.0,
		},
		{
			name: "Case 9 - Mixed operations with various thresholds",
			operations: []Operation{
				{Type: "buy", UnitCost: 5000.00, Amount: 10},
				{Type: "sell", UnitCost: 4000.00, Amount: 5},
				{Type: "buy", UnitCost: 15000.00, Amount: 5},
				{Type: "buy", UnitCost: 4000.00, Amount: 2},
				{Type: "buy", UnitCost: 23000.00, Amount: 2},
				{Type: "sell", UnitCost: 20000.00, Amount: 1},
				{Type: "sell", UnitCost: 12000.00, Amount: 10},
				{Type: "sell", UnitCost: 15000.00, Amount: 3},
			},
			expected: 2550.0,
		},
		{
			name: "Case 10 - Examples from README",
			operations: []Operation{
				{Type: "buy", UnitCost: 10.00, Amount: 1000},
				{Type: "sell", UnitCost: 30.00, Amount: 500},
				{Type: "sell", UnitCost: 50.00, Amount: 420},
				{Type: "buy", UnitCost: 20.00, Amount: 420},
				{Type: "sell", UnitCost: 45.00, Amount: 500},
			},
			expected: 4515.0,
		},
		{
			name: "Original example from README",
			operations: []Operation{
				{Type: "buy", UnitCost: 10.00, Amount: 1000},
				{Type: "sell", UnitCost: 30.00, Amount: 500},
				{Type: "sell", UnitCost: 50.00, Amount: 420},
				{Type: "sell", UnitCost: 60.00, Amount: 80},
			},
			expected: 2520.0,
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			result := Calculate(tc.operations)
			if result != tc.expected {
				t.Errorf("Expected tax due to be %.2f, got %.2f", tc.expected, result)
			}
		})
	}
}
