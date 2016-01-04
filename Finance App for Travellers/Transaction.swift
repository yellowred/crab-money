//
//  Transaction.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 17/08/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//
import UIKit
import CoreData

@objc(Transaction) class Transaction: NSManagedObject {

    @NSManaged var amount: NSDecimalNumber
    @NSManaged var date: NSDate
    @NSManaged var rate: NSDecimalNumber
    @NSManaged var text: String
    @NSManaged var category: Category?
    @NSManaged var currency: Currency
	
	
	override func setValue(value: AnyObject?, forKey key: String) {
		if key == "amount" {
			setAmountWithMoney(value as! NSDecimalNumber)
		} else {
			super.setValue(value, forKey: key)
		}
	}
	
	
	func setAmountWithMoney(value: NSDecimalNumber) {
		self.amount = value.formatToMoney()
		print(value, self.amount)
	}
	
	func getMoney() -> Money {
		return Money(amount: self.amount, currency: self.currency)
	}
	
	
	func getStaticValueInCurrency(currency: Currency) -> Money {
		let usdAmount: NSDecimalNumber = amount.decimalNumberByDividingBy(rate)
		let currencyAmount = usdAmount.decimalNumberByMultiplyingBy(currency.rate, withBehavior: NSDecimalNumberHandler(roundingMode: NSRoundingMode.RoundPlain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false))
		return Money(amount: currencyAmount, currency: currency)
	}

}
