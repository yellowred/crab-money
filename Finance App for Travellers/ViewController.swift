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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectedCurrency(segue:UIStoryboardSegue) {
        if let currenciesTableViewController = segue.sourceViewController as? CurrenciesTableViewController,
            selectedCurrency = currenciesTableViewController.selectedCurrency {
                currentCurrrency = selectedCurrency
        }
    }

}

