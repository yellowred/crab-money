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

    @IBAction func buyPro(_ sender: Any) {
        Purchase().purchase(productId: Purchase().getUnlimitedTransactionsProductId()!, cb: {
            result in
            switch result {
            case .success( _):
                print("Successful purchase: \(Purchase().getUnlimitedTransactionsProductId()!)")
                Purchase().setPurchasedUnlimitedTransactions()
                self.tableView.reloadData()
            case .error(let error):
                print("Purchase Failed: \(error)")
            }
        })
    }
    
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
        if indexPath.section == 2 && indexPath.row == 0 {
            // restore purchases
			let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
			alert.view.tintColor = UIColor.black
			let rect = CGRect(x: 10, y: 5, width: 50, height: 50)
			let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: rect) as UIActivityIndicatorView
			loadingIndicator.hidesWhenStopped = true
			loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
			loadingIndicator.startAnimating();
			loadingIndicator.tag = 501
			alert.view.addSubview(loadingIndicator)
			present(alert, animated: true, completion: nil)
			
			Purchase().restorePurchases(cb: {result in alert.dismiss(animated: true, completion: nil)})
		} else if indexPath.section == 1 && indexPath.row == 2 {
			UIApplication.shared.openURL(URL(string: "https://www.facebook.com/calmmoneyapp/")!)
		} else if indexPath.section == 1 && indexPath.row == 1 {
			Rater().openRatePage()
		} else if indexPath.section == 1 && indexPath.row == 0 {
			let str = "mailto:foo@example.com?cc=bar@example.com&subject=Greetings%20from%20Cupertino!&body=Wish%20you%20were%20here!"
			let url = NSURL(string: str)
			UIApplication.shared.openURL(url as! URL)
		}
	
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 0 && indexPath.row == 0 && (Purchase().isPurchasedUnlimitedTransactions() || !Purchase().canMakePayments()) {
			return 0.0
		}
		return super.tableView(tableView, heightForRowAt: indexPath)
	}

}
