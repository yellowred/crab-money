//
//  Currency.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 16/07/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit
import CoreData

@objc(Currency) class Currency: NSManagedObject {

    @NSManaged var code: String
    @NSManaged var rate: NSDecimalNumber
    @NSManaged var flag: NSData
    @NSManaged var country: NSSet?
    @NSManaged var in_converter: NSNumber
	
	var t1:String = "Currency"
	
	lazy var flagImage: UIImage? = {
		return UIImage(data: self.flag)
	}()
	
	
	func getFlag() -> UIImage?
	{
		return self.flagImage
	}
	
	func addToConverter() {
		self.in_converter = 1
	}
	
	func getLocalizedName() -> String {
		let localizedIdentifier: String = code + "_currency_name"
		return localizedIdentifier.localized
	}
}
