//
//  Currency.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 22/06/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit
import CoreData

class Currency: NSManagedObject
{
    @NSManaged var country: Country
    
    func getCode() -> String
    {
        return self.valueForKey("code") as! String
    }
    
    
    func getCountry() -> Country
    {
        return self.valueForKey("country") as! Country
    }
}


