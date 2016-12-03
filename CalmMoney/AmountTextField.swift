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
    override func draw(_ rect: CGRect) {
		let width = rect.width
		let height = rect.height
		
		
		let context = UIGraphicsGetCurrentContext()
		let myColorspace = CGColorSpaceCreateDeviceRGB();
		
		let colors = [UIColor(rgba: "#34495E").cgColor, UIColor(rgba: "#34495E").cgColor]
		let myGradient = CGGradient(
			colorsSpace: myColorspace,
			colors: colors as CFArray,
			locations: [0.0, 1.0]
		)
		
		var centerPoint:CGPoint
		centerPoint = CGPoint(x:width, y:height)
			
		context?.saveGState()
		context?.addRect(CGRect(x: 0, y: height-1, width: width, height: height))
		context?.clip()
			
			context?.drawRadialGradient(myGradient!,
				startCenter: centerPoint,
				startRadius: 0,
				endCenter: centerPoint,
				endRadius: width,
				options: CGGradientDrawingOptions.drawsAfterEndLocation
			)
		context?.restoreGState()
	
    }
	
	var correspondingCurrency: HandsOnCurrency?

}
