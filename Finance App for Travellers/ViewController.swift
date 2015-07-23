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
    
    @IBOutlet weak var networkingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.setNavigationBarHidden(true, animated: false)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectedCurrency(segue:UIStoryboardSegue) {
		navigationController?.setNavigationBarHidden(true, animated: true)
        if let currenciesTableViewController = segue.sourceViewController as? CurrenciesTableViewController,
            selectedCurrency = currenciesTableViewController.selectedCurrency {

				currentCurrrency = selectedCurrency
        }
    }

	
	override func viewDidAppear(animated: Bool)
	{
		navigationController?.setNavigationBarHidden(true, animated: true)
		super.viewDidAppear(animated)
	}
	
	override func viewDidDisappear(animated: Bool)
	{
		navigationController?.setNavigationBarHidden(false, animated: true)
		super.viewDidDisappear(animated)
	}
	
}

