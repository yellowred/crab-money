//
//  Period.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 13/12/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import Foundation

enum PeriodLength: Int8 {
	case month = 0
	case variable = 1
}

class Period: CustomStringConvertible {
	
	let startDate: Date
	let endDate: Date
	let lengthType: PeriodLength
	let initialDate: Date
	
	init(startDate: Date, endDate: Date, length: PeriodLength, initialDate: Date) {
		self.startDate = startDate
		self.endDate = endDate
		self.lengthType = length
		self.initialDate = initialDate
	}
	
	
	init(currentDate: Date, length:PeriodLength, initialDate: Date) {
		var calendar = Calendar.current
		calendar.timeZone = TimeZone.current
		
		let initialComponents = (calendar as NSCalendar).components([NSCalendar.Unit.day], from: initialDate)
		var currentComponents = (calendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.second, NSCalendar.Unit.minute], from: Date())

		currentComponents.day = initialComponents.day
		currentComponents.hour = 0
		currentComponents.minute = 0
		currentComponents.second = 0
		var newStartDate = calendar.date(from: currentComponents)
		if newStartDate!.compare(currentDate) == ComparisonResult.orderedDescending {
			currentComponents.year = currentComponents.month! == 1 ? currentComponents.year! - 1 : currentComponents.year
			currentComponents.month = currentComponents.month! == 1 ? 12 : currentComponents.month! - 1
			newStartDate = calendar.date(from: currentComponents)
		}
		self.startDate = newStartDate!
		self.endDate = newStartDate!.sameDayNextMonth()
		self.lengthType = length
		self.initialDate = initialDate
	}
	
	
	func getNext() -> Period? {
		guard lengthType == PeriodLength.month else {
			return nil
		}
		
		//current date is later than the period
		if Date().compare(endDate) == ComparisonResult.orderedDescending {
			return Period(startDate: endDate.addingTimeInterval(1), endDate: endDate.sameDayNextMonth(), length: lengthType, initialDate: initialDate)
		} else {
			return nil
		}
	}
	
	
	func getPrev() -> Period? {
		guard lengthType == PeriodLength.month else {
			return nil
		}
		
		if startDate.compare(initialDate) == ComparisonResult.orderedDescending {
			return Period(startDate: startDate.sameDayPrevMonth(), endDate: startDate, length: lengthType, initialDate: initialDate)
		} else {
			return nil
		}
	}
	
	var description: String {
		let calendar = Calendar.current
		let startDateCmp = (calendar as NSCalendar).components([NSCalendar.Unit.year], from: startDate)
		let endDateCmp = (calendar as NSCalendar).components([NSCalendar.Unit.year], from: endDate)
		if startDateCmp.year == endDateCmp.year {
			return startDate.periodShortFormat() + " – " + endDate.periodShortFormat() + ", " + String(describing: endDateCmp.year!)
		} else {
			return startDate.periodFormat() + " – " + endDate.periodFormat()
		}
		
	}
	
	
	func getDaysCount() -> Int {
		var calendar = Calendar.current
		calendar.timeZone = TimeZone.current

		let comp = (calendar as NSCalendar).components(NSCalendar.Unit.day, from: startDate, to: endDate, options: [])
		return comp.day!
	}
	
	
	func getDaysLeft() -> Int {
		var calendar = Calendar.current
		calendar.timeZone = TimeZone.current

		if getNext() != nil {
			let comp = (calendar as NSCalendar).components(NSCalendar.Unit.day, from: startDate, to: endDate, options: [])
			return comp.day!
		} else {
			let comp = (calendar as NSCalendar).components(NSCalendar.Unit.day, from: startDate, to: Date(), options: [])
			return comp.day! + 1
		}
	}
	
}
