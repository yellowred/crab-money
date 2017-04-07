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
	
	static let friendlyColors: [UIColor] = [
		#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1), #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1), #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
	]
	
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
