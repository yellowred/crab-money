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
    @NSManaged var date: Date
    @NSManaged var rate: NSDecimalNumber
    @NSManaged var text: String
    @NSManaged var category: Category?
	var currency: Currency {
		get {
			self.willAccessValue(forKey:"currency")
			let currency = self.primitiveValue(forKey: "currency") as! Currency
			self.didAccessValue(forKey: "currency")
			return currency
		}
		set {
			self.willChangeValue(forKey: "currency")
			self.setPrimitiveValue(newValue, forKey: "currency")
			self.didChangeValue(forKey: "text")
			self.rate = newValue.rate
		}
	}
	
	
	override func setValue(_ value: Any?, forKey key: String) {
		if key == "amount" {
			setAmountWithMoney(value: value as! NSDecimalNumber)
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
	
	
	func getDict(currency: Currency) -> String {
		var str = "{\"amount\": " + self.amount.stringValue
		str += ", \"date\": \"" + self.date.formatWithTimeLong() + "\""
		str += ",\"category\": \"" + self.category!.name + "\""
		str	+= ",\"currency\": \"" + self.currency.code + "\""
		return str
	}
}
