//
//  AmountTextField.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 08/08/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class AmountTextField: UITextField, UITextFieldDelegate {

	private var characterLimit: Int?
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		delegate = self
	}
	
	
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
	
	
	@IBInspectable var maxLength: Int {
		get {
			guard let length = characterLimit else {
				return Int.max
			}
			return length
		}
		set {
			characterLimit = newValue
		}
	}
	
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
  
		// 2
		guard string.characters.count > 0 else {
			return true
		}
		
		// 3
		let currentText = textField.text ?? ""
		// 4
		let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
		// 5
		return prospectiveText.characters.count <= maxLength
	}

}
