//
//  NumpadView.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 25/12/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class NumpadView: UIView {

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

		// vertical lines
		for x in [width * 0.3 + width * 0.1 / 3, width * 0.7 - width * 0.1 / 3] {
			centerPoint = CGPoint(x:x, y:height / 2)
			
		CGContextSaveGState(context)
		CGContextAddRect(context, CGRectMake(x, 0, 1, height))
		CGContextClip(context)

		CGContextDrawRadialGradient(
			context,
			myGradient,
			centerPoint,
			0,
			centerPoint,
			height / 2,
			CGGradientDrawingOptions.DrawsAfterEndLocation
		)
		CGContextRestoreGState(context)
		}
		
		
		// horizontal lines
		for y in [height * 0.24 + 1, height * 0.48 + 4, height * 0.72 + 7] {
			centerPoint = CGPoint(x:width / 2, y:y)
			
			CGContextSaveGState(context)
			CGContextAddRect(context, CGRectMake(0, y, width, 1))
			CGContextClip(context)
			
			CGContextDrawRadialGradient(
				context,
				myGradient,
				centerPoint,
				0,
				centerPoint,
				width / 2,
				CGGradientDrawingOptions.DrawsAfterEndLocation
			)
			CGContextRestoreGState(context)
		}

    }
}
