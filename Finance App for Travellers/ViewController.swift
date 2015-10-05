//
//  ViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 19/06/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIGestureRecognizerDelegate {

	let kShowTransactionSegue = "showTransactionsView"
	// create the transition manager object
	var transitionManager = MenuTransitionManager()
	
	var amount:Money?
	private var app: AppDelegate = {return UIApplication.sharedApplication().delegate as! AppDelegate}()
    
    @IBOutlet weak var networkingIndicator: UIActivityIndicatorView!
	@IBOutlet weak var amountDisplayLabel: UILabel!

    @IBOutlet weak var currentCurrencyFlag: UIImageView!
    @IBOutlet weak var currentCurrencyLabel: UILabel!
	
	
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
		
		app.model.preloadData()
		if let currency = app.model.getCurrentCurrency() {
			amount = Money(amount: 0, currency: currency)
		}
		updateCurrentCurrencyBlock()
		
		// now we'll have a handy reference to this view controller
		// from within our transition manager object
		self.transitionManager.sourceViewController = self
    }

	func createButton () {
		let button = UIButton();
		button.setTitle("Add", forState: .Normal)
		button.setTitleColor(UIColor.blueColor(), forState: .Normal)
		button.frame = CGRectMake(15, -50, 200, 100)
		self.view.addSubview(button)
	}
	
	@IBAction func tapNumber1(sender: UIButton)
	{
		#if DEBUG
			println(__FUNCTION__)
		#endif
		numpadPressed("1")
	}

	
	@IBAction func tapNumber2(sender: UIButton) {
		numpadPressed("2")
	}
	
	
	@IBAction func tapNumber3(sender: UIButton) {
		numpadPressed("3")
	}
	
	
	@IBAction func tapNumber4(sender: UIButton) {
		numpadPressed("4")
	}
	
	
	@IBAction func tapNumber5(sender: UIButton) {
		numpadPressed("5")
	}
	
	
	@IBAction func tapNumber6(sender: UIButton) {
		numpadPressed("6")
	}
	
	
	@IBAction func tapNumber7(sender: UIButton) {
		numpadPressed("7")
	}
	
	
	@IBAction func tapNumber8(sender: UIButton) {
		numpadPressed("8")
	}
	
	
	@IBAction func tapNumber9(sender: UIButton) {
		numpadPressed("9")
	}
	
	
	@IBAction func tapNumberDiv(sender: UIButton) {
		numpadPressed(".")
	}
	
	
	@IBAction func tapNumber0(sender: UIButton) {
		numpadPressed("0")
	}
	
	
	@IBAction func tapNumberDel(sender: UIButton) {
		numpadPressed("<")
	}
	
	@IBAction func tapSaveTransaction(sender: AnyObject) {
		app.model.createTransaction(amount!)
		app.model.saveStorage()
		amount?.setAmount(0)
		reloadAmountDisplay()
	}
	
	func reloadAmountDisplay()
	{
		//amountDisplayLabel.adjustsFontSizeToFitWidth = true
		amountDisplayLabel.text = amount!.amount.stringValue
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectedCurrency(segue:UIStoryboardSegue) {
		let currenciesTVC = segue.sourceViewController as? CurrenciesTableViewController
        if  (currenciesTVC != nil) {
			amount = currenciesTVC!.providedAmount
			updateCurrentCurrencyBlock()
			reloadAmountDisplay()
        }
    }

	
	override func viewDidAppear(animated: Bool)
	{
		super.viewDidAppear(animated)
	}
	
	override func viewDidDisappear(animated: Bool)
	{
		super.viewDidDisappear(animated)
	}
	
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		print("Segue: \(segue.identifier)")
		if segue.identifier == "showCurrencySelect"
		{
			if let currenciesTVC = (segue.destinationViewController as! UINavigationController).topViewController as? CurrenciesTableViewController
			{
				currenciesTVC.providedAmount = amount!
			}
		}
	}
	
	@IBAction func unwindToMainViewController (sender: UIStoryboardSegue){
		// bug? exit segue doesn't dismiss so we do it manually...
		self.dismissViewControllerAnimated(true, completion: nil)
		
	}
	
	func updateCurrentCurrencyBlock() {
		if amount != nil {
			currentCurrencyFlag.image = amount!.currency.getFlag()
			currentCurrencyLabel.text = amount!.currency.code.uppercaseString
		}
	}
	
	func numpadPressed(symbol: String) {
		if amount != nil {
			if symbol == "<" {
				amount!.backspace()
			} else {
				amount!.appendSymbol(symbol)
			}
			reloadAmountDisplay()
		}
	}
	
}

