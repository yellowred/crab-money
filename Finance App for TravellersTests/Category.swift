//
//  Category.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 20/01/16.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation

class Category: NSObject {
	
	var name: String
	var transactions: [Transaction] = []
	var is_expense: Bool

	init(name:String, is_expense: Bool) {
		self.name = name
		self.is_expense = is_expense
	}
	
	func addTransaction(transaction: Transaction) {
		transactions.append(transaction)
	}
	
	func getTransactions() -> [Transaction] {
		return transactions
	}
}
