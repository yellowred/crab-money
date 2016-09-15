//
//  NSLayoutConstraint+Extension.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 22/01/16.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import UIKit
extension NSLayoutConstraint {
	
	override open var description: String {
		let id = identifier ?? ""
		return "id: \(id), constant: \(constant)" //you may print whatever you want here
	}
}
