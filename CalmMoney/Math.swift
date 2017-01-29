//
//  Math.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 06/01/16.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation
import Crashlytics

class Math: NSObject {
	var transactions: [Transaction]
	var homeCurrency: Currency
	var currentPeriod: PeriodMonth
	
	init(transactions: [Transaction], homeCurrency: Currency, currentPeriod: PeriodMonth) {
		self.transactions = transactions

		self.homeCurrency = homeCurrency
		self.currentPeriod = currentPeriod
	}
	
	
	lazy var expenses: [Transaction] = {
		return self.transactions.filter {
			(x : Transaction) -> Bool in
			if x.amount.compare(NSDecimalNumber.zero) == ComparisonResult.orderedAscending {
				return true
			}
			return false
		}
	}()
	
	
	lazy var expensesTotal:NSDecimalNumber = {
		var sum = NSDecimalNumber(value: 0)
		for elem in self.expenses {
			let money = self.getMoneyInCurrencyWithHistoryRate(elem, currency:self.homeCurrency)
			do {
				try ObjC.catchException {
					sum = money.amount.adding(sum)
				}
			} catch let error {
				Crashlytics.sharedInstance().setObjectValue(elem, forKey: "trn")
				Crashlytics.sharedInstance().setObjectValue(money.amount, forKey: "trn_money")
				Crashlytics.sharedInstance().setObjectValue(sum, forKey: "sum_number")
				Crashlytics.sharedInstance().recordError(error)
				sum = NSDecimalNumber(value: 0)
			}
		}
		return sum.abs()
	}()

	lazy var expensesToday:NSDecimalNumber = {
		var dayHash:String = Date().formatToHash()
		guard self.dailyAmounts(self.expenses)[dayHash] != nil else {
			return 0
		}
		return self.dailyAmounts(self.expenses)[dayHash]!
	}()
	
	lazy var expensesAvg:NSDecimalNumber = {
		return self.expenses.count > 0 ? self.expensesTotal.dividing(by: NSDecimalNumber(value: self.currentPeriod.getDaysPassed() as Int)) : NSDecimalNumber(value: 0 as Int)
	}()
	
	lazy var expensesMedian:NSDecimalNumber = {
		return self.median(self.expenses)
	}()
	
	
	lazy var expensesProjected:NSDecimalNumber = {
		return self.expensesAvg.multiplying(by: NSDecimalNumber(value: self.currentPeriod.getDaysCount() as Int))
	}()
	
	
	lazy var expensesMaxTransaction:Transaction? = {
		return self.expenses.max(by: {(a: Transaction, b:Transaction) in
			return self.getMoneyInCurrencyWithHistoryRate(a, currency:self.homeCurrency).amount.compare(self.getMoneyInCurrencyWithHistoryRate(b, currency:self.homeCurrency).amount) == ComparisonResult.orderedDescending
		})
	}()
	
	lazy var expenseCategories: [Category] = {
		var categories: [Category] = []
		for trn:Transaction in self.expenses {
			if trn.category != nil && categories.contains(trn.category!) != true {
				categories.append(trn.category!)
			}
		}
		categories.sort { self.getCategoryAmountForPeriod($0).compare(self.getCategoryAmountForPeriod($1)) == ComparisonResult.orderedAscending }
		return categories
	}()
	
	
	lazy var earnings: [Transaction] = {
		return self.transactions.filter {
			(x : Transaction) -> Bool in
			if x.amount.compare(NSDecimalNumber.zero) == ComparisonResult.orderedDescending {
				return true
			}
			return false
		}
	}()
	
	
	lazy var earningsTotal:NSDecimalNumber = {
		return self.earnings.reduce(0, {
			return self.getMoneyInCurrencyWithHistoryRate($1, currency:self.homeCurrency).amount.adding($0)
		})
	}()
	
	
	lazy var earningsAvg:NSDecimalNumber = {
		return self.earnings.count > 0 ? self.earningsTotal.dividing(by: NSDecimalNumber(value: self.currentPeriod.getDaysPassed() as Int)) : NSDecimalNumber(value: 0 as Int)
	}()
	
	
	lazy var earningCategories: [Category] = {
		var categories: [Category] = []
		for trn:Transaction in self.earnings {
			if trn.category != nil && categories.contains(trn.category!) != true {
				categories.append(trn.category!)
			}
		}
		categories.sort { self.getCategoryAmountForPeriod($0).compare(self.getCategoryAmountForPeriod($1)) == ComparisonResult.orderedAscending }
		return categories
	}()

	
	func getCategoryAmountForPeriod(_ category: Category) -> NSDecimalNumber {
		var amount = NSDecimalNumber(value: 0 as Int)
		for elem: Transaction in transactions {
			if elem.category == category {
				amount = amount.adding(getMoneyInCurrencyWithHistoryRate(elem, currency: self.homeCurrency).amount)
			}
		}
		return amount
	}
	
	func getTransactionsForCategoryAndPeriod(_ category: Category) -> [Transaction] {
		return transactions.filter {
			(x : Transaction) -> Bool in
			return x.category == category
		}
	}
	
	func median(_ values: [Transaction]) -> NSDecimalNumber {
		let sorted = dailyAmounts(values).map {$1} .sorted { $0.compare($1) == ComparisonResult.orderedAscending }
		let count = Double(sorted.count)
		if count == 0 { return 0 }

		if count.truncatingRemainder(dividingBy: 2) == 0 {
			// Even number of items - return the mean of two middle values
			let leftIndex = Int(count / 2 - 1)
			let leftValue = sorted[leftIndex]
			let rightValue = sorted[leftIndex + 1]
			return leftValue.adding(rightValue).dividing(by: 2)
		} else {
			// Odd number of items - take the middle item.
			return sorted[Int(count / 2)]
		}
	}
	
	
	func dailyAmounts(_ values: [Transaction]) ->[String:NSDecimalNumber] {
		var dailyAmounts = [String:NSDecimalNumber]()
		var dayHash:String = ""
		for item in values {
			dayHash = item.date.formatToHash()
			if dailyAmounts[dayHash] === nil {
				dailyAmounts[dayHash] = getMoneyInCurrencyWithHistoryRate(item, currency: self.homeCurrency).amount
			} else {
				dailyAmounts[dayHash] = dailyAmounts[dayHash]!.adding(getMoneyInCurrencyWithHistoryRate(item, currency: self.homeCurrency).amount)
			}
		}
		return dailyAmounts
	}
	
	
	func getMoneyInCurrencyWithHistoryRate(_ transaction:Transaction, currency: Currency) -> Money {
		guard transaction.currency.code != currency.code else {
			return Money(amount: transaction.amount, currency: currency)
		}
		let usdAmount: NSDecimalNumber = transaction.amount.dividing(by: transaction.rate)
		let currencyAmount = usdAmount.multiplying(by: currency.rate, withBehavior: NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false))
		return Money(amount: currencyAmount, currency: currency)
	}


}
