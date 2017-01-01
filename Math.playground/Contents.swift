//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let a = NSDecimalNumber(value: 0)
let b = NSDecimalNumber(string: "abba")
if b == NSDecimalNumber.notANumber {
    print("Not a number")
}
//  a.adding(NSDecimalNumber.notANumber)

let usdAmount: NSDecimalNumber = NSDecimalNumber(string: "100").dividing(by: 1)
let currencyAmount = usdAmount.multiplying(by: NSDecimalNumber.notANumber, withBehavior: NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false))
// currencyAmount.adding(100)


