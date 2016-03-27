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
	case SetBudget = "SetBudget"
}

class InsightsTableViewController: UITableViewController, CurrencySelectDelegate, TransactionsViewDelegate, UIActionSheetDelegate {

	@IBOutlet var periodLabel: UILabel!

    @IBOutlet weak var expensesTotal: UILabel!
    @IBOutlet weak var expensesToday: UILabel!
    @IBOutlet weak var expensesMedian: UILabel!
    @IBOutlet weak var expensesProjected: UILabel!
    @IBOutlet weak var expensesMax: UILabel!
    
    
	@IBOutlet var earningsAmount: UILabel!
	@IBOutlet var dailyAverageEarnings: UILabel!
	@IBOutlet var nextPeriodButton: UIButton!
	@IBOutlet var prevPeriodButton: UIButton!
	@IBOutlet var homeCurrency: UILabel!
	@IBOutlet var maxTransactionAmount: UILabel!
	@IBOutlet var budgetInfoLabel: UILabel!
	@IBOutlet var budgetProgressBar: UIProgressView!
	
	var underlayingView: UIView?
	
	var currentPeriod: Period?
	var transactions: [Transaction]?
	
	var actionSheet: UIActionSheet?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		
		//app().model.createFakeTransaction()
		//app().model.saveStorage()
		
		/*
		//print transactions JSON
		var t = Array<String>()
		for trn:Transaction in app().model.getTransactionsList() {
			t.append(trn.getDict(app().model.getCurrentCurrency()) as String)
		}
		
		let tt = t.joinWithSeparator(", ")
		print(tt)
		*/
		showAll()
		
		NSNotificationCenter.defaultCenter().addObserver(self,
			selector: #selector(InsightsTableViewController.onModelDataChanged(_:)),
			name: app().model.kNotificationDataChanged,
			object: nil)
    }
	
	
	func showSummary() {
		if currentPeriod != nil {
			if self.underlayingView != nil {
				self.view = self.underlayingView
				self.underlayingView = nil
			}

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
			
			let finmath = Math(
				transactions: transactions!,
				homeCurrency: homeCurrencyObject,
				currentPeriod: currentPeriod!
			)
			
			expensesTotal.text = NSNumberFormatter().formatterDollars().stringFromNumber(finmath.expensesTotal.abs())
			expensesMedian.text = NSNumberFormatter().formatterDollars().stringFromNumber(finmath.expensesMean.abs())
			expensesProjected.text = NSNumberFormatter().formatterDollars().stringFromNumber(finmath.expensesProjected.abs())
			if (finmath.expensesMaxTransaction != nil) {
				expensesMax.text = NSNumberFormatter().formatterDollars().stringFromNumber(finmath.expensesMaxTransaction!.amount.abs())
			} else {
				expensesMax.text = "0"
			}
			expensesToday.text = NSNumberFormatter().formatterDollars().stringFromNumber(finmath.expensesToday.abs())
			
			expensesTotal.textColor = UIColor.expense()
			expensesMedian.textColor = UIColor.expense()
			expensesProjected.textColor = UIColor.expense()
			expensesMax.textColor = UIColor.expense()
			expensesToday.textColor = UIColor.expense()
			
			
			earningsAmount.text = NSNumberFormatter().formatterDollars().stringFromNumber(finmath.earningsTotal)
			dailyAverageEarnings.text = NSNumberFormatter().formatterDollars().stringFromNumber(finmath.earningsAvg)
			
			var budget = app().model.getBudget()
			if (budget.amount.isPositive()) {
				if budget.currency.code != homeCurrencyObject.code {
					budget = budget.toCurrency(homeCurrencyObject)
				}
				let budgetRemains = budget.amount.decimalNumberBySubtracting(finmath.expensesTotal)
				budgetInfoLabel.text = NSNumberFormatter().formatterMoney(budget.currency).stringFromNumber(budgetRemains.decimalNumberByRoundingAccordingToBehavior(NSDecimalNumberHandler(roundingMode: NSRoundingMode.RoundUp, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)))! + " " + "remains".localized
				let expt = finmath.expensesTotal as NSDecimalNumber
				budgetProgressBar.setProgress(expt.decimalNumberByDividingBy(budget.amount).floatValue, animated: true)
			} else {
				budgetInfoLabel.text = "Please set the budget".localized
				budgetProgressBar.setProgress(Float(0), animated: false)
			}
			budgetProgressBar.progressTintColor = UIColor.expense()
			budgetProgressBar.trackTintColor = UIColor.earning()

		} else {
			periodLabel.text = "undefined".localized
			let customView: UIView = NSBundle.mainBundle().loadNibNamed("InsightsEmptyView", owner: self, options: nil)[0] as! UIView
			if self.underlayingView == nil {
				self.underlayingView = self.view
			}
			self.view = customView
		}
	}
	
	func showAll() {
		if let initialTransaction = app().model.getIinitialTransaction() {
			currentPeriod = Period(currentDate: NSDate(), length: PeriodLength.Month, initialDate: initialTransaction.date)
		}
		homeCurrency.text = app().model.getCurrentCurrency().code.uppercaseString
		showSummary()
	}
	
	func onModelDataChanged(notification: NSNotification){
		showAll()
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
	
	
	@IBAction func saveBudget(segue:UIStoryboardSegue) {
		if let budgetDetailTVC = segue.sourceViewController as? BudgetTableViewController {
			if let budget = budgetDetailTVC.budget {
				app().model.setBudget(budget)
				showSummary()
			}
		}
	}

	
	@IBAction func shareButtonTapped(sender: AnyObject) {
		actionSheet = UIActionSheet(title: "", delegate: self, cancelButtonTitle: "Cancel".localized, destructiveButtonTitle: nil)
		actionSheet!.addButtonWithTitle("Export via File Sharing")
		actionSheet!.addButtonWithTitle("Export via Email")
	}
	
	
	func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
		if (buttonIndex == actionSheet.firstOtherButtonIndex + 0) {
			
		}
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
			(segue.destinationViewController as! TransactionsTableViewController).transactionsViewDelegate = self
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
	
	
	// MARK: - TransactionsViewDelegate
	func getTransactions() -> [Transaction] {
		guard transactions != nil else {
			return [Transaction]()
		}
		return transactions!
	}
	
	
	// MARK: - State Restoration
	override func encodeRestorableStateWithCoder(coder: NSCoder) {
		coder.encodeInteger(self.tabBarController!.selectedIndex, forKey: "TabBarCurrentTab")
		super.encodeRestorableStateWithCoder(coder)

		print("Encode state", self.tabBarController!.selectedIndex)
	}
	
	override func decodeRestorableStateWithCoder(coder: NSCoder) {
		self.tabBarController!.selectedIndex = coder.decodeIntegerForKey("TabBarCurrentTab")
		super.decodeRestorableStateWithCoder(coder)
		print("Decode state", self.tabBarController!.selectedIndex)
	}
	
}
