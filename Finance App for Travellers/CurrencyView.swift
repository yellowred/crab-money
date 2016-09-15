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
    override func draw(_ rect: CGRect) {
        // Drawing code
		let width = rect.width
		let height = rect.height
		
		
		let context = UIGraphicsGetCurrentContext()

		context?.setStrokeColor(UIColor.lightGray.cgColor)
		context?.setLineWidth(1.0)
		context?.setShadow(offset: CGSize(width: 5, height: 0), blur: 4)
		context?.move(to: CGPoint(x: 0, y: height - 5))
		context?.addLine(to: CGPoint(x: width, y: height - 5))
		context?.strokePath()
		
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
