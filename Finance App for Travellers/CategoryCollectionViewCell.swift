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

		deleteButton = UIButton(frame: CGRectMake(0, 0, frame.size.width/4, frame.size.width/4))
		let buttonFrame = deleteButton!.frame
		UIGraphicsBeginImageContext(buttonFrame.size)
		
		let sz:CGFloat = min(buttonFrame.size.width, buttonFrame.size.height)
		let path:UIBezierPath = UIBezierPath.init(arcCenter: CGPointMake(buttonFrame.size.width/2, buttonFrame.size.height/2), radius: sz/2 - 2, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true)
		path.moveToPoint(CGPointMake(CGFloat(margin), CGFloat(margin)))
		path.addLineToPoint(CGPointMake(sz - margin, sz-margin))
		path.moveToPoint(CGPointMake(margin, sz-margin))
		path.addLineToPoint(CGPointMake(sz-margin, margin))
		UIColor.redColor().setFill()
		UIColor.whiteColor().setStroke()
		path.lineWidth = 3.0
		path.fill()
		path.stroke()
		
		deleteButtonImg = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		
		deleteButton!.setImage(deleteButtonImg, forState: UIControlState.Normal)
		contentView.addSubview(deleteButton!)

	}

	
	func startQuivering() {
		let quiverAnim:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
		let startAngle:Float = (-2) * Float(M_PI)/180.0
		let stopAngle:Float = -startAngle
		let timeOffset:Float = Float((arc4random() % 100) / 100) - 0.50
		
		quiverAnim.fromValue = NSNumber(float: startAngle);
		quiverAnim.toValue = NSNumber(float: 3 * stopAngle);
		quiverAnim.autoreverses = true;
		quiverAnim.duration = 0.2;
		quiverAnim.repeatCount = Float.infinity;
		quiverAnim.timeOffset = CFTimeInterval(timeOffset)
		layer.addAnimation(quiverAnim, forKey: "quivering")
		
	}
	
	
	func stopQuivering() {
		layer.removeAnimationForKey("quivering")
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
