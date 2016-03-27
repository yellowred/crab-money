//
//  InsightsCategoriesTableViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 13/12/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class InsightsCategoriesTableViewController: UITableViewController, TransactionsViewDelegate {

	private let kInsightsCategoryCellIdentifier = "InsightsCategoryCell"
	private let kShowCategoryTransactions = "ShowCategoryTransactions"
	
	var currentPeriod: Period?
	
	var expenseCategories: [Category] = []
	var earningCategories: [Category] = []
	
	var currentCategory: Category?
	var finmath: Math?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
		NSNotificationCenter.defaultCenter().addObserver(self,
			selector: #selector(InsightsCategoriesTableViewController.onModelDataChanged(_:)),
			name: app().model.kNotificationDataChanged,
			object: nil)
	}
	
	
	override func viewWillAppear(animated: Bool) {
		tableView.reloadData()
	}
	
	
	func onModelDataChanged(notification: NSNotification){
		loadData()
	}
	
	func loadData() {
		finmath = Math(
			transactions: app().model.getTransactionsListForPeriod(currentPeriod!),
			homeCurrency: app().model.getCurrentCurrency(),
			currentPeriod: currentPeriod!
		)
		
		earningCategories = finmath!.earningCategories
		expenseCategories = finmath!.expenseCategories
		tableView.reloadData()
	}

	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - TransactionsTVC delegate
	func getTransactions() -> [Transaction] {
		guard self.currentCategory != nil else {
			return []
		}
		return finmath!.getTransactionsForCategoryAndPeriod(self.currentCategory!)
	}
	
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return Int(earningCategories.count > 0) + Int(expenseCategories.count > 0)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (section == 0 && earningCategories.count > 0) {
			return earningCategories.count
		} else {
			return expenseCategories.count
		}
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(kInsightsCategoryCellIdentifier, forIndexPath: indexPath) as! InsightsCategoryTableViewCell
		
		var category: Category
		if indexPath.section == 0 && earningCategories.count > 0 {
			category = earningCategories[indexPath.row]
		} else {
			category = expenseCategories[indexPath.row]
		}
		cell.categoryName.text = category.name
		cell.categoryAmount.text = finmath!.getCategoryAmountForPeriod(category).formatToMoney().stringValue
		return cell
    }
	
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if (section == 0  && earningCategories.count > 0) {
			return "Earnings".localized
		} else {
			return "Expenses".localized
		}
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 && earningCategories.count > 0 {
			self.currentCategory = earningCategories[indexPath.row]
		} else {
			self.currentCategory = expenseCategories[indexPath.row]
		}
		performSegueWithIdentifier(kShowCategoryTransactions, sender: nil)
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 44
	}
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == kShowCategoryTransactions {
			(segue.destinationViewController as! TransactionsTableViewController).transactionsViewDelegate = self
		}
    }

}
