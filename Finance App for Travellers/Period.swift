//
//  Period.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 13/12/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import Foundation

enum PeriodLength: Int8 {
	case Month = 0
	case Variable = 1
}

class Period: CustomStringConvertible {
	
	let startDate: NSDate
	let endDate: NSDate
	let lengthType: PeriodLength
	let initialDate: NSDate
	
	init(startDate: NSDate, endDate: NSDate, length: PeriodLength, initialDate: NSDate) {
		self.startDate = startDate
		self.endDate = endDate
		self.lengthType = length
		self.initialDate = initialDate
	}
	
	
	init(currentDate: NSDate, length:PeriodLength, initialDate: NSDate) {
		let calendar = NSCalendar.currentCalendar()
		calendar.timeZone = NSTimeZone.systemTimeZone()
		
		let initialComponents = calendar.components([NSCalendarUnit.Day], fromDate: initialDate)
		let currentComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Second, NSCalendarUnit.Minute], fromDate: NSDate())

		currentComponents.day = initialComponents.day
		currentComponents.hour = 0
		currentComponents.minute = 0
		currentComponents.second = 0
		var newStartDate = calendar.dateFromComponents(currentComponents)
		if newStartDate!.compare(currentDate) == NSComparisonResult.OrderedDescending {
			currentComponents.year = currentComponents.month == 1 ? currentComponents.year - 1 : currentComponents.year
			currentComponents.month = currentComponents.month == 1 ? 12 : currentComponents.month - 1
			newStartDate = calendar.dateFromComponents(currentComponents)
		}
		self.startDate = newStartDate!
		self.endDate = newStartDate!.sameDayNextMonth()
		self.lengthType = length
		self.initialDate = initialDate
	}
	
	
	func getNext() -> Period? {
		guard lengthType == PeriodLength.Month else {
			return nil
		}
		
		//current date is later than the period
		if NSDate().compare(endDate) == NSComparisonResult.OrderedDescending {
			return Period(startDate: endDate.dateByAddingTimeInterval(3600 * 24), endDate: endDate.sameDayNextMonth(), length: lengthType, initialDate: initialDate)
		} else {
			return nil
		}
	}
	
	
	func getPrev() -> Period? {
		guard lengthType == PeriodLength.Month else {
			return nil
		}
		
		if startDate.compare(initialDate) == NSComparisonResult.OrderedDescending {
			return Period(startDate: startDate.sameDayPrevMonth(), endDate: startDate.dateByAddingTimeInterval(-3600 * 24), length: lengthType, initialDate: initialDate)
		} else {
			return nil
		}
	}
	
	var description: String {
		let calendar = NSCalendar.currentCalendar()
		let startDateCmp = calendar.components([NSCalendarUnit.Year], fromDate: startDate)
		let endDateCmp = calendar.components([NSCalendarUnit.Year], fromDate: endDate)
		if startDateCmp.year == endDateCmp.year {
			return startDate.periodShortFormat() + " – " + endDate.periodShortFormat() + ", " + String(endDateCmp.year)
		} else {
			return startDate.periodFormat() + " – " + endDate.periodFormat()
		}
		
	}
	
	
	func getDaysCount() -> Int {
		let calendar = NSCalendar.currentCalendar()
		calendar.timeZone = NSTimeZone.systemTimeZone()

		let comp = calendar.components(NSCalendarUnit.Day, fromDate: startDate, toDate: endDate, options: [])
		return comp.day
	}
	
	
	func getDaysLeft() -> Int {
		let calendar = NSCalendar.currentCalendar()
		calendar.timeZone = NSTimeZone.systemTimeZone()

		if getNext() != nil {
			let comp = calendar.components(NSCalendarUnit.Day, fromDate: startDate, toDate: endDate, options: [])
			return comp.day
		} else {
			let comp = calendar.components(NSCalendarUnit.Day, fromDate: startDate, toDate: NSDate(), options: [])
			return comp.day + 1
		}
	}
	
}