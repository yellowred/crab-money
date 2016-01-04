//: Playground - noun: a place where people can play

import UIKit
import CoreData

let a = NSDecimalNumber(integer: -2000)
let b = a.decimalNumberByDividingBy(NSDecimalNumber(integer: 63))
let c = b.decimalNumberByMultiplyingBy(NSDecimalNumber(integer: 63), withBehavior: NSDecimalNumberHandler(roundingMode: NSRoundingMode.RoundPlain, scale: -2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false))
//let d = c.decimalNumberByRoundingAccordingToBehavior()
	
print(c)