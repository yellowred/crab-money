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
		if self.compare(NSDecimalNumber.zero()) == NSComparisonResult.OrderedAscending {
			return NSDecimalNumber.zero().decimalNumberBySubtracting(self)
		} else {
			return self
		}
	}

	func formatToMoney() -> NSDecimalNumber {
		return NSDecimalNumber(string: NSNumberFormatter().formatterSimpleMoney().stringFromNumber(self))
	}
	
	func isPositive() -> Bool {
		return self.compare(NSDecimalNumber.zero()) == NSComparisonResult.OrderedDescending
	}
	
	func floor() -> NSDecimalNumber {
		return self.decimalNumberByRoundingAccordingToBehavior(
			NSDecimalNumberHandler(roundingMode: NSRoundingMode.RoundDown, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
		)
	}
}