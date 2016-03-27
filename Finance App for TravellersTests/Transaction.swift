//
//  Transaction.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 17/08/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//
import UIKit

class Transaction: NSObject {
	
	var amount: NSDecimalNumber
	var date: NSDate
	var rate: NSDecimalNumber
	var currency: Currency
	var category: Category?
	
	init(amount:NSDecimalNumber, date:String, rate: NSDecimalNumber, currency: Currency) {
		self.amount = amount
		self.date = NSDate().fromString(date)!
		self.rate = rate
		self.currency = currency
	}
	
	
	
	override func setValue(value: AnyObject?, forKey key: String) {
		if key == "amount" {
			setAmountWithMoney(value as! NSDecimalNumber)
		} else {
			super.setValue(value, forKey: key)
		}
	}
	
	
	func setAmountWithMoney(value: NSDecimalNumber) {
		self.amount = value.formatToMoney()
	}
	
	func getMoney() -> Money {
		return Money(amount: self.amount, currency: self.currency)
	}

	
	func setCategoryWithUpdate(category: Category) {
		self.category = category
		self.category!.addTransaction(self)
	}
}
