//
//  InsightsTableViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 12/12/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit
//	import Crashlytics

enum InsightsSegues: String {
	case ShowTransactions = "ShowTransactions"
	case ShowCategories = "ShowCategories"
	case SelectHomeCurrency = "SelectHomeCurrency"
	case SetBudget = "SetBudget"
}

class InsightsTableViewController: UITableViewController, CurrencySelectDelegate, TransactionsViewDelegate, UIActionSheetDelegate {

	@IBOutlet var periodLabel: UILabel!

	@IBOutlet weak var expensesTitle: UILabel!
    @IBOutlet weak var expensesTotal: UILabel!
    @IBOutlet weak var expensesToday: UILabel!
    @IBOutlet weak var expensesMedian: UILabel!
    @IBOutlet weak var expensesProjected: UILabel!
    @IBOutlet weak var expensesMax: UILabel!
    
    
	@IBOutlet weak var earningsTitle: UILabel!
	@IBOutlet weak var earningsTotal: UILabel!
	@IBOutlet weak var earningsAverage: UILabel!
	
	@IBOutlet var nextPeriodButton: UIButton!
	@IBOutlet var prevPeriodButton: UIButton!
	@IBOutlet var homeCurrency: UILabel!
	@IBOutlet var budgetInfoLabel: UILabel!
	@IBOutlet var budgetProgressBar: UIProgressView!
	
	var underlayingView: UIView?
	
	var currentPeriod: Period?
	var transactions: [Transaction]?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		showAll()
		
		/*
		//	Crashlitycs
		let button = UIButton(type: UIButtonType.roundedRect)
		button.frame = CGRect.init(x: 20, y: 50, width: 100, height: 30)
		button.setTitle("Crash", for: UIControlState.normal)
		button.addTarget(self, action: #selector(self.crashButtonTapped(sender:)), for: UIControlEvents.touchUpInside)
		view.addSubview(button)
		*/
		
