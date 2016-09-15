//
//  Money.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 11/08/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import Foundation

class Money {
	let decimalPoint:String = "."
	var amount: NSDecimalNumber
	var currency: Currency
	var integralPart: NSString = {return ""}()
	var fractionalPart: NSString = {return ""}()
	var pointExists: Bool = false
	
	init(amount: NSDecimalNumber, currency: Currency) {
		self.amount = amount
		self.currency = currency
		self.recalcParts()
	}
	
	
	func appendSymbol(_ symbol:String) {
		if NSPredicate(format: "SELF MATCHES %@", "[0-9.]").evaluate(with: symbol) {
			if symbol != "." {
				if pointExists {
					if (fractionalPart.length < 2) {
						fractionalPart = fractionalPart.appending(symbol) as NSString
					}
				} else {
					if integralPart.length < 10 {
						integralPart = integralPart.appending(symbol) as NSString
					}
				}
				recalcAmount()
			} else {
				pointExists = true
			}
		}
	}
	
	
	func recalcAmount() {
		if pointExists {
			amount = NSDecimalNumber(string: NSArray(array: [integralPart, fractionalPart]).componentsJoined(by: decimalPoint))
		} else {
			amount = NSDecimalNumber(value: integralPart.intValue as Int32)
		}
	}
		
	func backspace() {
		if pointExists {
			if fractionalPart.length > 0 {
				fractionalPart = NSString(string: fractionalPart.substring(to: (fractionalPart.length - 1)))
			} else if fractionalPart.length == 0 {
				pointExists = false
			}
		} else if (integralPart.length > 0) {
			integralPart = NSString(string: integralPart.substring(to: (integralPart.length - 1)))
		}
		recalcAmount()
	}
	
	
	func toCurrency(_ toCurrency: Currency) -> Money
	{
		let usdAmount: NSDecimalNumber = amount.dividing(by: currency.rate)
		return Money(amount: usdAmount.multiplying(by: toCurrency.rate).rounding(accordingToBehavior: NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.up, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)), currency: toCurrency)
	}
	
	
	func setAmount(_ amount: NSDecimalNumber) {
		self.amount = amount
		recalcParts()
	}
	
	
	func recalcParts() {
		let amountParts = NSString(string: amount.stringValue).components(separatedBy: CharacterSet(charactersIn: "."))
		self.integralPart = amountParts[0] as NSString
		if amountParts.count > 1 {
			pointExists = true
			self.fractionalPart = amountParts[1] as NSString
		} else {
			self.pointExists = false
			self.fractionalPart = ""
		}
		
	}
	
	func stringValue() -> String {
		return NumberFormatter().formatterMoney(currency).string(from: amount)!
	}
	
	
	func valueForAmount() -> String {
		let numberFormatter = NumberFormatter().formatterSimpleMoney()
		numberFormatter.minimumFractionDigits = pointExists ? 1 : 0
		
		return numberFormatter.string(from: amount)!
	}
	
}
