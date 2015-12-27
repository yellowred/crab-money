//: Playground - noun: a place where people can play

import UIKit
import CoreData

let dateFormatter = NSDateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//this your string date format
dateFormatter.timeZone = NSTimeZone.systemTimeZone()
dateFormatter.dateFromString("2015-10-15 10:31:23")
