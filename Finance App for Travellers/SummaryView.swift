//
//  SummaryView.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 16/10/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class SummaryView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
	@IBOutlet weak var amount: UILabel!
	@IBOutlet weak var month: UILabel!
	@IBOutlet weak var summaryType: UILabel!
	@IBOutlet weak var graph: GraphView!

	
	func initExpenses(amountValue:Money, forDate: NSDate) {
		amount.text = amountValue.stringValue()
		//let monthComponent = NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: forDate)
		let formatter = NSDateFormatter()
		formatter.dateFormat = "MMMM"
		month.text = formatter.stringFromDate(forDate)
		summaryType.text = "expenses".localized
	}
	
	
	func initEarnings(amountValue:Money, forDate: NSDate) {
		amount.text = amountValue.stringValue()
		//let monthComponent = NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: forDate)
		let formatter = NSDateFormatter()
		formatter.dateFormat = "MMMM"
		month.text = formatter.stringFromDate(forDate)
		summaryType.text = "earnings".localized
	}
	
	
	func initBudget(amountValue:Money, forDate: NSDate) {
		amount.text = amountValue.stringValue()
		//let monthComponent = NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: forDate)
		let formatter = NSDateFormatter()
		formatter.dateFormat = "MMMM"
		month.text = formatter.stringFromDate(forDate)
		summaryType.text = "budget".localized
	}
}
