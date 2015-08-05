//
//  ViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 19/06/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currentCurrrency: Currency?
	var amount:String = ""
    
    @IBOutlet weak var networkingIndicator: UIActivityIndicatorView!
	@IBOutlet weak var amountDisplayLabel: UILabel!

    @IBOutlet weak var currentCurrencyFlag: UIImageView!
    @IBOutlet weak var currentCurrencyLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
		navigationController?.navigationBar.barStyle = .Black
		

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
    }

	@IBAction func tapNumber1(sender: UIButton)
	{
		amount = amount + "1"
		reloadAmountDisplay()
	}

	
	@IBAction func tapNumber2(sender: UIButton) {
		amount = amount + "2"
		reloadAmountDisplay()
	}
	
	
	@IBAction func tapNumber3(sender: UIButton) {
		amount = amount + "3"
		reloadAmountDisplay()

	}
	
	
	@IBAction func tapNumber4(sender: UIButton) {
		amount = amount + "4"
		reloadAmountDisplay()

	}
	
	
	@IBAction func tapNumber5(sender: UIButton) {
		amount = amount + "5"
		reloadAmountDisplay()

	}
	
	
	@IBAction func tapNumber6(sender: UIButton) {
		amount = amount + "6"
		reloadAmountDisplay()

	}
	
	
	@IBAction func tapNumber7(sender: UIButton) {
		amount = amount + "7"
		reloadAmountDisplay()

	}
	
	
	@IBAction func tapNumber8(sender: UIButton) {
		amount = amount + "8"
		reloadAmountDisplay()

	}
	
	
	@IBAction func tapNumber9(sender: UIButton) {
		amount = amount + "9"
		reloadAmountDisplay()

	}
	
	
	@IBAction func tapNumberDiv(sender: UIButton) {
		amount = amount + "."
		reloadAmountDisplay()

	}
	
	
	@IBAction func tapNumber0(sender: UIButton) {
		amount = amount + "0"
		reloadAmountDisplay()

	}
	
	
	@IBAction func tapNumberDel(sender: UIButton) {
		amount = amount.substringToIndex(amount.endIndex.predecessor())
		reloadAmountDisplay()

	}
	
	@IBAction func tapSaveTransaction(sender: AnyObject) {
	}
	
	
	func reloadAmountDisplay()
	{
		//amountDisplayLabel.adjustsFontSizeToFitWidth = true
		amountDisplayLabel.text = amount
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectedCurrency(segue:UIStoryboardSegue) {
		let currenciesTVC = segue.sourceViewController as? CurrenciesTableViewController
        if  (currenciesTVC != nil) {
			currentCurrrency = currenciesTVC!.selectedCurrency
            currentCurrencyFlag.image = currentCurrrency?.getFlag()
            currentCurrencyLabel.text = currentCurrrency?.code.uppercaseString
			println("Current currency: \(currentCurrrency)")
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
		println("Segue: \(segue.identifier)")
		if segue.identifier == "showCurrencySelect"
		{
			if let currenciesTVC = segue.destinationViewController.topViewController as? CurrenciesTableViewController
			{
				currenciesTVC.providedAmount = amount
				println("Amount: \(amount)")
			}
		}
	}
}

