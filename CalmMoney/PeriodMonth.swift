//
//  PeriodMonth.swift
//  CalmMoney
//
//  Created by Oleg Kubrakov on 28/1/2017.
//  Copyright © 2017 Oleg Kubrakov. All rights reserved.
//

import Foundation

class PeriodMonth: CustomStringConvertible {
	
	let startDate: Date
	let endDate: Date
	let initialDate: Date
	
	init(startDate: Date, endDate: Date, initialDate: Date) {
		self.startDate = startDate
		self.endDate = endDate
		self.initialDate = initialDate
	}
	
	
	init(currentDate: Date, initialDate: Date) {
		var calendar = Calendar.current
		calendar.timeZone = TimeZone.current
		
		var currentComponents = (calendar as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.second, NSCalendar.Unit.minute], from: currentDate)
		
		currentComponents.day = 1
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
		self.initialDate = initialDate
	}
	
	
	func getNext() -> PeriodMonth? {
		//current date is later than the period
		if Date().compare(endDate) == ComparisonResult.orderedDescending {
			return PeriodMonth(startDate: endDate.addingTimeInterval(1), endDate: endDate.sameDayNextMonth(), initialDate: initialDate)
		} else {
			return nil
		}
	}
	
	
	func getPrev() -> PeriodMonth? {
		if startDate.compare(initialDate) == ComparisonResult.orderedDescending {
			return PeriodMonth(startDate: startDate.sameDayPrevMonth(), endDate: startDate, initialDate: initialDate)
		} else {
			return nil
		}
	}
	
	
	var description: String {
		return startDate.periodFormat()
	}
	
	
	func getDaysCount() -> Int {
		var calendar = Calendar.current
		calendar.timeZone = TimeZone.current
		
		let comp = (calendar as NSCalendar).components(NSCalendar.Unit.day, from: startDate, to: endDate, options: [])
		return comp.day!
	}
	
	
	func getDaysPassed() -> Int {
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

