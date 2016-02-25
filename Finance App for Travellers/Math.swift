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

	lazy var expensesToday:NSDecimalNumber = {
		var dayHash:String = NSDate().formatToHash()
		guard self.dailyAmounts(self.expenses)[dayHash] != nil else {
			return 0
		}
		return self.dailyAmounts(self.expenses)[dayHash]!
	}()
	
	lazy var expensesAvg:NSDecimalNumber = {
		return self.expenses.count > 0 ? self.expensesTotal.decimalNumberByDividingBy(NSDecimalNumber(integer: self.currentPeriod.getDaysLeft())) : NSDecimalNumber(integer: 0)
	}()
	
	lazy var expensesMean:NSDecimalNumber = {
		return self.median(self.expenses)
	}()
	
	
	lazy var expensesProjected:NSDecimalNumber = {
		return self.expensesAvg.decimalNumberByMultiplyingBy(NSDecimalNumber(integer: self.currentPeriod.getDaysCount()))
	}()
	
	
	lazy var expensesMaxTransaction:Transaction? = {
		return self.expenses.maxElement({(a: Transaction, b:Transaction) in
			return a.amount.compare(b.amount) == NSComparisonResult.OrderedDescending
		})
	}()
	
	lazy var expenseCategories: [Category] = {
		var categories: [Category] = []
		for trn:Transaction in self.expenses {
			if trn.category != nil && categories.contains(trn.category!) != true {
				categories.append(trn.category!)
			}
		}
		categories.sortInPlace { self.getCategoryAmountForPeriod($0).compare(self.getCategoryAmountForPeriod($1)) == NSComparisonResult.OrderedAscending }
		return categories
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
	
	
	lazy var earningCategories: [Category] = {
		var categories: [Category] = []
		for trn:Transaction in self.earnings {
			if trn.category != nil && categories.contains(trn.category!) != true {
				categories.append(trn.category!)
			}
		}
		categories.sortInPlace { self.getCategoryAmountForPeriod($0).compare(self.getCategoryAmountForPeriod($1)) == NSComparisonResult.OrderedAscending }
		return categories
	}()

	
	func getCategoryAmountForPeriod(category: Category) -> NSDecimalNumber {
		var amount = NSDecimalNumber(integer: 0)
		for elem: Transaction in transactions {
			if elem.category == category {
				amount = amount.decimalNumberByAdding(elem.getStaticValueInCurrency(self.homeCurrency).amount)
			}
		}
		return amount
	}
	
	func getTransactionsForCategoryAndPeriod(category: Category) -> [Transaction] {
		return transactions.filter {
			(x : Transaction) -> Bool in
			return x.category == category
		}
	}
	
	func median(values: [Transaction]) -> NSDecimalNumber {
		let sorted = dailyAmounts(values).map {$1} .sort { $0.compare($1) == NSComparisonResult.OrderedAscending }
		let count = Double(sorted.count)
		if count == 0 { return 0 }

		if count % 2 == 0 {
			// Even number of items - return the mean of two middle values
			let leftIndex = Int(count / 2 - 1)
			let leftValue = sorted[leftIndex]
			let rightValue = sorted[leftIndex + 1]
			return leftValue.decimalNumberByAdding(rightValue).decimalNumberByDividingBy(2)
		} else {
			// Odd number of items - take the middle item.
			return sorted[Int(count / 2)]
		}
	}
	
	
	func dailyAmounts(values: [Transaction]) ->[String:NSDecimalNumber] {
		var dailyAmounts = [String:NSDecimalNumber]()
		var dayHash:String = ""
		for item in values {
			dayHash = item.date.formatToHash()
			if dailyAmounts[dayHash] === nil {
				dailyAmounts[dayHash] = item.getStaticValueInCurrency(self.homeCurrency).amount
			} else {
				dailyAmounts[dayHash] = dailyAmounts[dayHash]!.decimalNumberByAdding(item.getStaticValueInCurrency(self.homeCurrency).amount)
			}
		}
		return dailyAmounts
	}

}