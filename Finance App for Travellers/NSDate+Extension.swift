//
//  NSDate+Extension.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 13/12/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import Foundation

extension NSDate {

	func sameDayNextMonth() -> NSDate {
		let calendar = getCalendar()
		let cmp = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Second, NSCalendarUnit.Minute], fromDate: self)
		
		cmp.year = cmp.month == 12 ? cmp.year + 1 : cmp.year
		cmp.month = cmp.month == 12 ? 1 : cmp.month + 1
		cmp.hour = 0
		cmp.minute = 0
		cmp.second = 0
		return calendar.dateFromComponents(cmp)!
	}
	
	
	func sameDayPrevMonth() -> NSDate {
		let calendar = getCalendar()
		let cmp = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Second, NSCalendarUnit.Minute], fromDate: self)
		
		cmp.year = cmp.month == 1 ? cmp.year - 1 : cmp.year
		cmp.month = cmp.month == 1 ? 12 : cmp.month - 1
		cmp.hour = 0
		cmp.minute = 0
		cmp.second = 0
		return calendar.dateFromComponents(cmp)!
	}
	
	
	func periodFormat() -> String {
		let df = NSDateFormatter()
		df.dateStyle = NSDateFormatterStyle.MediumStyle
		return df.stringFromDate(self)
	}
	
	func getCalendar() -> NSCalendar {
		let calendar = NSCalendar.currentCalendar()
		calendar.timeZone = NSTimeZone.systemTimeZone()
		return calendar
	}
	
	func fromString(dbDate: String) -> NSDate? {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//this your string date format
		dateFormatter.timeZone = NSTimeZone.systemTimeZone()
		return dateFormatter.dateFromString(dbDate)
	}
	
	func getDaysTo(date: NSDate) -> Int {
		let calendar = NSCalendar.currentCalendar()
		calendar.timeZone = NSTimeZone.systemTimeZone()
		
		let comp = calendar.components(NSCalendarUnit.Day, fromDate: self, toDate: date, options: [])
		return comp.day
	}
}