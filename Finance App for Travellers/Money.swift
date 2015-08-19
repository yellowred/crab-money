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
	
	
	func appendSymbol(symbol:String) {
		if NSPredicate(format: "SELF MATCHES %@", "[0-9.]").evaluateWithObject(symbol) {
			if symbol != "." {
				if pointExists {
					if (fractionalPart.length < 3) {
						fractionalPart = fractionalPart.stringByAppendingString(symbol)
					}
				} else {
					if integralPart.length < 11 {
						integralPart = integralPart.stringByAppendingString(symbol)
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
			amount = NSDecimalNumber(string: NSArray(array: [integralPart, fractionalPart]).componentsJoinedByString(decimalPoint))
		} else {
			amount = NSDecimalNumber(int: integralPart.intValue)
		}
	}
		
	func backspace() {
		if pointExists {
			if fractionalPart.length > 0 {
				fractionalPart = NSString(string: fractionalPart.substringToIndex(fractionalPart.length.predecessor()))
			} else if fractionalPart.length == 0 {
				pointExists = false
			}
		} else {
			integralPart = NSString(string: integralPart.substringToIndex(integralPart.length.predecessor()))
		}
		recalcAmount()
	}
	
	
	func toCurrency(toCurrency: Currency) -> Money
	{
		//println("Converting from \(fromCurrency.code)[\(fromCurrency.rate)] to \(toCurrency.code)[\(toCurrency.rate)]")
		println("Amount: \(amount). Currency: \(currency)")
		let usdAmount: NSDecimalNumber = amount.decimalNumberByDividingBy(currency.rate)
		return Money(amount: usdAmount.decimalNumberByMultiplyingBy(toCurrency.rate).decimalNumberByRoundingAccordingToBehavior(NSDecimalNumberHandler(roundingMode: NSRoundingMode.RoundUp, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)), currency: toCurrency)
	}
	
	
	func setAmount(amount: NSDecimalNumber) {
		self.amount = amount
		recalcParts()
	}
	
	
	func recalcParts() {
		let amountParts = NSString(string: amount.stringValue).componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "."))
		self.integralPart = amountParts[0] as! NSString
		if amountParts.count > 1 {
			pointExists = true
			self.fractionalPart = amountParts[1] as! NSString
		} else {
			self.pointExists = false
			self.fractionalPart = ""
		}
		
	}
}