		NotificationCenter.default.addObserver(self,
			selector: #selector(InsightsTableViewController.onModelDataChanged(_:)),
			name: NSNotification.Name(rawValue: app().model.kNotificationDataChanged),
			object: nil)
    }
	
	/*
	@IBAction func crashButtonTapped(sender: AnyObject) {
		Crashlytics.sharedInstance().crash()
	}
	*/
	
	func showSummary() {
		if currentPeriod != nil {
			if self.underlayingView != nil {
				self.view = self.underlayingView
				self.underlayingView = nil
			}

			periodLabel.text = currentPeriod?.description
			if currentPeriod?.getNext() == nil {
				nextPeriodButton.isEnabled = false
			} else {
				nextPeriodButton.isEnabled = true
			}
			if currentPeriod?.getPrev() == nil {
				prevPeriodButton.isEnabled = false
			} else {
				prevPeriodButton.isEnabled = true
			}
			transactions = app().model.getTransactionsListForPeriod(currentPeriod!)
			let homeCurrencyObject = app().model.getCurrentCurrency()
			
			let finmath = Math(
				transactions: transactions!,
				homeCurrency: homeCurrencyObject,
				currentPeriod: currentPeriod!
			)
			
			expensesTotal.text = NumberFormatter().formatterDollars().string(from: finmath.expensesTotal.abs())
			expensesMedian.text = NumberFormatter().formatterDollars().string(from: finmath.expensesMedian.abs())
			expensesProjected.text = NumberFormatter().formatterDollars().string(from: finmath.expensesProjected.abs())
			if let maxTrn = finmath.expensesMaxTransaction {
				expensesMax.text = NumberFormatter().formatterDollars().string(from: finmath.getMoneyInCurrencyWithHistoryRate(maxTrn, currency: homeCurrencyObject).amount.abs())
			} else {
				expensesMax.text = "0"
			}
			expensesToday.text = NumberFormatter().formatterDollars().string(from: finmath.expensesToday.abs())
			
			/*
			expensesTotal.textColor = UIColor.expense()
			expensesMedian.textColor = UIColor.expense()
			expensesProjected.textColor = UIColor.expense()
			expensesMax.textColor = UIColor.expense()
			expensesToday.textColor = UIColor.expense()
			*/
			expensesTitle.textColor = UIColor.expense()
			earningsTitle.textColor = UIColor.earning()
			
			
			earningsTotal.text = NumberFormatter().formatterDollars().string(from: finmath.earningsTotal)
			earningsAverage.text = NumberFormatter().formatterDollars().string(from: finmath.earningsAvg)
			
			var budget = app().model.getBudget()
			if (budget.amount.isPositive()) {
				if budget.currency.code != homeCurrencyObject.code {
					budget = budget.toCurrency(homeCurrencyObject)
				}
				let budgetRemains = budget.amount.subtracting(finmath.expensesTotal)
				budgetInfoLabel.text = NumberFormatter().formatterMoney(budget.currency).string(from: budgetRemains.rounding(accordingToBehavior: NSDecimalNumberHandler(roundingMode: NSDecimalNumber.RoundingMode.up, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)))! + " " + "remains".localized
				let expt = finmath.expensesTotal as NSDecimalNumber
				budgetProgressBar.setProgress(expt.dividing(by: budget.amount).floatValue, animated: true)
			} else {
				budgetInfoLabel.text = "Please set the budget".localized
				budgetProgressBar.setProgress(Float(0), animated: false)
			}
			budgetProgressBar.progressTintColor = UIColor.expense()
			budgetProgressBar.trackTintColor = UIColor.earning()

		} else {
			periodLabel.text = "undefined".localized
			let customView: UIView = Bundle.main.loadNibNamed("InsightsEmptyView", owner: self, options: nil)![0] as! UIView
			if self.underlayingView == nil {
				self.underlayingView = self.view
			}
			self.view = customView
		}
	}
	
	func showAll() {
		//	recalc period as it may be affected if initial transaction was removed
		if let initialTransaction = app().model.getIinitialTransaction() {
			if currentPeriod?.initialDate != initialTransaction.date {
				currentPeriod = Period(currentDate: Date(), length: PeriodLength.month, initialDate: initialTransaction.date)
			}
		}
		homeCurrency.text = app().model.getCurrentCurrency().code.uppercased()
		showSummary()
	}
	
	func onModelDataChanged(_ notification: Notification){
		showAll()
	}
	
	@IBAction func changePeriod(_ sender: UIButton) {
		if sender.tag == 21 && currentPeriod?.getPrev() != nil {
			currentPeriod = currentPeriod?.getPrev()
		} else if currentPeriod?.getNext() != nil {
			currentPeriod = currentPeriod?.getNext()
		}
		showSummary()
	}
	
	@IBAction func periodSwipeRight(_ sender: UISwipeGestureRecognizer) {
		if currentPeriod?.getPrev() != nil {
			currentPeriod = currentPeriod?.getPrev()
		}
		showSummary()
	}
	
	@IBAction func periodSwipeLeft(_ sender: UISwipeGestureRecognizer) {
		if currentPeriod?.getNext() != nil {
			currentPeriod = currentPeriod?.getNext()
		}
		showSummary()
	}
	
	
	@IBAction func saveBudget(_ segue:UIStoryboardSegue) {
		if let budgetDetailTVC = segue.source as? BudgetTableViewController {
			if let budget = budgetDetailTVC.budget {
				app().model.setBudget(budget)
				showSummary()
			}
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == InsightsSegues.ShowTransactions.rawValue {
			(segue.destination as! TransactionsTableViewController).transactionsViewDelegate = self
		} else if segue.identifier == InsightsSegues.ShowCategories.rawValue {
			(segue.destination as! InsightsCategoriesTableViewController).currentPeriod = currentPeriod
		} else if segue.identifier == InsightsSegues.SelectHomeCurrency.rawValue {
			(segue.destination as! AllCurrenciesTableViewController).delegate = self
		}
    }

	
    // MARK: - CurrencySelectDelegate
	func setCurrency(_ currency: Currency) {
		if currency.code != app().model.getCurrentCurrency().code {
			app().model.setCurrentCurrency(currency)
			homeCurrency.text = currency.code.uppercased()
			showSummary()
		}
	}
	
	
	func getCurrencyList() -> [Currency] {
		print("Currencies", app().model.getCurrenciesList().count)
		return app().model.getCurrenciesList()
	}
	
	
	// MARK: - TransactionsViewDelegate
	func getTransactions() -> [Transaction] {
		transactions = app().model.getTransactionsListForPeriod(currentPeriod!)
		guard transactions != nil else {
			return [Transaction]()
		}
		return transactions!
	}
	
	
	// MARK: - State Restoration
	override func encodeRestorableState(with coder: NSCoder) {
		coder.encode(self.tabBarController!.selectedIndex, forKey: "TabBarCurrentTab")
		super.encodeRestorableState(with: coder)

		print("Encode state", self.tabBarController!.selectedIndex)
	}
	
	override func decodeRestorableState(with coder: NSCoder) {
		self.tabBarController!.selectedIndex = coder.decodeInteger(forKey: "TabBarCurrentTab")
		super.decodeRestorableState(with: coder)
		print("Decode state", self.tabBarController!.selectedIndex)
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if (indexPath.section == 5) {
			return 60
		} else {
			return UITableViewAutomaticDimension
		}
	}
}
