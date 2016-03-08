//
//  TransactionDetailTableViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 13/12/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class TransactionDetailTableViewController: UITableViewController, CategorySelectDelegate, CurrencySelectDelegate {

	let kEditTransactionCategory = "EditTransactionCategory"
	let kSelectCurrencyForTransactionEdit = "SelectCurrencyForTransactionEdit"
	
	var transaction: Transaction?
	
	@IBOutlet var categoryName: UILabel!
	@IBOutlet var amountValue: UITextField!
	@IBOutlet var dateValue: UIDatePicker!
	@IBOutlet var descriptionValue: UITextView!
	@IBOutlet var currencyButton: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		if transaction != nil {
			if transaction!.category != nil {
				categoryName.text = transaction!.category?.name
			} else {
				categoryName.text = "undefined".localized
			}
			amountValue.text = transaction!.amount.formatToMoney().stringValue
			dateValue.calendar = NSDate().getCalendar()
			dateValue.date = transaction!.date
			descriptionValue.text = transaction!.text
			
			let currencyCode = transaction!.currency.code.uppercaseString;
			if #available(iOS 9.0, *) {
			    currencyButton.setTitle(currencyCode, forState: UIControlState.Focused)
			}
			currencyButton.setTitle(currencyCode, forState: UIControlState.Highlighted)
			currencyButton.setTitle(currencyCode, forState: UIControlState.Normal)
			currencyButton.setTitle(currencyCode, forState: UIControlState.Selected)
			currencyButton.setTitle(currencyCode, forState: UIControlState.Reserved)
		}

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if section == 1 {
			if transaction != nil {
				let toCurrency = app().model.getCurrentCurrency()
				return NSNumberFormatter().formatterMoney(toCurrency).stringFromNumber(transaction!.getMoney().toCurrency(toCurrency).amount)
			} else {
				return ""
			}
		}
		return super.tableView(tableView, titleForFooterInSection: section)
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
		if segue.identifier == kEditTransactionCategory {
			let c = (segue.destinationViewController as! UINavigationController).topViewController as! CategoriesCollectionViewController
			c.delegate = self
		} else if segue.identifier == kSelectCurrencyForTransactionEdit {
			(segue.destinationViewController as! AllCurrenciesTableViewController).delegate = self
		}
    }
	
	
	func setCategory(category:Category) {
		if transaction != nil {
			transaction!.category = category
			categoryName.text = transaction!.category?.name
		}
	}
	
	
	func setCurrency(currency: Currency) {
		if transaction != nil {
			transaction!.currency = currency
			currencyButton.titleLabel?.text = transaction!.currency.code.uppercaseString
		}
	}
	
	func isExpense() -> Bool {
		return !transaction!.amount.isPositive()
	}
	
	func getCurrencyList() -> [Currency] {
		return app().model.getCurrenciesList()
	}
}
