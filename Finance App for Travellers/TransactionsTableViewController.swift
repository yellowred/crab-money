//
//  TableViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 18/08/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class TransactionsTableViewController: UITableViewController {

	var transactions = Array<Transaction>()
	var transactionStructure = Dictionary<String, Array<Transaction>>()
	var sortedSectionTitles = Array<String>()
	
	private let kTransactionCellIdentifier = "TransactionCell"
	private let kShowTransactionDetailSegue = "ShowTransactionDetail"
	
	var currentPeriod: Period?
	
	/*
	@IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageScroll: UIPageControl!
    var pageViews: [UIView?] = []
	@IBOutlet weak var graphView: GraphView!
	@IBOutlet var graphViewContainer: UIView!
	
	@IBOutlet weak var summaryParentView: UIView!
	var isGraphViewShowing = false
	*/
	
    override func viewDidLoad() {
        super.viewDidLoad()

		transactions = app().model.getTransactionsListForPeriod(currentPeriod!)
		getTransactionsStructure()
	}
	
	
	func getTransactionsStructure() {
		transactionStructure = Dictionary<String, Array<Transaction>>()
		let df = NSDateFormatter()
		df.dateStyle = NSDateFormatterStyle.MediumStyle
		var date: String
		for elem in transactions {
			date = df.stringFromDate(elem.date)
			if transactionStructure.indexForKey(date) == nil {
				transactionStructure[date] = [elem]
			}
			else {
				transactionStructure[date]!.append(elem)
			}
		}
		sortedSectionTitles = transactionStructure.keys.elements.sort()
	}
	
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
    // MARK: - Summary Scroll View
	/*
	func loadSummaryViews() {
		for summaryType in ["expenses", "earnings", "budget"] {
			scrollView.addSubview(createSummaryView(summaryType))
		}
		scrollView.contentSize = CGSizeMake(self.view.frame.size.width * CGFloat(kSummaryPageCount), summaryParentView.frame.size.height - pageScroll.frame.height)
    }
	
	func createSummaryView(type: String) -> SummaryView {
		let newPageView: SummaryView = NSBundle.mainBundle().loadNibNamed("TransactionsSummaryView", owner: self, options: nil)[0] as! SummaryView
		newPageView.contentMode = .ScaleAspectFit
		newPageView.initBlock(type, forDate: NSDate(), transactions: transactions, currency: app.model.getCurrentCurrency())
		var frame = scrollView.bounds
		frame.origin.x = self.view.frame.size.width * CGFloat(scrollView.subviews.count - 1)
		frame.origin.y = 0.0
		newPageView.frame = frame

		return newPageView
	}
	
	override func scrollViewDidScroll(scrollView: UIScrollView) {
		// First, determine which page is currently visible
		let pageWidth = scrollView.frame.size.width
		let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
		
		// Update the page control
		//pageScroll.currentPage = page
	}
	*/

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return transactionStructure.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionStructure[sortedSectionTitles[section]]!.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(kTransactionCellIdentifier, forIndexPath: indexPath) as! TransactionTableViewCell
		cell.setTransaction(transactionStructure[sortedSectionTitles[indexPath.section]]![indexPath.row])
		return cell
	}

	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 90
	}

	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sortedSectionTitles[section]
	}
	
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
			transactionStructure[sortedSectionTitles[indexPath.section]]?.removeAtIndex(indexPath.row)
			app().model.deleteTransaction(transactions.removeAtIndex(indexPath.row))
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		let selectedTransaction:Transaction = transactionStructure[sortedSectionTitles[indexPath.section]]![indexPath.row]
		performSegueWithIdentifier(kShowTransactionDetailSegue, sender: selectedTransaction)
	}

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == kShowTransactionDetailSegue {
			(segue.destinationViewController as! TransactionDetailTableViewController).transaction = sender as? Transaction
		}
    }
	
	@IBAction override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {

	}
	
	@IBAction func saveTransaction(segue:UIStoryboardSegue) {
		if let transactionDetailTVC = segue.sourceViewController as? TransactionDetailTableViewController {
			if let transaction = transactionDetailTVC.transaction {
				transaction.amount = NSDecimalNumber(string: transactionDetailTVC.amountValue.text)
				transaction.date = transactionDetailTVC.dateValue.date
				transaction.text = transactionDetailTVC.descriptionValue.text
				if let currency = app().model.getCurrencyByCode(transactionDetailTVC.currencyButton.titleLabel!.text!) {
					transaction.currency = currency
				}
				app().model.saveStorage()
				getTransactionsStructure()
				tableView.reloadData()
			}
		}
	}

}
