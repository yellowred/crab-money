//
//  ViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 19/06/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit
import ChameleonFramework


enum NumpadSegues: String {
	case SelectNumpadCurrency = "SelectNumpadCurrency"
	case CategorySelectSegue = "CategorySelectSegue"
}

class NumpadViewController: UIViewController, UIGestureRecognizerDelegate, CategorySelectDelegate, CurrencySelectDelegate {
	
	var amount:Money?
	var notCompletedTransaction: Transaction?
	var baselineOffset:Int = 20
	var isAmountLoaded:Bool = false
	
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
		

        /*
        var alert: UIAlertView = UIAlertView(title: "Title", message: "Please wait...", delegate: nil, cancelButtonTitle: "Cancel");
        var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(50, 10, 37, 37)) as UIActivityIndicatorView
        loadingIndicator.center = self.view.center;
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        
        alert.setValue(loadingIndicator, forKey: "accessoryView")
        loadingIndicator.startAnimating()
        
        alert.show();
        alert.dismissWithClickedButtonIndex(0, animated: true)
        */
        
        //networkingIndicator.startAnimating()
		//Networking().downloadCountriesDatabase({self.networkingIndicator.stopAnimating()})
		//Networking().downloadCurrenciesDatabase({self.networkingIndicator.stopAnimating()})
		
		amount = Money(amount: 0, currency: app().model.getNumpadCurrency())
		updateCurrentCurrencyBlock()
		
		//createNumpad()
		//amountView.layer.cornerRadius = 5
		//amountView.layer.borderColor = UIColor.darkGrayColor().CGColor
		//amountView.layer.borderWidth = 1.0
		
		//currencyFlag.layer.cornerRadius = 20
		//currencyFlag.layer.masksToBounds = true
		
		//amountView.backgroundColor = UIColor(patternImage: UIImage(named: "Rectangle 156x1")!)
		
		/*
		amountView.backgroundColor = UIColor(rgba: "#1C2531")
		let gradient1:CAGradientLayer = CAGradientLayer()
		gradient1.frame = amountView.bounds
		gradient1.colors = [UIColor(rgba: "#1C2531").CGColor, UIColor(rgba: "#999999").CGColor, UIColor(rgba: "#1C2531").CGColor] //Or any colors
		gradient1.locations = [0.0, 0.5, 1.0]
		gradient1.startPoint = CGPointMake(0.0, 0.5);
		gradient1.endPoint = CGPointMake(1.0, 0.5);
		amountView.layer.insertSublayer(gradient1, atIndex: 0)
		*/
		//amountView.backgroundColor = UIColor(rgba: "#324459")
		
		//currencyView.backgroundColor = UIColor(rgba: "#F9F9F9")
		//currencyView.layer.cornerRadius = 3
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		expense.backgroundColor = UIColor.expense()
		//self.expense.center.x -= self.view.bounds.width
		earning.backgroundColor = UIColor.earning()
		//self.earning.center.x += self.view.bounds.width
		expense.layer.cornerRadius = 23
		earning.layer.cornerRadius = 23
		currentFlag.layer.cornerRadius = 2
		currentFlag.layer.masksToBounds = true
		reloadAmountDisplay()
	}
	

	func createNumpad() {
		var button = createButton("111")
		//button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
		var widthConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: numpad, attribute: NSLayoutAttribute.Width, multiplier: 0.3, constant: 0)
		var heightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: numpad, attribute: NSLayoutAttribute.Height, multiplier: 0.3, constant: 0)
		var pos1 = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal,
			toItem: numpad, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
		var pos2 = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
			toItem: numpad, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
		
		numpad.addSubview(button)
		//constraint should apply to higher element in tree
		numpad.addConstraint(widthConstraint)
		numpad.addConstraint(heightConstraint)
		numpad.addConstraint(pos1)
		numpad.addConstraint(pos2)
		
		
		button = createButton("22")
		//button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
		widthConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: numpad, attribute: NSLayoutAttribute.Width, multiplier: 0.3, constant: 0)
		heightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: numpad, attribute: NSLayoutAttribute.Height, multiplier: 0.3, constant: 0)
		pos1 = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal,
			toItem: numpad, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
		pos2 = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
			toItem: numpad, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
		
		numpad.addSubview(button)
		//constraint should apply to higher element in tree
		numpad.addConstraint(widthConstraint)
		numpad.addConstraint(heightConstraint)
		numpad.addConstraint(pos1)
		numpad.addConstraint(pos2)
	}

	func createButton (title: String) -> UIButton {
		let button = UIButton(type: UIButtonType.System);
		button.setTitle(title, forState: .Normal)
		button.frame = CGRectMake(0, 0, 160, 80)
		button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
		button.titleLabel!.textAlignment = .Center
		button.titleLabel!.numberOfLines = 1
		button.titleLabel!.font = UIFont.systemFontOfSize(48)
		return button
	}
    
	
	@IBAction func tapNumber(sender: UIButton)
	{
		#if DEBUG
			println(__FUNCTION__)
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
	
	@IBAction func tapSaveTransaction(sender: AnyObject) {
		if notCompletedTransaction != nil {
			app().model.deleteTransaction(notCompletedTransaction!)
		}
		notCompletedTransaction = app().model.createTransaction(amount!, isExpense: sender.tag == 102 ? true : false)
		performSegueWithIdentifier(NumpadSegues.CategorySelectSegue.rawValue, sender: nil)
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
		UIView.animateWithDuration(1, delay: 0.3, usingSpringWithDamping: 0.95, initialSpringVelocity: 5, options: [], animations: {
			self.expense.alpha = 1
			self.expenseHPosConstraint.constant = 10
			self.view.layoutIfNeeded()
			}, completion: nil)
		UIView.animateWithDuration(1, delay: 0.3, usingSpringWithDamping: 0.95, initialSpringVelocity: 5, options: [], animations: {
			self.earning.alpha = 1
			self.earningHPosConstraint.constant = 10
			self.view.layoutIfNeeded()
			}, completion: nil)
	}
	
	
	func hideSaveButtons()
	{
		self.view.layoutIfNeeded()
		UIView.animateWithDuration(0.5, delay: 0.3, usingSpringWithDamping: 0.35, initialSpringVelocity: 15, options: [], animations: {
			self.expense.alpha = 0.5
			self.expenseHPosConstraint.constant = -self.expense.bounds.width
			self.view.layoutIfNeeded()
			}, completion: nil)
		UIView.animateWithDuration(0.5, delay: 0.3, usingSpringWithDamping: 0.35, initialSpringVelocity: 15, options: [], animations: {
			self.earning.alpha = 0.5
			self.earningHPosConstraint.constant = -self.earning.bounds.width
			self.view.layoutIfNeeded()
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
		sound.playTap()
		amount!.setAmount(0)
		reloadAmountDisplay()
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
		print("Segue: \(segue.identifier)")
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

