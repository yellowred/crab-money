//
//  Currency.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 08/07/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import Foundation
import CoreData

@objc(Currency) class Currency: NSManagedObject {

    @NSManaged var code: String
    @NSManaged var mdate: NSDate
    @NSManaged var name: String?
    @NSManaged var rate: Float
    @NSManaged var country: Country

}
