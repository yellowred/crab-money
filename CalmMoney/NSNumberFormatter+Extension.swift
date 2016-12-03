//
//  NSNumberNumber+Extension.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 12/10/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import Foundation
extension NumberFormatter {

	func formatterSimpleMoney() -> NumberFormatter {
		self.numberStyle = NumberFormatter.Style.none
		self.maximumFractionDigits = 2
		self.minimumFractionDigits = 2
		return self
	}
	
	
	func formatterMoney(_ currency: Currency) -> NumberFormatter {
		self.numberStyle = NumberFormatter.Style.currency
		let locale = Locale(
			identifier: Locale.identifier(
				fromComponents: [
					NSLocale.Key.currencyCode.rawValue: currency.code,
					NSLocale.Key.languageCode.rawValue: Bundle.main.preferredLocalizations.first!
				]
			)
		)
		self.locale = locale
		return self
	}
	
	func formatterDollars() -> NumberFormatter {
		self.numberStyle = NumberFormatter.Style.decimal
		self.roundingMode = NumberFormatter.RoundingMode.floor
		self.maximumFractionDigits = 0
		self.minimumFractionDigits = 0
		return self
	}
	
}
