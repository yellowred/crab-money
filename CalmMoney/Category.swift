//
//  Category.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 20/08/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import Foundation
import CoreData

@objc(Category) class Category: NSManagedObject {

    @NSManaged var logo: NSData?
    @NSManaged var name: String
    @NSManaged var transaction: NSSet
    @NSManaged var is_expense: Bool
}

extension Category {
	func getTransactions() -> [Transaction] {
		return self.transaction.allObjects as! [Transaction]
	}
	
}