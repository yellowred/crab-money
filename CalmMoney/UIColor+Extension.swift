//
//  UIColor+Extension.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 23/12/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

enum UIColorPalette: String {
	case StatusBar = "#7b806c"
}

extension UIColor {
	convenience init(rgba: String) {
		var red:   CGFloat = 0.0
		var green: CGFloat = 0.0
		var blue:  CGFloat = 0.0
		var alpha: CGFloat = 1.0
		
		if rgba.hasPrefix("#") {
			let index   = rgba.characters.index(rgba.startIndex, offsetBy: 1)
			let hex     = rgba.substring(from: index)
			let scanner = Scanner(string: hex)
			var hexValue: CUnsignedLongLong = 0
			if scanner.scanHexInt64(&hexValue) {
				switch (hex.characters.count) {
				case 3:
					red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
					green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
					blue  = CGFloat(hexValue & 0x00F)              / 15.0
				case 4:
					red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
					green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
					blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
					alpha = CGFloat(hexValue & 0x000F)             / 15.0
				case 6:
					red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
					green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
					blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
				case 8:
					red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
					green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
					blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
					alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
				default:
					print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
				}
			} else {
				print("Scan hex error")
			}
		} else {
			print("Invalid RGB string, missing '#' as prefix")
		}
		self.init(red:red, green:green, blue:blue, alpha:alpha)
	}
	
	
	static func expense() -> UIColor {
		return UIColor(red:0.92, green:0.6, blue:0.53, alpha:1)
	}
	
	
	static func earning() -> UIColor {
		return UIColor(red:0.66, green:0.9, blue:0.44, alpha:1)
	}
	
	static func statusBar() -> UIColor {
		return UIColor(red:1, green:1, blue:1, alpha:1)
	}

	static func statusBarText() -> UIColor {
		return UIColor(red:0, green:0, blue:0, alpha:1)
	}
	
	static func amountColor() -> UIColor {
		return UIColor(red:0.18, green:0.18, blue:0.18, alpha:1)
	}
	
	static func selectedSubscriptionPlan() -> UIColor {
		return UIColor(rgba: "#587F36")
	}
	
	static func addAnotherCurrency() -> UIColor {
		return UIColor(red:0.8, green:0.8, blue:0.8, alpha:0.8)
	}
}
