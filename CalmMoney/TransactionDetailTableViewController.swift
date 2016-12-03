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
	var currencyUpd: Currency? {
		didSet {
			if self.currencyUpd != nil {
				currencyButton.setTitle(self.currencyUpd!.code.uppercased(), for: UIControlState())
			}
		}
	}
	
	var categoryUpd: Category? {
		didSet {
			if self.categoryUpd != nil {
				categoryName.text = self.categoryUpd!.name
			}
		}
	}
	
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
			currencyUpd = transaction!.currency
			categoryUpd = transaction!.category
			amountValue.text = transaction!.amount.formatToMoney().stringValue
			dateValue.calendar = Date().getCalendar()
			dateValue.date = transaction!.date as Date
			descriptionValue.text = transaction!.text
			
			let currencyCode = transaction!.currency.code.uppercased();
			if #available(iOS 9.0, *) {
			    currencyButton.setTitle(currencyCode, for: UIControlState.focused)
			}
			currencyButton.setTitle(currencyCode, for: UIControlState.highlighted)
			currencyButton.setTitle(currencyCode, for: UIControlState())
			currencyButton.setTitle(currencyCode, for: UIControlState.selected)
			currencyButton.setTitle(currencyCode, for: UIControlState.reserved)
		}

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if section == 1 {
			if transaction != nil {
				let toCurrency = app().model.getCurrentCurrency()
				return NumberFormatter().formatterMoney(toCurrency).string(from: transaction!.getMoney().toCurrency(toCurrency).amount)
			} else {
				return ""
			}
		}
		return super.tableView(tableView, titleForFooterInSection: section)
	}

	
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == kEditTransactionCategory {
			let c = (segue.destination as! UINavigationController).topViewController as! CategoriesCollectionViewController
			c.delegate = self
		} else if segue.identifier == kSelectCurrencyForTransactionEdit {
			(segue.destination as! AllCurrenciesTableViewController).delegate = self
		}
    }
	
	
	func setCategory(_ category:Category) {
		self.categoryUpd = category
	}
	
	
	func setCurrency(_ currency: Currency) {
		self.currencyUpd = currency
	}
	
	func isExpense() -> Bool {
		return !transaction!.amount.isPositive()
	}
	
	func getCurrencyList() -> [Currency] {
		return app().model.getCurrenciesList()
	}
}
