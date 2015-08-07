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
    var currencies = [Currency]()
	
    var selectedCurrency: Currency?
	var providedAmount: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
		currencies = model.getHandsOnCurrenciesList()
		tableView.allowsMultipleSelectionDuringEditing = false;
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
		return currencies.count + 1;
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if indexPath.row < currencies.count {
            let cellIdentifier = "CurrencyManagableCell"
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CurrencyTableViewCell
            let currency = currencies[indexPath.row]
            (cell as! CurrencyTableViewCell).currencyCode.text = currency.code.uppercaseString
			(cell as! CurrencyTableViewCell).flag.image = currency.getFlag()
			println("Provided amount: \(providedAmount)")
			if providedAmount.isEmpty || selectedCurrency == nil {
				providedAmount = "0"
			}
			else
			{
				let decimalAmount = NSDecimalNumber(string: providedAmount)
				providedAmount = model.convertAmount(decimalAmount,	fromCurrency: selectedCurrency!, toCurrency: currency).stringValue
			}
			
			(cell as! CurrencyTableViewCell).valueInput.text = providedAmount
        } else {
            let cellIdentifier = "CurrencyAddCell"
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CurrencyAddTableViewCell
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
		selectedCurrency = currencies[indexPath.row]
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SelectCurrencyToOperate" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                if let index = indexPath?.row {
                    selectedCurrency = currencies[index]
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
			model.deleteHandsOnCurrencyByCurrency(currencies.removeAtIndex(indexPath.row))
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
		else if editingStyle == .Insert
		{
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

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
				currencies.append(currencyToAdd)
				model.addCurrencyToHandsOnList(currencyToAdd)
				model.saveStorage()

				//update the tableView
				let indexPath = NSIndexPath(forRow: currencies.count-1, inSection: 0)
				tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
			}
		}
	}
}
