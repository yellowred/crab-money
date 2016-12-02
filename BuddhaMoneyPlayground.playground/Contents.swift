//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport


let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 375.0, height: 667.0))
containerView.backgroundColor = UIColor.white
PlaygroundPage.current.liveView = containerView


// Circle
let circlePath = UIBezierPath(arcCenter: CGPoint(x: 100,y: 100), radius: CGFloat(50), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)

let shapeLayer = CAShapeLayer()
shapeLayer.path = circlePath.cgPath

//change the fill color
shapeLayer.fillColor = UIColor.clear.cgColor
//you can change the stroke color
shapeLayer.strokeColor = UIColor.gray.cgColor
//you can change the line width
shapeLayer.lineWidth = 2.0
shapeLayer.strokeEnd = 0.0
containerView.layer.addSublayer(shapeLayer)

let animation = CABasicAnimation(keyPath: "strokeEnd")
animation.duration = 1
animation.fromValue = 0
animation.toValue = 1
animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
shapeLayer.strokeEnd = 1.0
shapeLayer.add(animation, forKey: "animateCircle")


// OK
let linePath = UIBezierPath()
linePath.move(to: CGPoint(x: 128, y: 85))
linePath.addLine(to: CGPoint(x: 95, y: 117))
linePath.addLine(to: CGPoint(x: 75, y: 95))

let shapeLayer2 = CAShapeLayer()
shapeLayer2.path = linePath.cgPath

//change the fill color
shapeLayer2.fillColor = UIColor.clear.cgColor
//you can change the stroke color
shapeLayer2.strokeColor = UIColor.gray.cgColor
//you can change the line width
shapeLayer2.lineWidth = 4.0
shapeLayer2.strokeEnd = 0
containerView.layer.addSublayer(shapeLayer2)

/*
let animation2 = CABasicAnimation(keyPath: "strokeEnd")
animation2.duration = 1
animation2.fromValue = 0
animation2.toValue = 1
animation2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
shapeLayer2.strokeEnd = 1.0
// shapeLayer2.add(animation, forKey: "animateLine")
*/

UIView.animate(withDuration: 1, delay: 1, animations: {
    shapeLayer2.strokeEnd = 1
    }, completion: nil)


let num:CGPoint? = nil
if num?.x != 100 {
    print("He")
} else {
    print("Ho")
}