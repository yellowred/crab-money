//
//  UIImage+Extension.swift
//  CalmMoney
//
//  Created by Oleg Kubrakov on 11/12/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import UIKit

extension UIImage {
	
	var square: UIImage? {
		let w = min(size.width, size.height)
		guard let image =  cgImage!.cropping(to: CGRect(origin: CGPoint(x: (size.width - w)/2, y: (size.height - w)/2),
		                                                      size: CGSize(width: w, height: w)))
			else { return nil }
		return UIImage(cgImage: image, scale: 1, orientation: imageOrientation)
	}
}
