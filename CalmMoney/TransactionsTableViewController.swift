//
//  TableViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 18/08/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

protocol TransactionsViewDelegate {
	func getTransactions() -> [Transaction]
	func getCurrentPeriod() -> PeriodMonth
}

class TransactionsTableViewController: UITableViewController {

	var transactions = Array<Transaction>()
	var transactionStructure = Dictionary<String, Array<Transaction>>()
	var sortedSectionTitles = Array<String>()
	
	fileprivate let kTransactionCellIdentifier = "TransactionCell"
	fileprivate let kShowTransactionDetailSegue = "ShowTransactionDetail"
	fileprivate let kTransactionCellHeight = 70
	
	var transactionsViewDelegate: TransactionsViewDelegate?
	var dailyAmounts: [String:NSDecimalNumber]?
	
	
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

		transactions = transactionsViewDelegate!.getTransactions()
		getTransactionsStructure()

		tableView.register(UINib(nibName: "TransactionsListHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "TransactionsListHeader")

		let finmath = Math(
			transactions: transactions,
			homeCurrency: app().model.getCurrentCurrency(),
			currentPeriod: transactionsViewDelegate!.getCurrentPeriod()
		)
		dailyAmounts = finmath.dailyAmounts(transactions)
		
		NotificationCenter.default.addObserver(self,
			selector: #selector(TransactionsTableViewController.onModelDataChanged(_:)),
			name: NSNotification.Name(rawValue: app().model.kNotificationDataChanged),
			object: nil)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		tableView.reloadData()
	}
	
	func onModelDataChanged(_ notification: Notification){
		transactions = transactionsViewDelegate!.getTransactions()
		getTransactionsStructure()
	}
	
	func getTransactionsStructure() {
		transactionStructure = Dictionary<String, Array<Transaction>>()
		let df = DateFormatter()
		df.dateStyle = DateFormatter.Style.medium
		var date: String
		for elem in transactions {
			date = elem.date.formatToHash()
			if transactionStructure.index(forKey: date) == nil {
				transactionStructure[date] = [elem]
			}
			else {
				transactionStructure[date]!.append(elem)
			}
		}
		sortedSectionTitles = transactionStructure.keys.elements.sorted(){$0>$1}
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
		newPageView.initBlock(type, forDate: NSDate(), transactions: transactions, currency: app().model.getCurrentCurrency())
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return transactionStructure.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionStructure[sortedSectionTitles[section]]!.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: kTransactionCellIdentifier, for: indexPath) as! TransactionTableViewCell
		let tx = transactionStructure[sortedSectionTitles[(indexPath as NSIndexPath).section]]![(indexPath as NSIndexPath).row]
		cell.setTransaction(tx)
		if let color = tx.category?.getColor() {
//			let bgView = UIView(frame: CGRect(x: 0, y:0, width: 5, height: kTransactionCellHeight + 2))
//			bgView.backgroundColor = color
			
			let bgView = UIView(frame: CGRect(x: 12, y:kTransactionCellHeight / 2 + 1 - 5, width: 10, height: 10))
			bgView.layer.cornerRadius = 5
			bgView.backgroundColor = color
			cell.addSubview(bgView)
		}
		return cell
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return CGFloat(kTransactionCellHeight)
	}

	
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			let elem = transactionStructure[sortedSectionTitles[(indexPath as NSIndexPath).section]]?.remove(at: (indexPath as NSIndexPath).row)
			app().model.deleteTransaction(elem!)
			if tableView.numberOfRows(inSection: (indexPath as NSIndexPath).section) == 1{
				tableView.deleteSections(IndexSet(integer: (indexPath as NSIndexPath).section), with: .automatic)
			}else{
				tableView.deleteRows(at: [indexPath], with: .automatic)
			}
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
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		let selectedTransaction:Transaction = transactionStructure[sortedSectionTitles[(indexPath as NSIndexPath).section]]![(indexPath as NSIndexPath).row]
		performSegue(withIdentifier: kShowTransactionDetailSegue, sender: selectedTransaction)
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TransactionsListHeader") as! TransactionsListHeader
		
		let trn = transactionStructure[sortedSectionTitles[section]]!.first! as Transaction
		headerView.customLabel.text = trn.date.transactionsSectionFormat()
		headerView.amountLabel.text = transactionStructure[sortedSectionTitles[section]]!.count > 1 ? dailyAmounts?[trn.date.formatToHash()]?.formatToMoney() : ""
		headerView.sectionNumber = section
		headerView.backgroundColor = UIColor.lightGray
		return headerView
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == kShowTransactionDetailSegue {
			(segue.destination as! TransactionDetailTableViewController).transaction = sender as? Transaction
		}
    }
	
	@IBAction override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {

	}
	
	@IBAction func saveTransaction(_ segue:UIStoryboardSegue) {
		if let transactionDetailTVC = segue.source as? TransactionDetailTableViewController {
			if let transaction = transactionDetailTVC.transaction {
				transaction.amount = NSDecimalNumber(string: transactionDetailTVC.amountValue.text)
				transaction.date = transactionDetailTVC.dateValue.date
				transaction.text = transactionDetailTVC.descriptionValue.text
				if transactionDetailTVC.currencyUpd != nil {
					transaction.currency = transactionDetailTVC.currencyUpd!
				}
				transaction.category = transactionDetailTVC.categoryUpd
				app().model.saveStorage()
				getTransactionsStructure()
				tableView.reloadData()
			}
		}
	}

}
