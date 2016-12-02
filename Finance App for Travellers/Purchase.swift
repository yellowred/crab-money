//
//  Purchase.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 2/12/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation

class Purchase {
	
	class func readConfig(value: String) -> Any? {
		var myDict: NSDictionary?
		if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
			myDict = NSDictionary(contentsOfFile: path)
		}
		return myDict?[value]
	}
	
	class func canAddTransaction(to model: Model) -> Bool {
		if let transactionsMaxFree = readConfig(value: "transactions-max-free") {
			if model.getTransactionsList().count >= transactionsMaxFree as! Int {
				return false
			}
		}
		return true
	}
	
	
	class func canUseConverter() -> Bool {
		return readConfig(value: "converter-free") as! Bool
	}
	

}
