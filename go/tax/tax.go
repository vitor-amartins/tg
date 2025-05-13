// Package tax provides functionality for calculating income tax on stock operations
package tax

import "math"

// Operation represents a stock operation (buy or sell)
type Operation struct {
	Type     string  `json:"type"`
	UnitCost float64 `json:"unitCost"`
	Amount   int     `json:"amount"`
}

// Portfolio keeps track of the current stock position and tax information
type Portfolio struct {
	StockAmount       int
	AverageCost       float64
	AccumulatedLoss   float64
	AccumulatedTaxDue float64
}

// Constants for tax calculation
const (
	TaxRate        = 0.15  // 15% tax rate
	TaxThreshold   = 20000 // R$ 20,000 threshold for tax exemption
	RoundPrecision = 100   // For rounding to 2 decimal places
)

// Calculate processes a list of operations and returns the tax due
func Calculate(operations []Operation) float64 {
	portfolio := Portfolio{}

	for _, op := range operations {
		switch op.Type {
		case "buy":
			processBuy(&portfolio, op)
		case "sell":
			processSell(&portfolio, op)
		}
	}

	return math.Round(portfolio.AccumulatedTaxDue*RoundPrecision) / RoundPrecision
}

// processBuy updates the average cost of stocks in the portfolio
func processBuy(p *Portfolio, op Operation) {
	// If we don't have any stocks, simply set the cost and amount
	if p.StockAmount == 0 {
		p.AverageCost = op.UnitCost
		p.StockAmount = op.Amount
		return
	}

	// Calculate weighted average cost
	totalValue := float64(p.StockAmount)*p.AverageCost + float64(op.Amount)*op.UnitCost
	totalAmount := p.StockAmount + op.Amount
	p.AverageCost = totalValue / float64(totalAmount)
	p.StockAmount = totalAmount
}

// processSell calculates profit/loss and tax for sell operations
func processSell(p *Portfolio, op Operation) {
	sellAmount := op.Amount
	sellPrice := op.UnitCost
	sellValue := sellPrice * float64(sellAmount)
	costBasis := p.AverageCost * float64(sellAmount)

	// Calculate profit/loss for this operation
	profit := sellValue - costBasis

	// Update the stock amount
	p.StockAmount -= sellAmount

	// No tax if sell value is below the threshold
	if sellValue <= TaxThreshold {
		// But still need to track losses for future offset
		if profit < 0 {
			p.AccumulatedLoss += math.Abs(profit)
		}
		return
	}

	// For sells with value > threshold
	if profit <= 0 {
		// No tax on losses, just accumulate the loss
		p.AccumulatedLoss += math.Abs(profit)
		return
	}

	// We have a profit with sell value > threshold

	// Use accumulated losses to offset if available
	if p.AccumulatedLoss > 0 {
		if p.AccumulatedLoss >= profit {
			// Completely offset the profit
			p.AccumulatedLoss -= profit
			return
		}

		// Partially offset the profit
		profit -= p.AccumulatedLoss
		p.AccumulatedLoss = 0
	}

	// Calculate tax at specified rate on remaining profit
	tax := profit * TaxRate
	p.AccumulatedTaxDue += tax
}
