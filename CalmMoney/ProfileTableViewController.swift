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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buyPro(_ sender: Any) {
		let alert = Alerter().loading(message: "Please wait...".localized)
		present(alert, animated: true, completion: nil)

        Purchase().purchase(productId: Purchase().getUnlimitedTransactionsProductId()!, cb: {
            result in
			alert.dismiss(animated: true, completion: nil)
            switch result {
            case .success( _):
                print("Successful purchase: \(Purchase().getUnlimitedTransactionsProductId()!)")
                Purchase().setPurchasedUnlimitedTransactions()
                self.tableView.reloadData()
            case .error(let error):
                print("Purchase Failed: \(error)")
				self.present(Alerter().notify(title: nil, message: "Purchase failed. Please check your internet connection and try again.".localized), animated: true, completion: nil)
            }
        })
    }
    
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
        if indexPath.section == 2 && indexPath.row == 0 {
			
			// restore purchases
			let alert = Alerter().loading(message: "Please wait...".localized)
			present(alert, animated: true, completion: nil)
			Purchase().restorePurchases(cb: {
				message in
				alert.dismiss(animated: true, completion: nil)
				self.present(Alerter().notify(title: "Restore purchases".localized, message: message), animated: true, completion: nil)
			})
			
		} else if indexPath.section == 1 && indexPath.row == 2 {
			// https://www.facebook.com/calmmoneyapp/
			UIApplication.shared.openURL(URL(string: "fb://profile/422289254825957")!)
		
		} else if indexPath.section == 1 && indexPath.row == 1 {
			
			Rater().openRatePage()
		
		} else if indexPath.section == 1 && indexPath.row == 0 {
			
			let str = "mailto:surfingcathk@gmail.com?subject=Support%20Request"
			let url = NSURL(string: str)
			UIApplication.shared.openURL(url as! URL)
			
		} else if indexPath.section == 3 && indexPath.row == 0 {
			
			let debugViewController = DebugViewController(nibName: "DebugViewController", bundle: nil)
			debugViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
			present(debugViewController, animated: true, completion: nil)
		}
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 0 && indexPath.row == 0 && (Purchase().isPurchasedUnlimitedTransactions() || !Purchase().canMakePayments()) {
			return 0.0
		} else if indexPath.section == 3 && indexPath.row == 0 && !(Config.read(value: "debug") as! Bool) {
			return 0.0
		}
		return super.tableView(tableView, heightForRowAt: indexPath)
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 3 && !(Config.read(value: "debug") as! Bool) {
			return nil
		} else if section == 1 {
			var appVersionText:String = ""
			if let ver = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
				if let nm = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
					appVersionText = nm + " " + ver
				}
			}
			return appVersionText
		}
		return super.tableView(tableView, titleForHeaderInSection: section)
	}
	
	
}
