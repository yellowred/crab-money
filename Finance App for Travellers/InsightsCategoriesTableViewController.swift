//
//  InsightsCategoriesTableViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 13/12/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class InsightsCategoriesTableViewController: UITableViewController, TransactionsViewDelegate {

	fileprivate let kInsightsCategoryCellIdentifier = "InsightsCategoryCell"
	fileprivate let kShowCategoryTransactions = "ShowCategoryTransactions"
	
	var currentPeriod: Period?
	
	var expenseCategories: [Category] = []
	var earningCategories: [Category] = []
	
	var currentCategory: Category?
	var finmath: Math?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
		NotificationCenter.default.addObserver(self,
			selector: #selector(InsightsCategoriesTableViewController.onModelDataChanged(_:)),
			name: NSNotification.Name(rawValue: app().model.kNotificationDataChanged),
			object: nil)
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		tableView.reloadData()
	}
	
	
	func onModelDataChanged(_ notification: Notification){
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
		/*
		let sectionsNumber = 0
		if earningCategories.count > 0 sectionsNumber += 1
		if expenseCategories.count > 0 sectionsNumber += 1
        return sectionsNumber
		*/
		return [earningCategories.count > 0, expenseCategories.count > 0].reduce(0, {
			if $1 {
				return $0 + 1
			} else {
				return $0
			}
		})
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (section == 0 && earningCategories.count > 0) {
			return earningCategories.count
		} else {
			return expenseCategories.count
		}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: kInsightsCategoryCellIdentifier, for: indexPath) as! InsightsCategoryTableViewCell
		
		var category: Category
		if (indexPath as NSIndexPath).section == 0 && earningCategories.count > 0 {
			category = earningCategories[(indexPath as NSIndexPath).row]
		} else {
			category = expenseCategories[(indexPath as NSIndexPath).row]
		}
		cell.categoryName.text = category.name
		cell.categoryAmount.text = finmath!.getCategoryAmountForPeriod(category).formatToMoney().stringValue
		return cell
    }
	
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if (section == 0  && earningCategories.count > 0) {
			return "Earnings".localized
		} else {
			return "Expenses".localized
		}
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if (indexPath as NSIndexPath).section == 0 && earningCategories.count > 0 {
			self.currentCategory = earningCategories[(indexPath as NSIndexPath).row]
		} else {
			self.currentCategory = expenseCategories[(indexPath as NSIndexPath).row]
		}
		performSegue(withIdentifier: kShowCategoryTransactions, sender: nil)
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == kShowCategoryTransactions {
			(segue.destination as! TransactionsTableViewController).transactionsViewDelegate = self
		}
    }

}
