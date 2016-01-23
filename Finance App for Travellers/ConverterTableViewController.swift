//
//  CurrenciesTableViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 22/06/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit


class ConverterTableViewController: UITableViewController, CurrencySelectDelegate
{

	let kCurrencyConverterCellHeight:CGFloat = 80
	let kCurrencyAddCellHeight:CGFloat = 60
	
    @IBOutlet var handsOnCurrenciesTableView: UITableView!

	var currenciesStructure = [HandsOnCurrency]()
	var providedAmount: Money?
	
	let kCurrencyManagableCell:String = "CurrencyManagableCell"
	let kCurrencyAddCell:String = "CurrencyAddCell"
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if providedAmount == nil {
			providedAmount = Money(amount: NSDecimalNumber(integer: 0), currency: app().model.getCurrentCurrency())
		}
		currenciesStructure = app().model.getHandsOnCurrenciesStructure(providedAmount!)
		tableView.allowsMultipleSelectionDuringEditing = false;
    }
	
	
    override func viewDidAppear(animated: Bool)
	{
        tableView.reloadData()
    }

	
    func onContentSizeChange(notification: NSNotification) {
        tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	@IBAction func amountChanged(sender: UITextField) {
		if let amountTextField = sender as? AmountTextField
		{
			if amountTextField.text!.isEmpty {
				amountTextField.text = "0"
			}
			if let handsOnCurrency:HandsOnCurrency = amountTextField.correspondingCurrency {
				handsOnCurrency.setAmount(NSDecimalNumber(string: amountTextField.text))
				providedAmount = handsOnCurrency.amount
				
				for handson in currenciesStructure {
					if handsOnCurrency.amount.currency != handson.amount.currency {
						handson.setAmount(handsOnCurrency.amount.toCurrency(handson.amount.currency).amount)
					}
				}
			}
		}
		
	}
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return currenciesStructure.count
		} else {
			return 1
		}
		
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if indexPath.section == 0 {
			let handsOnCurrency = currenciesStructure[indexPath.row]
			cell = tableView.dequeueReusableCellWithIdentifier(kCurrencyManagableCell, forIndexPath: indexPath) as! CurrencyTableViewCell
			(cell as! CurrencyTableViewCell).setHandsOnCurrency(handsOnCurrency)
			//setup structure
			handsOnCurrency.textField = (cell as! CurrencyTableViewCell).valueInput
        } else {
            let cellIdentifier = kCurrencyAddCell
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CurrencyAddTableViewCell
        }
        return cell
    }
	
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Tap currency to add transaction".localized
		} else {
			return ""
		}
	}
	
	override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		if section == 0 {
			if let lastUpdateTime = app().model.getEventTime(Networking.sharedInstance.kEventUpdateAll) {
				return "Last updated on ".localized + lastUpdateTime.formatWithTimeLong() + "."
			} else {
				return "Connect to the internet to update currency rates.".localized
			}
		} else {
			return ""
		}
	}

	
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if indexPath.section == 0 {
			return kCurrencyConverterCellHeight
		} else {
			return kCurrencyAddCellHeight
		}
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//		selectedCurrency = currenciesStructure[indexPath.row].currency
    }
	

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }



    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete
		{
			app().model.deleteCurrencyFromConverter(currenciesStructure.removeAtIndex(indexPath.row).amount.currency)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
		else if editingStyle == .Insert
		{
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
	
	
	override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
		let movedObject = currenciesStructure[sourceIndexPath.row]
		currenciesStructure.removeAtIndex(sourceIndexPath.row)
		currenciesStructure.insert(movedObject, atIndex: destinationIndexPath.row)
		// To check for correctness enable: self.tableView.reloadData()
	}


    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
		if indexPath.row < currenciesStructure.count {
			return true
		}
		return false
    }

    // MARK: - Navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "SelectCurrencyToOperate" {
			if let cell = sender as? UITableViewCell {
				let indexPath = tableView.indexPathForCell(cell)
				if let index = indexPath?.row {
					providedAmount = currenciesStructure[index].amount
				}
			}
		} else if segue.identifier == "AddAnotherCurrency" {
			(segue.destinationViewController as! AllCurrenciesTableViewController).delegate = self
		}
	}
	
	
	// MARK: - CurrencySelectDelegate
	func setCurrency(currency: Currency) {
		currenciesStructure.append(HandsOnCurrency(amount:providedAmount!.toCurrency(currency), textField: nil))
		currency.addToConverter()
		app().model.saveStorage()
		
		//update the tableView
		let indexPath = NSIndexPath(forRow: currenciesStructure.count - 1, inSection: 0)
		tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
	}
	
	
	func getCurrencyList() -> [Currency] {
		return app().model.getCurrenciesNotInConverter()
	}
	
	

	// MARK: - State Restoration
	override func encodeRestorableStateWithCoder(coder: NSCoder) {
		super.encodeRestorableStateWithCoder(coder)
		coder.encodeInteger(self.tabBarController!.selectedIndex, forKey: "TabBarCurrentTab")
		print("**** Encode state", self.tabBarController!.selectedIndex)
	}
	
	override func decodeRestorableStateWithCoder(coder: NSCoder) {
		super.decodeRestorableStateWithCoder(coder)
		self.tabBarController!.selectedIndex = coder.decodeIntegerForKey("TabBarCurrentTab")
		print("**** Decode state", self.tabBarController!.selectedIndex)
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	
	override func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeInteger(self.tabBarController!.selectedIndex, forKey: "TabBarCurrentTab")
		print("**** Encode 2 state", self.tabBarController!.selectedIndex)
	}
}
