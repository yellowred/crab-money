//
//  ProfileTableViewController.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 28/9/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

	var purchase = Purchase()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		
		purchase.dumpAllProducts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
		
		alert.view.tintColor = UIColor.black
		let rect = CGRect(x: 10, y: 5, width: 50, height: 50)
		let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: rect) as UIActivityIndicatorView
		loadingIndicator.hidesWhenStopped = true
		loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
		loadingIndicator.startAnimating();
		
		alert.view.addSubview(loadingIndicator)
		present(alert, animated: true, completion: nil)
		
		app().backend.sendFinancials(transactions: app().model.getTransactionsList(), callback: {() in
			alert.dismiss(animated: true, completion: nil)
		})
	}

}
