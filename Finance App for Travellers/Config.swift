//
//  Config.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 2/12/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation

class Config {
	
	class func read(value: String) -> Any? {
		var myDict: NSDictionary?
		if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
			myDict = NSDictionary(contentsOfFile: path)
		}
		return myDict?[value]
	}
}
