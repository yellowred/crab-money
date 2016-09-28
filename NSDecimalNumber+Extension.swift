//
//  NSDecimalNumber+Extension.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 12/10/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import Foundation
extension NSDecimalNumber {
	func abs() -> NSDecimalNumber {
		if self.compare(NSDecimalNumber.zero) == ComparisonResult.orderedAscending {
			return NSDecimalNumber.zero.subtracting(self)
		} else {
			return self
		}
	}

	func formatToMoney() -> NSDecimalNumber {
		return NSDecimalNumber(string: NumberFormatter().formatterSimpleMoney().string(from: self))
	}
	
	func isPositive() -> Bool {
		return self.compare(NSDecimalNumber.zero) == ComparisonResult.orderedDescending
	}
	
	func floor() -> NSDecimalNumber {
		return self.rounding(
			accordingToBehavior: NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.down, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
		)
	}
}
