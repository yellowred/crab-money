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
	private var sound: Sound = {return Sound()}()
	
    @IBOutlet weak var networkingIndicator: UIActivityIndicatorView!
	@IBOutlet weak var amountDisplayLabel: UILabel!

    @IBOutlet weak var currentCurrencyFlag: UIImageView!
    @IBOutlet weak var currentCurrencyLabel: UILabel!
	@IBOutlet weak var numpad: UIView!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var currencyFlag: UIImageView!
	
	
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
		amount = Money(amount: 0, currency: app.model.getCurrentCurrency())
		updateCurrentCurrencyBlock()
        reloadAmountDisplay()
		
		// now we'll have a handy reference to this view controller
		// from within our transition manager object
		self.transitionManager.sourceViewController = self
		//createNumpad()
		amountView.layer.cornerRadius = 5
        currencyFlag.layer.cornerRadius = 20
        currencyFlag.layer.masksToBounds = true
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
		sound.playTap()
        reloadAmountDisplay()
	}
	
	
	@IBAction func tapSaveTransaction(sender: AnyObject) {
		app.model.createTransaction(amount!, isExpense: sender.tag == 102 ? true : false)
		app.model.saveStorage()
		amount?.setAmount(0)
		sound.playTap()
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
	
}

