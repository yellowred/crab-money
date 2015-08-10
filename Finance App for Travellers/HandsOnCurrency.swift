//
//  HandsOnCurrency.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 10/08/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class HandsOnCurrency {

	let currency: Currency
	var amount: NSDecimalNumber?
	var textField: UITextField?
	
	
	init(currency: Currency, amount: NSDecimalNumber?, textField: UITextField?) {
		self.currency = currency
		self.amount = amount
		self.textField = textField
	}
    
}