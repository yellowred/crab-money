//
//  LaunchScreenView.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 30/10/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import UIKit

class LaunchScreenView: UIView {

    override func draw(_ rect: CGRect) {
		
		let linePath = UIBezierPath()
		let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
		linePath.move(to: CGPoint(x: center.x, y: center.y - 50))
		linePath.addLine(to: CGPoint(x: center.x - 50, y: center.y + 50))
		linePath.addLine(to: CGPoint(x: center.x + 50, y: center.y + 50))
		linePath.addLine(to: CGPoint(x: center.x, y: center.y - 50))
		
		let shapeLayer = CAShapeLayer()
		shapeLayer.path = linePath.cgPath
		
		//change the fill color
		shapeLayer.fillColor = UIColor.clear.cgColor
		//you can change the stroke color
		shapeLayer.strokeColor = UIColor.green.cgColor
		//you can change the line width
		shapeLayer.lineWidth = 4.0
		shapeLayer.strokeEnd = 0
		shapeLayer.draw(in: UIGraphicsGetCurrentContext()!)
    }
}
