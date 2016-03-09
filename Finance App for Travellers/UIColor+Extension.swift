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
			let index   = rgba.startIndex.advancedBy(1)
			let hex     = rgba.substringFromIndex(index)
			let scanner = NSScanner(string: hex)
			var hexValue: CUnsignedLongLong = 0
			if scanner.scanHexLongLong(&hexValue) {
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
		return UIColor(red:0.46, green:0.89, blue:0.47, alpha:1)
	}
	
	static func statusBar() -> UIColor {
		return UIColor(red:0.43, green:0.63, blue:0.42, alpha:1)
		return UIColor(red:0.34, green:0.57, blue:0.33, alpha:1)
		return UIColor(red:0.53, green:0.78, blue:0.53, alpha:1)
		return UIColor(red:0.51, green:0.81, blue:0.45, alpha:1)
		return UIColor(red:0.16, green:0.16, blue:0.11, alpha:1)
		return UIColor(red:0.16, green:0.16, blue:0.16, alpha:1)
	}
	
}