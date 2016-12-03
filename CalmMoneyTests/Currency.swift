//
//  Currency.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 06/01/16.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation

class Currency: NSObject {
	
	var code: String
	var rate: NSDecimalNumber
	
	
	init(code: String, rate: NSDecimalNumber) {
		self.code = code
		self.rate = rate
	}
	
}