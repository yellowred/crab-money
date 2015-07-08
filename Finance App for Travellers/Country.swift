//
//  Country.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 07/07/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit
import CoreData

class Country: NSManagedObject
{
    @NSManaged var currency: Currency
    
    lazy var flag: UIImage? = {
        if let countryCode: String = self.getCode()
        {
            return UIImage(named: "flag_\(self.getCode())")
        }
        else
        {
            return nil
        }
    }()

    
    func getCode() -> String?
    {
        return self.valueForKey("code") as? String
    }
    
    func getFlag() -> UIImage?
    {
        return self.flag
    }
}