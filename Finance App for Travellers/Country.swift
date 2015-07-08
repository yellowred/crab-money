//
//  Country.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 08/07/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit
import CoreData

@objc(Country) class Country: NSManagedObject {

    @NSManaged var code: String
    @NSManaged var name: String
    @NSManaged var currency: Currency

    
    lazy var flag: UIImage? = {
        return UIImage(named: "flag_\(self.code)")
    }()
    
    
    func getFlag() -> UIImage?
    {
        return self.flag
    }
}
