//
//  CurrencyView.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 23/01/16.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import UIKit

class CurrencyView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
		let width = rect.width
		let height = rect.height
		
		
		let context = UIGraphicsGetCurrentContext()

		CGContextSetStrokeColorWithColor(context, UIColor.lightGrayColor().CGColor)
		CGContextSetLineWidth(context, 1.0)
		CGContextSetShadow(context, CGSizeMake(5, 0), 4)
		CGContextMoveToPoint(context, 0, height - 5)
		CGContextAddLineToPoint(context, width, height - 5)
		CGContextStrokePath(context)
		
		/*
		let myColorspace = CGColorSpaceCreateDeviceRGB()
		
		let colors = [UIColor(rgba: "#FFFFFF").CGColor, UIColor(rgba: "#34495E").CGColor]
		let myGradient = CGGradientCreateWithColors(
			myColorspace,
			colors,
			[0.0, 1.0]
		)
		
		CGContextSaveGState(context)
		CGContextAddRect(context, CGRectMake(0, height-5, width, height))
		CGContextClip(context)

		CGContextDrawLinearGradient(context, myGradient, CGPoint(x:0, y: height), CGPoint(x:0, y: height - 3), CGGradientDrawingOptions.DrawsAfterEndLocation)
		CGContextRestoreGState(context)
		*/
    }

}
