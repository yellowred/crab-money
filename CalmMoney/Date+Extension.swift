//
//  NSDate+Extension.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 13/12/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import Foundation

extension Date {

	func sameDayNextMonth() -> Date {
		let calendar = getCalendar()
		var cmp = (calendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.second, NSCalendar.Unit.minute], from: self)
		
		cmp.year = cmp.month! == 12 ? cmp.year! + 1 : cmp.year
		cmp.month = cmp.month! == 12 ? 1 : cmp.month! + 1
		cmp.hour = 0
		cmp.minute = 0
		cmp.second = 0
		return calendar.date(from: cmp)!
	}
	
	
	func sameDayPrevMonth() -> Date {
		let calendar:Calendar = getCalendar()
		var cmp = calendar.dateComponents([.year, .month, .day, .hour, .second, .minute], from: self)
		
		cmp.year = cmp.month! == 1 ? cmp.year! - 1 : cmp.year
		cmp.month = cmp.month! == 1 ? 12 : cmp.month! - 1
		cmp.hour = 0
		cmp.minute = 0
		cmp.second = 0
		return calendar.date(from: cmp)!
	}
	
	
	func periodFormat() -> String {
		let df = DateFormatter()
		df.dateStyle = DateFormatter.Style.medium
		return df.string(from: self)
	}
	
	
	func periodShortFormat() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d MMMM"
		dateFormatter.timeZone = TimeZone.current
		return dateFormatter.string(from: self)
	}
	
	
	func transactionsSectionFormat() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d MMMM"
		dateFormatter.timeZone = TimeZone.current
		return dateFormatter.string(from: self)
	}
	
	
	func formatWithTimeLong() -> String {
		let df = DateFormatter()
		df.dateStyle = DateFormatter.Style.medium
		df.timeStyle = DateFormatter.Style.long
		return df.string(from: self)
	}
	
	func formatToHash() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyyMMdd"
		dateFormatter.timeZone = TimeZone.current
		return dateFormatter.string(from: self)
	}
	
	
	func getCalendar() -> Calendar {
		var calendar = Calendar.current
		calendar.timeZone = TimeZone.current
		return calendar
	}
	
	func fromString(_ dbDate: String) -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//this your string date format
		dateFormatter.timeZone = TimeZone.current
		return dateFormatter.date(from: dbDate)
	}
	
	func getDaysTo(_ date: Date) -> Int {
		var calendar = Calendar.current
		calendar.timeZone = TimeZone.current
		
		let comp = (calendar as NSCalendar).components(NSCalendar.Unit.day, from: self, to: date, options: [])
		return comp.day!
	}
	
	func getHoursTo(_ date: Date) -> Int {
		var calendar = Calendar.current
		calendar.timeZone = TimeZone.current
		
		let comp = (calendar as NSCalendar).components(NSCalendar.Unit.hour, from: self, to: date, options: [])
		return comp.hour!
	}
}
