//
//  BackendModelFinancial.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 13/9/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation

class BackendModelFinancial : LBPersistedModel {
	var amount: NSDecimalNumber
	var date: Date
	var rate: NSDecimalNumber
	var text: String
	var category: String
	var uuid: String
}
