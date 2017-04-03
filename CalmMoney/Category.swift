//
//  Category.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 20/08/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit
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
	
	func getColor() -> UIColor? {
		if let categoryColorComponentsData = self.logo {
			let categoryColorCompString = NSString(data: categoryColorComponentsData as Data, encoding: String.Encoding.utf8.rawValue)
			let diyValues = categoryColorCompString?.components(separatedBy: " ")
			if let colorRed = diyValues?[1].floatValue(), let colorGreen = diyValues?[2].floatValue(), let colorBlue = diyValues?[3].floatValue() {
				return UIColor(colorLiteralRed: colorRed, green: colorGreen, blue: colorBlue, alpha: 1)
			}
			
		}
		return nil
	}
	
}
