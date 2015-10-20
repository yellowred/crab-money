//
//  GraphView.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 11/10/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView {

	var graphPoints = [Double]()
	
	@IBInspectable var startColor: UIColor = UIColor.redColor()
	@IBInspectable var endColor: UIColor = UIColor.greenColor()
		
	override func drawRect(rect: CGRect) {
		
		let width = rect.width
		let height = rect.height
		
		//set up background clipping area
		var path = UIBezierPath(roundedRect: rect,
			byRoundingCorners: UIRectCorner.AllCorners,
			cornerRadii: CGSize(width: 8.0, height: 8.0))
		path.addClip()
		
		//2 - get the current context
		let context = UIGraphicsGetCurrentContext()
		let colors = [startColor.CGColor, endColor.CGColor]
			
		//3 - set up the color space
		let colorSpace = CGColorSpaceCreateDeviceRGB()
			
		//4 - set up the color stops
		let colorLocations:[CGFloat] = [0.0, 1.0]
			
		//5 - create the gradient
		let gradient = CGGradientCreateWithColors(colorSpace,
			colors,
			colorLocations)
			
		//6 - draw the gradient
		var startPoint = CGPoint.zero
		var endPoint = CGPoint(x:0, y:self.bounds.height)
		CGContextDrawLinearGradient(context,
			gradient,
			startPoint,
			endPoint,
			CGGradientDrawingOptions(rawValue: 0)
		)
		
		
		// calculate the y point
		
		let topBorder:CGFloat = 60
		let bottomBorder:CGFloat = 50
		let margin:CGFloat = 20.0
		let graphHeight = height - topBorder - bottomBorder
		
		//calculate the x point
		if self.graphPoints.count > 0 {

			var columnXPoint = { (column:Int) -> CGFloat in
				//Calculate gap between points
				let spacer = (width - margin*2 - 4) /
					CGFloat((self.graphPoints.count - 1))
				var x:CGFloat = CGFloat(column) * spacer
				x += margin + 2
				return x
			}
			

			print("Graph points:", graphPoints)
			let maxValue = graphPoints.maxElement()
			var columnYPoint = { (graphPoint:Double) -> CGFloat in
				var y:CGFloat = CGFloat(graphPoint) /
					CGFloat(maxValue!) * graphHeight
				y = graphHeight + topBorder - y // Flip the graph
				return y
			}
			
			// draw the line graph
			
			UIColor.whiteColor().setFill()
			UIColor.whiteColor().setStroke()
			
			//set up the points line
			var graphPath = UIBezierPath()
			//go to start of line
			graphPath.moveToPoint(CGPoint(x:columnXPoint(0),
				y:columnYPoint(graphPoints[0])))
			
			//add points for each item in the graphPoints array
			//at the correct (x, y) for the point
			for i in 1..<graphPoints.count {
				let nextPoint = CGPoint(x:columnXPoint(i),
					y:columnYPoint(graphPoints[i]))
				graphPath.addLineToPoint(nextPoint)
			}
			
			graphPath.stroke()
		}
		
		//Draw horizontal graph lines on the top of everything
		var linePath = UIBezierPath()
		
		//top line
		linePath.moveToPoint(CGPoint(x:margin, y: topBorder))
		linePath.addLineToPoint(CGPoint(x: width - margin,
			y:topBorder))
		
		//center line
		linePath.moveToPoint(CGPoint(x:margin,
			y: graphHeight/2 + topBorder))
		linePath.addLineToPoint(CGPoint(x:width - margin,
			y:graphHeight/2 + topBorder))
		
		//bottom line
		linePath.moveToPoint(CGPoint(x:margin,
			y:height - bottomBorder))
		linePath.addLineToPoint(CGPoint(x:width - margin,
			y:height - bottomBorder))
		let color = UIColor(white: 1.0, alpha: 0.3)
		color.setStroke()
		
		linePath.lineWidth = 1.0
		linePath.stroke()
	}
}
