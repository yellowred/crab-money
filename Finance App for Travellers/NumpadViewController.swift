//
//  ViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 19/06/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit
import Spring

enum NumpadSegues: String {
	case SelectNumpadCurrency = "SelectNumpadCurrency"
	case CategorySelectSegue = "CategorySelectSegue"
}

class NumpadViewController: UIViewController, UIGestureRecognizerDelegate, CategorySelectDelegate, CurrencySelectDelegate {
	
	var amount:Money?
	var notCompletedTransaction: Transaction?
	var baselineOffset:Int = 20
	var isAmountLoaded:Bool = false
	var inputConfirmation:SpringView? = nil
	
	private var sound: Sound = {return Sound()}()
	
    @IBOutlet weak var networkingIndicator: UIActivityIndicatorView!
	@IBOutlet weak var amountDisplayLabel: UILabel!

	@IBOutlet weak var numpad: UIView!
    @IBOutlet weak var amountView: UIView!
	@IBOutlet var currencyView: UIView!
	@IBOutlet var currentFlag: UIImageView!
	@IBOutlet var currentCurrency: UILabel!
	@IBOutlet var expense: UIButton!
	@IBOutlet var expenseHPosConstraint: NSLayoutConstraint!
	@IBOutlet var earning: UIButton!
	@IBOutlet var earningHPosConstraint: NSLayoutConstraint!

	
    override func viewDidLoad() {
        super.viewDidLoad()

		amount = Money(amount: 0, currency: app().model.getNumpadCurrency())
		updateCurrentCurrencyBlock()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		expense.backgroundColor = UIColor.expense()
		earning.backgroundColor = UIColor.earning()
		expense.layer.cornerRadius = 23
		earning.layer.cornerRadius = 23
		currentFlag.layer.cornerRadius = 2
		currentFlag.layer.masksToBounds = true
		amountDisplayLabel.textColor = UIColor.amountColor()
		
		let filteredSubviews = self.numpad.subviews.filter({
			$0.isKindOfClass(UIButton)})
		
		for button in filteredSubviews {
			(button as! UIButton).setTitleColor(UIColor.amountColor(), forState: UIControlState.Normal)
		}
		
		reloadAmountDisplay()
	}
	
	
	@IBAction func tapNumber(sender: UIButton)
	{
		#if DEBUG
			println(#function)
		#endif
        if sender.tag >= 1 && sender.tag <= 10 {
            amount!.appendSymbol(sender.tag < 10 ? String(sender.tag) : "0")
        } else if sender.tag == 11 {
            amount!.appendSymbol(".")
        }
        else if sender.tag == 12 {
            amount!.backspace()
        }
		sender.backgroundColor = UIColor.whiteColor()
		sound.playTap()
        reloadAmountDisplay()
	}
	
	@IBAction func numberPressed(sender: UIButton) {
		sender.backgroundColor = UIColor(rgba: "#F4F4F4")
	}
	
	@IBAction func tapSaveTransaction(sender: UIButton) {
		if notCompletedTransaction != nil {
			app().model.deleteTransaction(notCompletedTransaction!)
		}
		notCompletedTransaction = app().model.createTransaction(amount!, isExpense: sender.tag == 102 ? true : false)
		performSegueWithIdentifier(NumpadSegues.CategorySelectSegue.rawValue, sender: nil)
	}
	
    @IBAction func saveTransactionTouchDown(sender: UIButton) {
        UIView.animateWithDuration(0.2,
            animations: {
                sender.transform = CGAffineTransformMakeScale(1.2, 1.2)
            },
            completion: nil
        )
    }
    
    @IBAction func saveTransactionTouchUp(sender: UIButton) {
        UIView.animateWithDuration(0.1){
            sender.transform = CGAffineTransformIdentity
        }
    }
    
	@IBAction func numberPressedEnd(sender: UIButton) {
		sender.backgroundColor = UIColor.whiteColor()
	}
	
	func reloadAmountDisplay()
	{
		guard amountDisplayLabel != nil else {
			return
		}
		amountDisplayLabel.adjustsFontSizeToFitWidth = true
		amountDisplayLabel.text = amount!.valueForAmount()
		if amount!.amount.isPositive() {
			showSaveButtons()
		} else {
			hideSaveButtons()
		}
	}
	
	
	func showSaveButtons()
	{
		self.view.layoutIfNeeded()
		UIView.animateWithDuration(0.2, animations: {
		//UIView.animateWithDuration(1, delay: 0.3, usingSpringWithDamping: 0.99, initialSpringVelocity: 15, options: [], animations: {
			self.expense.alpha = 1
			//self.expenseHPosConstraint.constant = 10
			//self.view.layoutIfNeeded()
			}, completion: nil)
		UIView.animateWithDuration(0.2, animations: {
		//UIView.animateWithDuration(1, delay: 0.3, usingSpringWithDamping: 0.99, initialSpringVelocity: 15, options: [], animations: {
			self.earning.alpha = 1
			//self.earningHPosConstraint.constant = 10
			//self.view.layoutIfNeeded()
			}, completion: nil)
		
		
	}
	
	
	func hideSaveButtons()
	{
		self.view.layoutIfNeeded()
		UIView.animateWithDuration(0.5, animations: {
		//UIView.animateWithDuration(0.5, delay: 0.3, usingSpringWithDamping: 0.35, initialSpringVelocity: 15, options: [], animations: {
			self.expense.alpha = 0.2
			//self.expenseHPosConstraint.constant = -self.expense.bounds.width
			//self.view.layoutIfNeeded()
			}, completion: nil)
		UIView.animateWithDuration(0.5, animations: {
		//UIView.animateWithDuration(0.5, delay: 0.3, usingSpringWithDamping: 0.35, initialSpringVelocity: 15, options: [], animations: {
			self.earning.alpha = 0.2
			//self.earningHPosConstraint.constant = -self.earning.bounds.width
			//self.view.layoutIfNeeded()
			}, completion: nil)
	}

	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectedCurrency(segue:UIStoryboardSegue) {
		let currenciesTVC = segue.sourceViewController as? ConverterTableViewController
        if  (currenciesTVC != nil) {
			amount = currenciesTVC!.providedAmount
			updateCurrentCurrencyBlock()
			reloadAmountDisplay()
			app().model.setNumpadCurrency(amount!.currency)
        }
    }
	
	func setCategory(category:Category) {
		guard notCompletedTransaction != nil else {
			return
		}
	
		notCompletedTransaction!.category = category
		notCompletedTransaction!.currency.increasePopularity()
		app().model.saveStorage()
		notCompletedTransaction = nil
		NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(NumpadViewController.showInputConfirmation(_:)), userInfo: nil, repeats: false)
		NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(NumpadViewController.hideInputConfirmation(_:)), userInfo: nil, repeats: false)
/*
		
*/
		sound.playTap()
		amount!.setAmount(0)
		reloadAmountDisplay()
	}

	
	func showInputConfirmation(timer: NSTimer) {
		let frame = CGRect(x: 0, y: 0, width: 200, height: 200);
		inputConfirmation = SpringView(frame: frame)
		let confirmLabel = UILabel(frame: frame)
		confirmLabel.text = "✓"
		confirmLabel.textAlignment = NSTextAlignment.Center
		confirmLabel.font = UIFont.systemFontOfSize(120)
		inputConfirmation!.backgroundColor = UIColor.lightGrayColor()
		inputConfirmation!.alpha = 1
		inputConfirmation!.layer.masksToBounds = true
		inputConfirmation!.layer.cornerRadius = 10
		inputConfirmation!.addSubview(confirmLabel)
		self.view.addSubview(inputConfirmation!)
		inputConfirmation!.center.x = self.view.center.x
		inputConfirmation!.center.y = self.view.center.y
		inputConfirmation!.animation = "zoomIn"
		inputConfirmation!.duration = 0.5
		inputConfirmation!.animate()
		
	}
	
	
	func hideInputConfirmation(timer: NSTimer) {
		if inputConfirmation != nil {
			UIView.animateWithDuration(1, animations: {
				self.inputConfirmation!.alpha = 0
				}, completion: {
					(_: Bool) in
					self.inputConfirmation!.removeFromSuperview()
				}
			)
		}
	}

	func isExpense() -> Bool {
		return !notCompletedTransaction!.amount.isPositive()
	}

	
	override func viewDidAppear(animated: Bool)
	{
		super.viewDidAppear(animated)
	}
	
	
	override func viewDidDisappear(animated: Bool)
	{
		super.viewDidDisappear(animated)
	}
	
	@IBAction func currencySelectTap(sender: UITapGestureRecognizer) {
		if sender.state == UIGestureRecognizerState.Began {
			currencyView.backgroundColor = UIColor.lightGrayColor()
		} else {
			currencyView.backgroundColor = UIColor.whiteColor()
		}
		
		if sender.state == UIGestureRecognizerState.Ended {
			let selectCurrencyView: AllCurrenciesTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SelectCurrency") as! AllCurrenciesTableViewController
			selectCurrencyView.delegate = self
			self.navigationController?.pushViewController(selectCurrencyView, animated: true)
		}
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		if segue.identifier == "showCurrencySelect2"	{
			if let currenciesTVC = (segue.destinationViewController as! UINavigationController).topViewController as? ConverterTableViewController	{
				currenciesTVC.providedAmount = amount!
			}
		} else if segue.identifier == NumpadSegues.CategorySelectSegue.rawValue {
			let c = (segue.destinationViewController as! UINavigationController).topViewController as! CategoriesCollectionViewController
			c.delegate = self
		} else if segue.identifier == NumpadSegues.SelectNumpadCurrency.rawValue {
			(segue.destinationViewController as! AllCurrenciesTableViewController).delegate = self
		}
	}
	
	@IBAction func unwindToMainViewController (sender: UIStoryboardSegue){
		// bug? exit segue doesn't dismiss so we do it manually...
		self.dismissViewControllerAnimated(true, completion: nil)
		
	}
	
	func updateCurrentCurrencyBlock() {
		if amount != nil && currentFlag != nil { //check whether iboutlet is loaded by viewDidLoad
			currentFlag.image = amount!.currency.getFlag()
			currentCurrency.text = amount!.currency.code.uppercaseString
		}
	}
	
	// MARK: - CurrencySelectDelegate
	func setCurrency(currency: Currency) {
		if amount?.currency.code != currency.code {
			amount?.currency = currency
			updateCurrentCurrencyBlock()
			app().model.setNumpadCurrency(amount!.currency)
		}
	}
	
	
	func getCurrencyList() -> [Currency] {
		return app().model.getCurrenciesList()
	}
	
	
	// MARK: - State Restoration
	override func encodeRestorableStateWithCoder(coder: NSCoder) {
		super.encodeRestorableStateWithCoder(coder)
		coder.encodeInteger(self.tabBarController!.selectedIndex, forKey: "TabBarCurrentTab")
		print("Encode state", self.tabBarController!.selectedIndex)
	}
	
	override func decodeRestorableStateWithCoder(coder: NSCoder) {
		super.decodeRestorableStateWithCoder(coder)
		self.tabBarController!.selectedIndex = coder.decodeIntegerForKey("TabBarCurrentTab")
		print("Decode state", self.tabBarController!.selectedIndex)
	}
}

