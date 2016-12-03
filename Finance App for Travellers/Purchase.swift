//
//  Purchase.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 2/12/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation

class Purchase {
	
	class func canAddTransaction(to model: Model) -> Bool {
		if let transactionsMaxFree = Config.read(value: "transactions-max-free") {
			if model.getTransactionsList().count >= transactionsMaxFree as! Int {
				return false
			}
		}
		return true
	}
	
	
	class func canUseConverter() -> Bool {
		return Config.read(value: "converter-free") as! Bool
	}
	

}
