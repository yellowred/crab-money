//
//  Currency.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 22/06/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit
class Currency
{
    
    // MARK: Properties
    
    var code: String
    var country: String
    var rate: Float
    var flag: UIImage?
    
    init?(code:String, country:String, rate: Float, flag: UIImage?)
    {
        self.code = code
        self.country = country
        self.rate = rate
        self.flag = flag
        if code.isEmpty
        {
            return nil
        }
    }
    
}


