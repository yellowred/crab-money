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
    @NSManaged var name: String?
    @NSManaged var rate: NSNumber
    @NSManaged var flag: NSData?
    @NSManaged var country: NSSet?
	
	lazy var flagImage: UIImage? = {
		if self.flag == nil
		{
			return nil
		}
		else
		{
			return UIImage(data: self.flag!)
		}
		}()
	
	
	func getFlag() -> UIImage?
	{
		return self.flagImage
	}
}
