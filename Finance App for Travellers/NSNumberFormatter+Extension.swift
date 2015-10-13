//
//  NSNumberNumber+Extension.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 12/10/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import Foundation
extension NSNumberFormatter {

	func formatterSimpleMoney() -> NSNumberFormatter {
		self.numberStyle = NSNumberFormatterStyle.DecimalStyle
		self.maximumFractionDigits = 2
		self.minimumFractionDigits = 2
		return self
	}
	
	
	func formatterMoney(currency: Currency) -> NSNumberFormatter {
		self.numberStyle = NSNumberFormatterStyle.CurrencyStyle
		let locale = NSLocale(
			localeIdentifier: NSLocale.localeIdentifierFromComponents(
				[
					NSLocaleCurrencyCode: currency.code,
					NSLocaleLanguageCode: NSBundle.mainBundle().preferredLocalizations.first!
				]
			)
		)
		self.locale = locale
		return self
	}
	
	func formatterDollars()-> NSNumberFormatter {
		self.numberStyle = NSNumberFormatterStyle.DecimalStyle
		self.roundingMode = NSNumberFormatterRoundingMode.RoundFloor
		self.maximumFractionDigits = 0
		self.minimumFractionDigits = 0
		return self
	}
	
}