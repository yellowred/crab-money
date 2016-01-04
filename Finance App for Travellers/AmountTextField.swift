//
//  AmountTextField.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 08/08/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class AmountTextField: UITextField {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
		let width = rect.width
		let height = rect.height
		
		
		let context = UIGraphicsGetCurrentContext()
		let myColorspace = CGColorSpaceCreateDeviceRGB();
		
		let colors = [UIColor(rgba: "#34495E").CGColor, UIColor(rgba: "#FFFFFF").CGColor]
		let myGradient = CGGradientCreateWithColors(
			myColorspace,
			colors,
			[0.0, 1.0]
		)
		
		var centerPoint:CGPoint
		centerPoint = CGPoint(x:width, y:height)
			
		CGContextSaveGState(context)
		CGContextAddRect(context, CGRectMake(0, height-1, width, height))
		CGContextClip(context)
			
			CGContextDrawRadialGradient(
				context,
				myGradient,
				centerPoint,
				0,
				centerPoint,
				width,
				CGGradientDrawingOptions.DrawsAfterEndLocation
			)
		CGContextRestoreGState(context)
	
    }
	
	var correspondingCurrency: HandsOnCurrency?

}
