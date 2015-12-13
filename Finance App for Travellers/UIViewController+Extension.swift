//
//  UIViewController+Extension.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 13/12/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

extension UIViewController {
	func app() -> AppDelegate {
		return UIApplication.sharedApplication().delegate as! AppDelegate
	}
}