//
//  ProfileTableViewController.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 28/9/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import UIKit
import Crashlytics

class ProfileTableViewController: UITableViewController, UIDocumentInteractionControllerDelegate {

	var purchase = Purchase()
	
	let kDataOpsSectionId = 1
	let kAppOpsSectionId = 2
	let kPurchasesSectionId = 3
	let kDebugOpsSectionId = 4
	
	var docInteractionController:UIDocumentInteractionController?
	var activityViewController:UIActivityViewController?
	
	
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
		
        if indexPath.section == kPurchasesSectionId && indexPath.row == 0 {
			
			// restore purchases
			let alert = Alerter().loading(message: "Please wait...".localized)
			present(alert, animated: true, completion: nil)
			Purchase().restorePurchases(cb: {
				message in
				alert.dismiss(animated: true, completion: nil)
				self.present(Alerter().notify(title: "Restore purchases".localized, message: message), animated: true, completion: nil)
			})
			
		} else if indexPath.section == kAppOpsSectionId && indexPath.row == 2 {
			// https://www.facebook.com/calmmoneyapp/
			UIApplication.shared.openURL(URL(string: "fb://profile/422289254825957")!)
		
		} else if indexPath.section == kAppOpsSectionId && indexPath.row == 1 {
			
			Rater().openRatePage()
		
		} else if indexPath.section == kAppOpsSectionId && indexPath.row == 0 {
			
			let str = "mailto:surfingcathk@gmail.com?subject=Support%20Request"
			let url = NSURL(string: str)
			UIApplication.shared.openURL(url as! URL)
			
		} else if indexPath.section == kDebugOpsSectionId && indexPath.row == 0 {
			
			let debugViewController = DebugViewController(nibName: "DebugViewController", bundle: nil)
			debugViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
			present(debugViewController, animated: true, completion: nil)
			
		} else if indexPath.section == kDataOpsSectionId && indexPath.row == 0 {
			
			presentDataExportDialog()
			
		}
	}
	
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.section == 0 && indexPath.row == 0 && (Purchase().isPurchasedUnlimitedTransactions() || !Purchase().canMakePayments()) {
			return 0.0
		} else if indexPath.section == kDebugOpsSectionId && indexPath.row == 0 && !(app().debug) {
			return 0.0
		}
		return super.tableView(tableView, heightForRowAt: indexPath)
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == kDebugOpsSectionId && !(app().debug) {
			return nil
		} else if section == kAppOpsSectionId {
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
	
	
	// MARK: - Data Export
	func presentDataExportDialog() {
		var currentPeriod:PeriodMonth?
		
		if let initialTransaction = app().model.getIinitialTransaction(), currentPeriod?.initialDate != initialTransaction.date {
			currentPeriod = PeriodMonth(currentDate: Date(), initialDate: initialTransaction.date)
		}
		
		if currentPeriod == nil {
			self.present(Alerter().notify(title: "Export to Excel".localized, message: "No transactions to export".localized), animated: true, completion: nil)
		} else {
			let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
			actionSheet.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
			
			let allTxActionButton: UIAlertAction = UIAlertAction(title: "All transactions".localized, style: .default)
			{ action -> Void in
				self.export(transactions: self.app().model.getTransactionsList())
			}
			actionSheet.addAction(allTxActionButton)
			
			let lastThreeTxActionButton: UIAlertAction = UIAlertAction(title: "Last 3 months".localized, style: .default)
			{ action -> Void in
				
				var tx3Month:[Transaction] = []
				var monthIndex = 0
				while currentPeriod != nil, monthIndex < 3 {
					tx3Month.append(contentsOf: self.app().model.getTransactionsListForPeriod(currentPeriod!))
					currentPeriod = currentPeriod?.getPrev()
					monthIndex += 1
				}
				self.export(transactions: tx3Month)
			}
			actionSheet.addAction(lastThreeTxActionButton)
			
			let thisMonthTxActionButton: UIAlertAction = UIAlertAction(title: "This month".localized, style: .default)
			{ action -> Void in
				self.export(transactions: self.app().model.getTransactionsListForPeriod(currentPeriod!))
			}
			actionSheet.addAction(thisMonthTxActionButton)
			
			self.present(actionSheet, animated: true, completion: nil)
		}
		
	}
	
	
	func export(transactions: [Transaction]) {
		if let url = Exporter().export(transactions: transactions) {
			self.setupDocumentController(url: url)
			
			/*
			self.activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
			self.activityViewController!.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
			
			// exclude some activity types from the list (optional)
			self.activityViewController!.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
			self.present(self.activityViewController!, animated: true, completion: nil)
			*/
		} else {
			self.present(Alerter().notify(title: "Unable to export".localized, message: "Unable to save transactions history in a file. Please, check your free space and try again.".localized), animated: true, completion: nil)
		}
	}
	
	
	func setupDocumentController(url:URL)	{
		
		//checks if docInteractionController has been initialized with the URL
		if (self.docInteractionController == nil)
		{
			self.docInteractionController = UIDocumentInteractionController.init(url: url)
			self.docInteractionController?.delegate = self;
		}
		else
		{
			self.docInteractionController?.url = url;
		}
		docInteractionController?.name = "Transactions sheet".localized
		docInteractionController?.presentPreview(animated: true)
		
		if !app().debug {
			Answers.logContentView(withName: "Present exported transactions to share",
			                       contentType: "View",
			                       contentId: "profile-export-excel",
			                       customAttributes: [:])
		}
		
	}

	
	func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
		return self
	}
	
}
