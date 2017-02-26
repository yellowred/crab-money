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

//    @NSManaged var amount: NSDecimalNumber
    @NSManaged var date: Date
    @NSManaged var rate: NSDecimalNumber
    @NSManaged var text: String
    @NSManaged var category: Category?
	var amount: NSDecimalNumber {
		get {
			self.willAccessValue(forKey:"amount")
			let amount = self.primitiveValue(forKey: "amount") as! NSDecimalNumber
			self.didAccessValue(forKey: "amount")
			return amount
		}
		set {
			if newValue != NSDecimalNumber.notANumber {
				self.willChangeValue(forKey: "amount")
				self.setPrimitiveValue(newValue, forKey: "amount")
				self.didChangeValue(forKey: "amount")
			}
		}
	}
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
			self.didChangeValue(forKey: "currency")
			self.rate = newValue.rate
		}
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
	
	func encode() -> [String:Any] {
		return [
			"amount": self.amount.stringValue,
			"currency": self.currency.code,
			"date": self.date.formatWithTimeLong(),
			"rate": self.rate.stringValue,
			"text": self.text,
			"category": self.category!.name,
			"uuid": "oleg",
		]
	}
}
