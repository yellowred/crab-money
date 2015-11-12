/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
The table view controller responsible for displaying the filtered products as the user types in the search field.
*/

import UIKit

class ResultsTableController: UITableViewController {
    // MARK: Properties
    
	var filteredCurrencies = [Currency]()
	
	let kNibName = "AllCurrenciesSearchCell"
	let kCellIdentifier = "AllCurrenciesSearchCell"
	
	// MARK: View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let nib = UINib(nibName: kNibName, bundle: nil)
		tableView.registerNib(nib, forCellReuseIdentifier: kCellIdentifier)
	}
	
    // MARK: UITableViewDataSource
	
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCurrencies.count
    }
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath) as! AllCurrenciesTableViewCell
		cell.setCurrency(filteredCurrencies[indexPath.row])
		return cell
	}
	
}
