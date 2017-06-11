//
//  CurrenciesTableViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 22/06/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit
import Crashlytics

class ConverterTableViewController: UITableViewController, CurrencySelectDelegate
{

	let kCurrencyConverterCellHeight:CGFloat = 80
	let kCurrencyAddCellHeight:CGFloat = 60
	let kConverterLaunchNumber:String = "app_converter_shown_number"
	let kMaxFreeLaunchesConverter:String = "app_converter_max_free_shows"
	
    @IBOutlet var handsOnCurrenciesTableView: UITableView!

	var currenciesStructure = [HandsOnCurrency]()
	var providedAmount: Money?
	
	let kCurrencyManagableCell:String = "CurrencyManagableCell"
	let kCurrencyAddCell:String = "CurrencyAddCell"
	
	let tagsToProduct = [
		"com.surfingcathk.calmmoney.currency_converter_1m": 221,
		"com.surfingcathk.calmmoney.currency_converter_3m": 222,
		"com.surfingcathk.calmmoney.currency_converter_6m": 223
	]
	
	var activeField: UITextField?
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if providedAmount == nil {
			providedAmount = Money(amount: NSDecimalNumber(value: 0 as Int), currency: app().model.getCurrentCurrency())
		}
		currenciesStructure = app().model.getHandsOnCurrenciesStructure(providedAmount!)
		tableView.allowsMultipleSelectionDuringEditing = false;

		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ConverterTableViewController.dismissKeyboard))
		view.addGestureRecognizer(tap)
		resetConverterLaunches()
		registerForKeyboardNotifications()
	}
	
	
	func registerForKeyboardNotifications()
	{
		//Adding notifies on keyboard appearing
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	
	func unregisterFromKeyboardNotifications()
	{
		//Removing notifies on keyboard appearing
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	func keyboardWasShown(notification: NSNotification)
	{
		//Need to calculate keyboard exact size due to Apple suggestions
		let info : NSDictionary = notification.userInfo! as NSDictionary
		let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
		let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
		
		self.tableView.contentInset = contentInsets
		self.tableView.scrollIndicatorInsets = contentInsets
		
		var aRect : CGRect = self.view.frame
		aRect.size.height -= keyboardSize!.height
		if activeField != nil
		{
			if (!aRect.contains(activeField!.frame.origin))
			{
				tableView.scrollRectToVisible(activeField!.frame, animated: true)
			}
		}
		
		
	}
	
	
	func keyboardWillBeHidden(notification: NSNotification)
	{
		//Once keyboard disappears, restore original positions
		let info : NSDictionary = notification.userInfo! as NSDictionary
		let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
		let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
		tableView.contentInset = contentInsets
		tableView.scrollIndicatorInsets = contentInsets
		self.view.endEditing(true)
	}

	
	//Calls this function when the tap is recognized.
	func dismissKeyboard() {
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		view.endEditing(true)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		checkPurchase()
	}
	
	override func viewDidAppear(_ animated: Bool)
	{
        tableView.reloadData()
		self.view.viewWithTag(231)?.superview?.bringSubview(toFront: self.view.viewWithTag(231)!)
		self.view.viewWithTag(232)?.superview?.bringSubview(toFront: self.view.viewWithTag(232)!)
    }

	
	func checkPurchase() {
		if !canShowConverter() {
			
			Answers.logContentView(withName: "Converter Store",
			                               contentType: "View",
			                               contentId: "converter-store",
			                               customAttributes: [:])
			
			
			currenciesStructure = app().model.getHandsOnCurrenciesStructureFake(providedAmount!)
			self.tableView.reloadData()
			self.tableView.setContentOffset(CGPoint.zero, animated: false)
			
			var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
			if #available(iOS 10.0, *) {
				blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
			}
			let blurEffectView = UIVisualEffectView(effect: blurEffect)
			blurEffectView.frame = view.bounds
			blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			blurEffectView.tag = 231
			view.addSubview(blurEffectView)
			
			let customView: UIView = Bundle.main.loadNibNamed("ConverterNotPurchased", owner: self, options: nil)![0] as! UIView
			customView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height + view.frame.origin.y)
			
			
			tagsToProduct.values.forEach({
				tag in
				customView.viewWithTag(tag)?.layer.cornerRadius = 5
			})
			
			tagsToProduct.values.forEach({
				tag in
				let priceLabel = customView.viewWithTag(tag) as! UILabel
				priceLabel.text = ""
			})
			if Purchase().canMakePayments() {
				Purchase().getConverterProducts(cb: {
					results in
					
					var priceLabel = customView.viewWithTag(221) as! UILabel
					priceLabel.text = results.retrievedProducts.first?.localizedPrice
					
					for product in results.retrievedProducts {
						if let tagNum = self.tagsToProduct[product.productIdentifier] {
							priceLabel = customView.viewWithTag(tagNum) as! UILabel
							priceLabel.text = product.localizedPrice
						}
					}
					
					[211, 212, 213].forEach({
						tag in
						let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapSubscriptionPlan(_:)))
						customView.viewWithTag(tag)?.addGestureRecognizer(tap)
					})
					
					
				})
			} else {
				tagsToProduct.values.forEach({
					tag in
					let priceLabel = customView.viewWithTag(tag) as! UILabel
					priceLabel.text = "N/A".localized
				})
			}
			
			
			customView.tag = 232
			self.view.addSubview(customView)
			self.tableView.bounces = false
			self.tableView.isScrollEnabled = false
		} else {
			
			let curlst = currenciesStructure.map({
				(elem:HandsOnCurrency) -> String in
				return elem.amount.currency.code
			}).joined(separator: ", ")
			Answers.logContentView(withName: "Converter Panel",
			                               contentType: "View",
			                               contentId: "converter-panel",
			                               customAttributes: ["curnum":currenciesStructure.count, "curlst": curlst])
			print(currenciesStructure.count)
			incrementConverterLaunches()
		}
	}
	
	
	func tapSubscriptionPlan(_ gestureRecognizer: UITapGestureRecognizer) {
		let oldColor = gestureRecognizer.view!.backgroundColor
		gestureRecognizer.view!.backgroundColor = UIColor.selectedSubscriptionPlan()
		if let productId = tagsToProduct.keysForValue(value: gestureRecognizer.view!.tag + 10).first {
			let alert = Alerter().loading(message: "Please wait...".localized)
			present(alert, animated: true, completion: nil)
			
			Purchase().purchase(productId: productId, cb: {
				result in
				alert.dismiss(animated: true, completion: nil)
				gestureRecognizer.view!.backgroundColor = oldColor
				switch result {
				case .success( _):
					Purchase().setPurchasedConverter()
					self.hideStore()
				case .error(let error):
					print("Purchase Failed: \(error)")
				}
			})
		} else {
			print ("Can not find product with tag \(gestureRecognizer.view!.tag)")
		}
	}
	
	
	func hideStore() {
		self.currenciesStructure = app().model.getHandsOnCurrenciesStructure(self.providedAmount!)
		self.view.viewWithTag(231)?.removeFromSuperview()
		self.view.viewWithTag(232)?.removeFromSuperview()
		self.tableView.bounces = true
		self.tableView.isScrollEnabled = true
		self.tableView.reloadData()
	}
	
	func resetConverterLaunches() {
		UserDefaults().set(0, forKey: kConverterLaunchNumber)
	}
	
	func incrementConverterLaunches() {
		var launches = UserDefaults().integer(forKey: kConverterLaunchNumber)
		launches += 1
		print("Converter launches: \(launches)")
		UserDefaults().set(launches, forKey: kConverterLaunchNumber)
	}
	
	func canShowConverter() -> Bool {
		let maxFreeLaunches = Config.read(value: kMaxFreeLaunchesConverter) as! Int
		return Purchase().canUseConverter() || UserDefaults().integer(forKey: kConverterLaunchNumber) <= maxFreeLaunches
	}
	
	
    func onContentSizeChange(_ notification: Notification) {
        tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func amountChanged(sender: AmountTextField) {
        if sender.text!.isEmpty {
            sender.text = "0"
        }
        if let handsOnCurrency:HandsOnCurrency = sender.correspondingCurrency {
            providedAmount = handsOnCurrency.amount
            
            for handson in currenciesStructure {
                if handsOnCurrency.amount.currency != handson.amount.currency {
                    handson.setAmount(handsOnCurrency.amount.toCurrency(handson.amount.currency).amount)
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
			(cell as! CurrencyTableViewCell).setConvert(self)
			//setup structure
			handsOnCurrency.textField = (cell as! CurrencyTableViewCell).valueInput
        } else {
            let cellIdentifier = kCurrencyAddCell
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CurrencyAddTableViewCell
        }
        return cell
    }
	
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return ""
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
