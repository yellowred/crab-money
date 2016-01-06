//
//  Math.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 06/01/16.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation

class Math {
	var transactions: [Transaction]?
	
	func getExpenses() -> [Transaction] {
		let expenses: [Transaction] = transactions!.filter {
			(x : Transaction) -> Bool in
			if x.amount.compare(NSDecimalNumber.zero()) == NSComparisonResult.OrderedAscending {
				return true
			}
			return false
		}
		return expenses
	}
}