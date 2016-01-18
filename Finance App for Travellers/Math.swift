//
//  Math.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 06/01/16.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation

class Math: NSObject {
	var transactions: [Transaction]
	var homeCurrency: Currency
	var currentPeriod: Period
	
	init(transactions: [Transaction], homeCurrency: Currency, currentPeriod: Period) {
		self.transactions = transactions

		self.homeCurrency = homeCurrency
		self.currentPeriod = currentPeriod
	}
	
	
	lazy var expenses: [Transaction] = {
		return self.transactions.filter {
			(x : Transaction) -> Bool in
			if x.amount.compare(NSDecimalNumber.zero()) == NSComparisonResult.OrderedAscending {
				return true
			}
			return false
		}
	}()
	
	
	lazy var expensesTotal:NSDecimalNumber = {
		return self.expenses.reduce(0, combine: {return $1.getStaticValueInCurrency(self.homeCurrency).amount.decimalNumberByAdding($0)}).abs()
	}()
	
	
	lazy var expensesAvg:NSDecimalNumber = {
		return self.expenses.count > 0 ? self.expensesTotal.decimalNumberByDividingBy(NSDecimalNumber(integer: self.currentPeriod.getDaysLeft())) : NSDecimalNumber(integer: 0)
	}()
	
	
	lazy var expensesProjected:NSDecimalNumber = {
		return self.expensesAvg.decimalNumberByMultiplyingBy(NSDecimalNumber(integer: self.currentPeriod.getDaysCount()))
	}()
	
	
	lazy var expensesMaxTransaction:Transaction? = {
		return self.expenses.maxElement({(a: Transaction, b:Transaction) in
			return a.amount.compare(b.amount) == NSComparisonResult.OrderedDescending
		})
	}()
	
	
	lazy var earnings: [Transaction] = {
		return self.transactions.filter {
			(x : Transaction) -> Bool in
			if x.amount.compare(NSDecimalNumber.zero()) == NSComparisonResult.OrderedDescending {
				return true
			}
			return false
		}
	}()
	
	
	lazy var earningsTotal:NSDecimalNumber = {
		return self.earnings.reduce(0, combine: {return $1.getStaticValueInCurrency(self.homeCurrency).amount.decimalNumberByAdding($0)})
	}()
	
	
	lazy var earningsAvg:NSDecimalNumber = {
		return self.earnings.count > 0 ? self.earningsTotal.decimalNumberByDividingBy(NSDecimalNumber(integer: self.currentPeriod.getDaysLeft())) : NSDecimalNumber(integer: 0)
	}()
}