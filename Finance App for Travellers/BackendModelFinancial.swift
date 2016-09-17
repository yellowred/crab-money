//
//  BackendModelFinancial.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 13/9/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation
import LoopBack

class BackendModelFinancial : LBPersistedModel {
	var amount: NSDecimalNumber = 0.0
	var date: Date!
	var rate: NSDecimalNumber = 0.0
	var text: String = ""
	var category: String = ""
	var uuid: String = ""
}
