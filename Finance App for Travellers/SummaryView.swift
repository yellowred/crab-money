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
	@IBOutlet weak var graph: GraphView!

	
	func initExpenses(forDate: NSDate, transactions: [Transaction], currency: Currency) {
		let expenses: [Transaction] = transactions.filter {
			(x : Transaction) -> Bool in
			if x.amount.compare(NSDecimalNumber.zero()) == NSComparisonResult.OrderedAscending {
				return true
			}
			return false
		}
		initCommonData(forDate, transactions: expenses, currency: currency)
		//summaryType.text = "expenses".localized
	}
	
	
	func initEarnings(forDate: NSDate, transactions: [Transaction], currency: Currency) {
		let earnings: [Transaction] = transactions.filter {
			(x : Transaction) -> Bool in
			if x.amount.compare(NSDecimalNumber.zero()) == NSComparisonResult.OrderedDescending {
				return true
			}
			return false
		}
		initCommonData(forDate, transactions: earnings, currency: currency)
		//summaryType.text = "earnings".localized
	}
	
	
	func initBudget(forDate: NSDate, transactions: [Transaction], currency: Currency) {
		let expenses: [Transaction] = transactions.filter {
			(x : Transaction) -> Bool in
			if x.amount.compare(NSDecimalNumber.zero()) == NSComparisonResult.OrderedAscending {
				return true
			}
			return false
		}
		initCommonData(forDate, transactions: expenses, currency: currency)
		//summaryType.text = "budget".localized
	}
	
	
	func initCommonData(forDate: NSDate, transactions: [Transaction], currency: Currency) {
		let normalizedTransactionValues = transactions.map {$0.getMoney().toCurrency(currency).amount.doubleValue}
		//let total = NSDecimalNumber(double: normalizedTransactionValues.reduce(0, combine: + ))
		graph.graphPoints = normalizedTransactionValues.map {fabs($0)}

		//amount.text = NSNumberFormatter().formatterMoney(currency).stringFromNumber(total)
		let formatter = NSDateFormatter()
		formatter.dateFormat = "MMMM"
		//month.text = formatter.stringFromDate(forDate)
	}

	
	func initBlock(type: String, forDate: NSDate, transactions: [Transaction], currency: Currency) {
		if (type == "expenses") {
			initExpenses(NSDate(), transactions: transactions, currency: currency)
			
		} else if type == "earnings" {
			initEarnings(NSDate(), transactions: transactions, currency: currency)
			
		} else {
			initBudget(NSDate(), transactions: transactions, currency: currency)
			
		}
	}

}
