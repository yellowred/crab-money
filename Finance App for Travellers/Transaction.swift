//
//  Transaction.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 17/08/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//
import UIKit
import CoreData

@objc(Transaction) class Transaction: NSManagedObject {

    @NSManaged var amount: NSDecimalNumber
    @NSManaged var date: NSDate
    @NSManaged var text: String
    @NSManaged var category: NSManagedObject
    @NSManaged var currency: Currency

}
