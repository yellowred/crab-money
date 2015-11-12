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

}
