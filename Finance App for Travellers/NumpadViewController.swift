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
	
	fileprivate var sound: Sound = {return Sound()}()
	
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		expense.backgroundColor = UIColor.expense()
		earning.backgroundColor = UIColor.earning()
		expense.layer.cornerRadius = 23
		earning.layer.cornerRadius = 23
		currentFlag.layer.cornerRadius = 2
		currentFlag.layer.masksToBounds = true
		amountDisplayLabel.textColor = UIColor.amountColor()
		
		let filteredSubviews = self.numpad.subviews.filter({
			$0.isKind(of: UIButton.self)})
		
		for button in filteredSubviews {
			(button as! UIButton).setTitleColor(UIColor.amountColor(), for: UIControlState())
		}
		
		reloadAmountDisplay()
	}
	
	
	@IBAction func tapNumber(_ sender: UIButton)
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
		sender.backgroundColor = UIColor.white
		sound.playTap()
        reloadAmountDisplay()
	}
	
	@IBAction func numberPressed(_ sender: UIButton) {
		sender.backgroundColor = UIColor(rgba: "#F4F4F4")
	}
	
	@IBAction func tapSaveTransaction(_ sender: UIButton) {
		if notCompletedTransaction != nil {
			app().model.deleteTransaction(notCompletedTransaction!)
		}
		notCompletedTransaction = app().model.createTransaction(amount!, isExpense: sender.tag == 102 ? true : false)
		performSegue(withIdentifier: NumpadSegues.CategorySelectSegue.rawValue, sender: nil)
	}
	
    @IBAction func saveTransactionTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2,
            animations: {
                sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            },
            completion: nil
        )
    }
    
    @IBAction func saveTransactionTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform.identity
        })
    }
    
	@IBAction func numberPressedEnd(_ sender: UIButton) {
		sender.backgroundColor = UIColor.white
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
		UIView.animate(withDuration: 0.2, animations: {
		//UIView.animateWithDuration(1, delay: 0.3, usingSpringWithDamping: 0.99, initialSpringVelocity: 15, options: [], animations: {
			self.expense.alpha = 1
			//self.expenseHPosConstraint.constant = 10
			//self.view.layoutIfNeeded()
			}, completion: nil)
		UIView.animate(withDuration: 0.2, animations: {
		//UIView.animateWithDuration(1, delay: 0.3, usingSpringWithDamping: 0.99, initialSpringVelocity: 15, options: [], animations: {
			self.earning.alpha = 1
			//self.earningHPosConstraint.constant = 10
			//self.view.layoutIfNeeded()
			}, completion: nil)
		
		
	}
	
	
	func hideSaveButtons()
	{
		self.view.layoutIfNeeded()
		UIView.animate(withDuration: 0.5, animations: {
		//UIView.animateWithDuration(0.5, delay: 0.3, usingSpringWithDamping: 0.35, initialSpringVelocity: 15, options: [], animations: {
			self.expense.alpha = 0.2
			//self.expenseHPosConstraint.constant = -self.expense.bounds.width
			//self.view.layoutIfNeeded()
			}, completion: nil)
		UIView.animate(withDuration: 0.5, animations: {
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

    @IBAction func selectedCurrency(_ segue:UIStoryboardSegue) {
		let currenciesTVC = segue.source as? ConverterTableViewController
        if  (currenciesTVC != nil) {
			amount = currenciesTVC!.providedAmount
			updateCurrentCurrencyBlock()
			reloadAmountDisplay()
			app().model.setNumpadCurrency(amount!.currency)
        }
    }
	
	func setCategory(_ category:Category) {
		guard notCompletedTransaction != nil else {
			return
		}
	
		notCompletedTransaction!.category = category
		notCompletedTransaction!.currency.increasePopularity()
		app().model.saveStorage()
		notCompletedTransaction = nil
		Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(NumpadViewController.showInputConfirmation(_:)), userInfo: nil, repeats: false)
		Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(NumpadViewController.hideInputConfirmation(_:)), userInfo: nil, repeats: false)
/*
		
*/
		sound.playTap()
		amount!.setAmount(0)
		reloadAmountDisplay()
	}

	
	func showInputConfirmation(_ timer: Timer) {
		let frame = CGRect(x: 0, y: 0, width: 200, height: 200);
		inputConfirmation = SpringView(frame: frame)
		let confirmLabel = UILabel(frame: frame)
		confirmLabel.text = "✓"
		confirmLabel.textAlignment = NSTextAlignment.center
		confirmLabel.font = UIFont.systemFont(ofSize: 120)
		inputConfirmation!.backgroundColor = UIColor.lightGray
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
	
	
	func hideInputConfirmation(_ timer: Timer) {
		if inputConfirmation != nil {
			UIView.animate(withDuration: 1, animations: {
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

	
	override func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)
	}
	
	
	override func viewDidDisappear(_ animated: Bool)
	{
		super.viewDidDisappear(animated)
	}
	
	@IBAction func currencySelectTap(_ sender: UITapGestureRecognizer) {
		if sender.state == UIGestureRecognizerState.began {
			currencyView.backgroundColor = UIColor.lightGray
		} else {
			currencyView.backgroundColor = UIColor.white
		}
		
		if sender.state == UIGestureRecognizerState.ended {
			let selectCurrencyView: AllCurrenciesTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectCurrency") as! AllCurrenciesTableViewController
			selectCurrencyView.delegate = self
			self.navigationController?.pushViewController(selectCurrencyView, animated: true)
		}
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if segue.identifier == "showCurrencySelect2"	{
			if let currenciesTVC = (segue.destination as! UINavigationController).topViewController as? ConverterTableViewController	{
				currenciesTVC.providedAmount = amount!
			}
		} else if segue.identifier == NumpadSegues.CategorySelectSegue.rawValue {
			let c = (segue.destination as! UINavigationController).topViewController as! CategoriesCollectionViewController
			c.delegate = self
		} else if segue.identifier == NumpadSegues.SelectNumpadCurrency.rawValue {
			(segue.destination as! AllCurrenciesTableViewController).delegate = self
		}
	}
	
	@IBAction func unwindToMainViewController (_ sender: UIStoryboardSegue){
		// bug? exit segue doesn't dismiss so we do it manually...
		self.dismiss(animated: true, completion: nil)
		
	}
	
	func updateCurrentCurrencyBlock() {
		if amount != nil && currentFlag != nil { //check whether iboutlet is loaded by viewDidLoad
			currentFlag.image = amount!.currency.getFlag()
			currentCurrency.text = amount!.currency.code.uppercased()
		}
	}
	
	// MARK: - CurrencySelectDelegate
	func setCurrency(_ currency: Currency) {
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
	override func encodeRestorableState(with coder: NSCoder) {
		super.encodeRestorableState(with: coder)
		coder.encode(self.tabBarController!.selectedIndex, forKey: "TabBarCurrentTab")
		print("Encode state", self.tabBarController!.selectedIndex)
	}
	
	override func decodeRestorableState(with coder: NSCoder) {
		super.decodeRestorableState(with: coder)
		self.tabBarController!.selectedIndex = coder.decodeInteger(forKey: "TabBarCurrentTab")
		print("Decode state", self.tabBarController!.selectedIndex)
	}
}

