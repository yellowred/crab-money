//
//  CurrenciesTableViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 22/06/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit


class CurrenciesTableViewController: UITableViewController, UITableViewDataSource
{

    @IBOutlet var handsOnCurrenciesTableView: UITableView!

    lazy var model: CurrencyModel = {return CurrencyModel()}()
	var currenciesStructure = [HandsOnCurrency]()
	var providedAmount: Money = {return Money(amount: 0, currency: CurrencyModel().getCurrentCurrency()!)}()
	
	let kCurrencyManagableCell:String = "CurrencyManagableCell"
	let kCurrencyAddCell:String = "CurrencyAddCell"
	
    override func viewDidLoad() {
        super.viewDidLoad()
		currenciesStructure = model.getHandsOnCurrenciesStructure(providedAmount)
		tableView.allowsMultipleSelectionDuringEditing = false;
		//tableView.editing = true
        /*
        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableViewAutomaticDimension

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "onContentSizeChange:",
            name: UIContentSizeCategoryDidChangeNotification,
            object: nil)
        */
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

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return currenciesStructure.count + 1;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if indexPath.row < currenciesStructure.count {
            cell = tableView.dequeueReusableCellWithIdentifier(kCurrencyManagableCell, forIndexPath: indexPath) as! CurrencyTableViewCell
			
			let handsOnCurrency = currenciesStructure[indexPath.row]
			println("Added handsOnCurrency: \(handsOnCurrency)")
			
            (cell as! CurrencyTableViewCell).currencyCode.text = handsOnCurrency.amount.currency.code.uppercaseString
			(cell as! CurrencyTableViewCell).flag.image = handsOnCurrency.amount.currency.getFlag()
			(cell as! CurrencyTableViewCell).valueInput.text = handsOnCurrency.amount.amount.stringValue
			((cell as! CurrencyTableViewCell).valueInput as! AmountTextField).correspondingCurrency = handsOnCurrency
			
			//setup structure
			handsOnCurrency.textField = (cell as! CurrencyTableViewCell).valueInput
        } else {
            let cellIdentifier = kCurrencyAddCell
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CurrencyAddTableViewCell
        }
        return cell
    }
    
	@IBAction func amountChanged(sender: UITextField) {
		if let amountTextField = sender as? AmountTextField
		{
			if let handsOnCurrency:HandsOnCurrency = amountTextField.correspondingCurrency {
				providedAmount = handsOnCurrency.amount

				for handson in currenciesStructure {
					if handsOnCurrency.amount.currency != handson.amount.currency {
						handson.setAmount(handsOnCurrency.amount.toCurrency(handson.amount.currency).amount)
					}
				}
			}
		}
		
	}
	
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//		selectedCurrency = currenciesStructure[indexPath.row].currency
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SelectCurrencyToOperate" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                if let index = indexPath?.row {
					providedAmount = currenciesStructure[index].amount
                }
            }
        }
    }
	
	

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }



    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete
		{
			model.deleteHandsOnCurrencyByCurrency(currenciesStructure.removeAtIndex(indexPath.row).amount.currency)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

	
	@IBAction func saveCurrencyToHandsOnCollection(segue:UIStoryboardSegue)
	{
		if let allCurrenciesTableViewController = segue.sourceViewController as? AllCurrenciesTableViewController
		{
			println("Selected currency: \(allCurrenciesTableViewController.selectedCurrency)")
			
			if let currencyToAdd:Currency = allCurrenciesTableViewController.selectedCurrency
			{
				currenciesStructure.append(HandsOnCurrency(amount:providedAmount.toCurrency(currencyToAdd), textField: nil))
				model.addCurrencyToHandsOnList(currencyToAdd)
				model.saveStorage()

				//update the tableView
				let indexPath = NSIndexPath(forRow: currenciesStructure.count-1, inSection: 0)
				tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
			}
		}
	}
}
