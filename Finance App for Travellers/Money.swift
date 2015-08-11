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
	var integralPart: NSString
	var fractionalPart: NSString
	var pointExists: Bool
	
	init(amount: NSDecimalNumber, currency: Currency) {
		self.amount = amount
		let amountParts = NSString(string: amount.stringValue).componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "."))
		self.integralPart = amountParts[0] as! NSString
		if amountParts.count > 1 {
			pointExists = true
			self.fractionalPart = amountParts[1] as! NSString
		} else {
			self.pointExists = false
			self.fractionalPart = ""
		}
		self.currency = currency
	}
	
	
	func appendSymbol(symbol:String) {
		if NSPredicate(format: "", "[0-9.]").evaluateWithObject(symbol) {
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
				fractionalPart.substringToIndex(fractionalPart.length.predecessor())
			} else if fractionalPart.length == 0 {
				pointExists = false
			}
		} else {
			integralPart.substringToIndex(fractionalPart.length.predecessor())
		}
	}
}