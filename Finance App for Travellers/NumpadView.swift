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
    override func draw(_ rect: CGRect) {
		let width = rect.width
		let height = rect.height
		
		
		let context:CGContext = UIGraphicsGetCurrentContext()!
		let myColorspace = CGColorSpaceCreateDeviceRGB();

		let colors = [UIColor.amountColor().cgColor, UIColor.white.cgColor]
		let myGradient = CGGradient(
			colorsSpace: myColorspace,
			colors: colors as CFArray,
			locations: [0.0, 1.0]
		)
		
		var centerPoint:CGPoint

		// vertical lines
		let firstLineX = width * 0.3 + width * 0.1 / 3
		for x in [firstLineX, width * 0.7 - width * 0.1 / 3] {
			centerPoint = CGPoint(x:x, y:height / 2)
			context.saveGState()
			context.addRect(CGRect(x: x, y: 0, width: 1, height: height))
			context.clip()

			context.drawRadialGradient( myGradient!,
			                           startCenter: centerPoint,
			                           startRadius: 0,
			                           endCenter: centerPoint,
			                           endRadius: height / 2,
			                           options: CGGradientDrawingOptions.drawsAfterEndLocation )
			context.restoreGState()
		}
		
		
		// horizontal lines
		for y in [height * 0.24 + 1, height * 0.48 + 4, height * 0.72 + 7] {
			centerPoint = CGPoint(x:width / 2, y:y)
			
			context.saveGState()
			context.addRect(CGRect(x: 0, y: y, width: width, height: 1))
			context.clip()
			
			context.drawRadialGradient(myGradient!,
				startCenter: centerPoint,
				startRadius: 0,
				endCenter: centerPoint,
				endRadius: width / 2,
				options: CGGradientDrawingOptions.drawsAfterEndLocation
			)
			context.restoreGState()
		}

    }
}
