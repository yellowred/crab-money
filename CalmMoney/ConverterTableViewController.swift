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
			providedAmount = Money(amount: NSDecimalNumber(value: 0 as Int), currency: app().model.getCurrentCurrency())
		}
		currenciesStructure = app().model.getHandsOnCurrenciesStructure(providedAmount!)
		tableView.allowsMultipleSelectionDuringEditing = false;

		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ConverterTableViewController.dismissKeyboard))
		view.addGestureRecognizer(tap)
		
	}
	
	//Calls this function when the tap is recognized.
	func dismissKeyboard() {
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		view.endEditing(true)
	}
	
	
	override func viewDidAppear(_ animated: Bool)
	{
        tableView.reloadData()
		checkPurchase()

    }

	
	func checkPurchase() {
		if !Purchase.canUseConverter() {
			currenciesStructure = app().model.getHandsOnCurrenciesStructureFake(providedAmount!)
			
			var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
			if #available(iOS 10.0, *) {
				blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
			}
			let blurEffectView = UIVisualEffectView(effect: blurEffect)
			blurEffectView.frame = view.bounds
			blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			view.addSubview(blurEffectView)
			
			let customView: UIView = Bundle.main.loadNibNamed("ConverterNotPurchased", owner: self, options: nil)![0] as! UIView
			customView.frame = view.frame
			//customView.updateConstraintsIfNeeded()
			self.view.addSubview(customView)
		}
	}
	
    func onContentSizeChange(_ notification: Notification) {
        tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	@IBAction func amountChanged(_ sender: UITextField) {
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return currenciesStructure.count
		} else {
			return 1
		}
		
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if (indexPath as NSIndexPath).section == 0 {
			let handsOnCurrency = currenciesStructure[(indexPath as NSIndexPath).row]
			cell = tableView.dequeueReusableCell(withIdentifier: kCurrencyManagableCell, for: indexPath) as! CurrencyTableViewCell
			(cell as! CurrencyTableViewCell).setHandsOnCurrency(handsOnCurrency)
			//setup structure
			handsOnCurrency.textField = (cell as! CurrencyTableViewCell).valueInput
        } else {
            let cellIdentifier = kCurrencyAddCell
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CurrencyAddTableViewCell
        }
        return cell
    }
	
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Tap currency to add transaction".localized
		} else {
			return ""
		}
	}
	
	override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
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

	
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if (indexPath as NSIndexPath).section == 0 {
			return kCurrencyConverterCellHeight
		} else {
			return kCurrencyAddCellHeight
		}
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//		selectedCurrency = currenciesStructure[indexPath.row].currency
    }
	

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }



    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
		{
			app().model.deleteCurrencyFromConverter(currenciesStructure.remove(at: (indexPath as NSIndexPath).row).amount.currency)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
		else if editingStyle == .insert
		{
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
	
	
	override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		let movedObject = currenciesStructure[(sourceIndexPath as NSIndexPath).row]
		currenciesStructure.remove(at: (sourceIndexPath as NSIndexPath).row)
		currenciesStructure.insert(movedObject, at: (destinationIndexPath as NSIndexPath).row)
		// To check for correctness enable: self.tableView.reloadData()
	}


    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
		if (indexPath as NSIndexPath).row < currenciesStructure.count {
			return true
		}
		return false
    }

    // MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "SelectCurrencyToOperate" {
			if let cell = sender as? UITableViewCell {
				let indexPath = tableView.indexPath(for: cell)
				if let index = (indexPath as NSIndexPath?)?.row {
					providedAmount = currenciesStructure[index].amount
				}
			}
		} else if segue.identifier == "AddAnotherCurrency" {
			(segue.destination as! AllCurrenciesTableViewController).delegate = self
		}
	}
	
	
	// MARK: - CurrencySelectDelegate
	func setCurrency(_ currency: Currency) {
		currenciesStructure.append(HandsOnCurrency(amount:providedAmount!.toCurrency(currency), textField: nil))
		currency.addToConverter()
		app().model.saveStorage()
		
		//update the tableView
		let indexPath = IndexPath(row: currenciesStructure.count - 1, section: 0)
		tableView.insertRows(at: [indexPath], with: .automatic)
	}
	
	
	func getCurrencyList() -> [Currency] {
		return app().model.getCurrenciesNotInConverter()
	}
	
	

	// MARK: - State Restoration
	override func encodeRestorableState(with coder: NSCoder) {
		super.encodeRestorableState(with: coder)
		coder.encode(self.tabBarController!.selectedIndex, forKey: "TabBarCurrentTab")
		print("**** Encode state", self.tabBarController!.selectedIndex)
	}
	
	override func decodeRestorableState(with coder: NSCoder) {
		super.decodeRestorableState(with: coder)
		self.tabBarController!.selectedIndex = coder.decodeInteger(forKey: "TabBarCurrentTab")
		print("**** Decode state", self.tabBarController!.selectedIndex)
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	
	override func encode(with aCoder: NSCoder) {
		aCoder.encode(self.tabBarController!.selectedIndex, forKey: "TabBarCurrentTab")
		print("**** Encode 2 state", self.tabBarController!.selectedIndex)
	}
}
