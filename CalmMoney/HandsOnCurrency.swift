//
//  HandsOnCurrency.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 10/08/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class HandsOnCurrency: NSObject {

	var amount: Money
	var textField: UITextField?
	
	
	init(amount: Money, textField: UITextField?) {
		self.amount = amount
		self.textField = textField
	}
	
	
	func setAmount(_ amount: NSDecimalNumber) {
		self.amount.setAmount(amount)
		//textField?.text = self.amount.amount.stringValue
		if textField != nil {
			(textField as! AmountTextField).setAmount(value: self.amount.amount)
		}
	}
	
}
