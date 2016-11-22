//: Playground - noun: a place where people can play

import UIKit

let amount = NSDecimalNumber(value: -2000)
let rate = NSDecimalNumber(value: 0.94045)
let usdAmount: NSDecimalNumber = amount.dividing(by: rate)
let ratedAmount = usdAmount.multiplying(by: rate)
let newAmount = ratedAmount.rounding(accordingToBehavior: NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.down, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false))
