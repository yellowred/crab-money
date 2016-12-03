//
//  CategoryCollectionViewCell.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 20/08/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

	@IBOutlet var categoryTitle: UILabel!
	var category: Category?
	var deleteButtonImg: UIImage?
	var deleteButton: UIButton?
	let margin:CGFloat = 10.0
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		deleteButton = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width/4, height: frame.size.width/4))
		let buttonFrame = deleteButton!.frame
		UIGraphicsBeginImageContext(buttonFrame.size)
		
		let sz:CGFloat = min(buttonFrame.size.width, buttonFrame.size.height)
		let path:UIBezierPath = UIBezierPath.init(arcCenter: CGPoint(x: buttonFrame.size.width/2, y: buttonFrame.size.height/2), radius: sz/2 - 2, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true)
		path.move(to: CGPoint(x: CGFloat(margin), y: CGFloat(margin)))
		path.addLine(to: CGPoint(x: sz - margin, y: sz-margin))
		path.move(to: CGPoint(x: margin, y: sz-margin))
		path.addLine(to: CGPoint(x: sz-margin, y: margin))
		UIColor.red.setFill()
		UIColor.white.setStroke()
		path.lineWidth = 3.0
		path.fill()
		path.stroke()
		
		deleteButtonImg = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		
		deleteButton!.setImage(deleteButtonImg, for: UIControlState())
		contentView.addSubview(deleteButton!)

	}

	
	func startQuivering() {
		let quiverAnim:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
		let startAngle:Float = (-2) * Float(M_PI)/180.0
		let stopAngle:Float = -startAngle
		let timeOffset:Float = Float((arc4random() % 100) / 100) - 0.50
		
		quiverAnim.fromValue = NSNumber(value: startAngle as Float);
		quiverAnim.toValue = NSNumber(value: 3 * stopAngle as Float);
		quiverAnim.autoreverses = true;
		quiverAnim.duration = 0.2;
		quiverAnim.repeatCount = Float.infinity;
		quiverAnim.timeOffset = CFTimeInterval(timeOffset)
		layer.add(quiverAnim, forKey: "quivering")
		
	}
	
	
	func stopQuivering() {
		layer.removeAnimation(forKey: "quivering")
	}
	
	
	func hideDeleteButton() {
		if deleteButton != nil {
			deleteButton!.layer.opacity = 0.0
		}
		stopQuivering()
	}
	
	
	func showDeleteButton() {
		if deleteButton != nil {
			deleteButton!.layer.opacity = 1.0
		}
		startQuivering()
	}
	
}
