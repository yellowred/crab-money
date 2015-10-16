//
//  TableViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 18/08/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

//http://www.raywenderlich.com/76436/use-uiscrollview-scroll-zoom-content-swift
class TransactionsTableViewController: UITableViewController {

	let kSummaryPageCount = 3
	private var app: AppDelegate = {return UIApplication.sharedApplication().delegate as! AppDelegate}()
	var transactions = [Transaction]()
	private let kTransactionCellIdentifier = "TransactionCell"
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageScroll: UIPageControl!
    var pageViews: [UIView?] = []
	@IBOutlet weak var graphView: GraphView!
	@IBOutlet var graphViewContainer: UIView!
	
	@IBOutlet weak var summaryParentView: UIView!
	var isGraphViewShowing = false
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.rightBarButtonItem = self.editButtonItem()
		transactions = app.model.getTransactionsList()

		//Summary scroll view init
		pageScroll.currentPage = 0
		pageScroll.numberOfPages = kSummaryPageCount
		loadSummaryViews()

		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	

    // MARK: - Summary Scroll View
    func loadSummaryViews() {
		for summaryType in ["expenses", "earnings", "budget"] {
			scrollView.addSubview(createSummaryView(summaryType))
		}
		scrollView.contentSize = CGSizeMake(self.view.frame.size.width * CGFloat(kSummaryPageCount), summaryParentView.frame.size.height - pageScroll.frame.height)
    }
	
	func createSummaryView(type: String) -> SummaryView {
		let newPageView: SummaryView = NSBundle.mainBundle().loadNibNamed("TransactionsSummaryView", owner: self, options: nil)[0] as! SummaryView
		newPageView.contentMode = .ScaleAspectFit
		var pageIndex = 0
		
		if (type == "expenses") {
			let amountSummary = Money(amount: 15456, currency: app.model.getCurrentCurrency())
			newPageView.initExpenses(amountSummary, forDate: NSDate())
			
		} else if type == "earnings" {
			pageIndex = 1
			let amountSummary = Money(amount: 542000, currency: app.model.getCurrentCurrency())
			newPageView.initEarnings(amountSummary, forDate: NSDate())
			
		} else {
			pageIndex = 2
			let amountSummary = Money(amount: 40000, currency: app.model.getCurrentCurrency())
			newPageView.initBudget(amountSummary, forDate: NSDate())
			
		}
		
		var frame = scrollView.bounds
		frame.origin.x = self.view.frame.size.width * CGFloat(pageIndex)
		frame.origin.y = 0.0
		newPageView.frame = frame

		return newPageView
	}
	
	override func scrollViewDidScroll(scrollView: UIScrollView) {
		// First, determine which page is currently visible
		let pageWidth = scrollView.frame.size.width
		let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
		
		// Update the page control
		pageScroll.currentPage = page
		print(page)
	}
	

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return transactions.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(kTransactionCellIdentifier, forIndexPath: indexPath) as! TransactionTableViewCell
		cell.setTransaction(transactions[indexPath.row])
		/*
		cell.flag.image = transactions[indexPath.row].currency.getFlag()
		cell.currencyCode.text = transactions[indexPath.row].currency.code
		cell.amount.text = transactions[indexPath.row].amount.stringValue
		cell.date.text = dateFormatter.stringFromDate(transactions[indexPath.row].date)*/
		return cell
	}

	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 90
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
