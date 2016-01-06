//
//  InsightsTableViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 12/12/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

enum InsightsSegues: String {
	case ShowTransactions = "ShowTransactions"
	case ShowCategories = "ShowCategories"
	case SelectHomeCurrency = "SelectHomeCurrency"
}

class InsightsTableViewController: UITableViewController, CurrencySelectDelegate {

	@IBOutlet var periodLabel: UILabel!
	@IBOutlet var expensesAmount: UILabel!
	@IBOutlet var dailyAverageAmount: UILabel!
	@IBOutlet var expectedAmount: UILabel!
	@IBOutlet var earningsAmount: UILabel!
	@IBOutlet var dailyAverageEarnings: UILabel!
	@IBOutlet var nextPeriodButton: UIButton!
	@IBOutlet var prevPeriodButton: UIButton!
	@IBOutlet var homeCurrency: UILabel!
	
	var currentPeriod: Period?
	var transactions: [Transaction]?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		
		//app().model.createFakeTransaction()
		app().model.saveStorage()
		if let initialTransaction = app().model.getIinitialTransaction() {
			currentPeriod = Period(currentDate: NSDate(), length: PeriodLength.Month, initialDate: initialTransaction.date)
		}
		homeCurrency.text = app().model.getCurrentCurrency().code.uppercaseString
		showSummary()
    }
	
	
	func showSummary() {
		if currentPeriod != nil {
			periodLabel.text = currentPeriod?.description
			if currentPeriod?.getNext() == nil {
				nextPeriodButton.enabled = false
			} else {
				nextPeriodButton.enabled = true
			}
			if currentPeriod?.getPrev() == nil {
				prevPeriodButton.enabled = false
			} else {
				prevPeriodButton.enabled = true
			}
			transactions = app().model.getTransactionsListForPeriod(currentPeriod!)
			let homeCurrencyObject = app().model.getCurrentCurrency()
			let expenses: [Transaction] = transactions!.filter {
				(x : Transaction) -> Bool in
				if x.amount.compare(NSDecimalNumber.zero()) == NSComparisonResult.OrderedAscending {
					return true
				}
				return false
			}
			let expensesTotal = expenses.reduce(0, combine: {return $1.getStaticValueInCurrency(homeCurrencyObject).amount.decimalNumberByAdding($0)}).abs()
			expensesAmount.text = NSNumberFormatter().formatterDollars().stringFromNumber(expensesTotal)
			
			let expensesAvg = expenses.count > 0 ? expensesTotal.decimalNumberByDividingBy(NSDecimalNumber(integer: expenses.count)) : NSDecimalNumber(integer: 0)
			dailyAverageAmount.text = NSNumberFormatter().formatterDollars().stringFromNumber(expensesAvg)
			
			let expensesExpected = expensesAvg.decimalNumberByMultiplyingBy(NSDecimalNumber(integer: currentPeriod!.getDaysCount()))
			expectedAmount.text = NSNumberFormatter().formatterDollars().stringFromNumber(expensesExpected)
			
			
			let earnings: [Transaction] = transactions!.filter {
				(x : Transaction) -> Bool in
				if x.amount.compare(NSDecimalNumber.zero()) == NSComparisonResult.OrderedDescending {
					return true
				}
				return false
			}
			let earningsTotal = earnings.reduce(0, combine: {return $1.getStaticValueInCurrency(homeCurrencyObject).amount.decimalNumberByAdding($0)}).abs()
			earningsAmount.text = NSNumberFormatter().formatterDollars().stringFromNumber(earningsTotal)
			
			let earningsAvg = earnings.count > 0 ? earningsTotal.decimalNumberByDividingBy(NSDecimalNumber(integer: earnings.count)) : NSDecimalNumber(integer: 0)
			dailyAverageAmount.text = NSNumberFormatter().formatterDollars().stringFromNumber(expensesAvg)

		} else {
			periodLabel.text = "undefined".localized
		}
	}
	
	@IBAction func changePeriod(sender: UIButton) {
		if sender.tag == 21 && currentPeriod?.getPrev() != nil {
			currentPeriod = currentPeriod?.getPrev()
		} else if currentPeriod?.getNext() != nil {
			currentPeriod = currentPeriod?.getNext()
		}
		showSummary()
	}
	
	@IBAction func periodSwipeRight(sender: UISwipeGestureRecognizer) {
		if currentPeriod?.getPrev() != nil {
			currentPeriod = currentPeriod?.getPrev()
		}
		showSummary()
	}
	
	@IBAction func periodSwipeLeft(sender: UISwipeGestureRecognizer) {
		if currentPeriod?.getNext() != nil {
			currentPeriod = currentPeriod?.getNext()
		}
		showSummary()
	}
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == InsightsSegues.ShowTransactions.rawValue {
			(segue.destinationViewController as! TransactionsTableViewController).currentPeriod = currentPeriod
		} else if segue.identifier == InsightsSegues.ShowCategories.rawValue {
			(segue.destinationViewController as! InsightsCategoriesTableViewController).currentPeriod = currentPeriod
		} else if segue.identifier == InsightsSegues.SelectHomeCurrency.rawValue {
			(segue.destinationViewController as! AllCurrenciesTableViewController).delegate = self
		}
    }

	
    // MARK: - CurrencySelectDelegate
	func setCurrency(currency: Currency) {
		if currency.code != app().model.getCurrentCurrency().code {
			app().model.setCurrentCurrency(currency)
			homeCurrency.text = currency.code.uppercaseString
			showSummary()
		}
	}
	
	
	func getCurrencyList() -> [Currency] {
		return app().model.getCurrenciesList()
	}
}
