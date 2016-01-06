//
//  AllCurrenciesTableViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 20/07/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

protocol CurrencySelectDelegate {
	func setCurrency(currency: Currency)
	func getCurrencyList() -> [Currency]
}

class AllCurrenciesTableViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

	var delegate:CurrencySelectDelegate? = nil
	var allCurrencies = [Currency]()
	var selectedCurrency: Currency?
	
	/// Search controller to help us with filtering.
	var searchController: UISearchController!
	
	/// Secondary search results table view.
	var resultsTableController: ResultsTableController!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard delegate != nil else {
			print("Delegate should be set for AllCurrenciesTableViewController.")
			abort()
		}
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem()
		allCurrencies = delegate!.getCurrencyList()
		

		resultsTableController = ResultsTableController()
		
		// We want to be the delegate for our filtered table so didSelectRowAtIndexPath(_:) is called for both tables.
		resultsTableController.tableView.delegate = self
		
		searchController = UISearchController(searchResultsController: resultsTableController)
		searchController.searchResultsUpdater = self
		searchController.searchBar.sizeToFit()
		tableView.tableHeaderView = searchController.searchBar
		
		searchController.delegate = self
		searchController.dimsBackgroundDuringPresentation = false // default is YES
		searchController.searchBar.delegate = self    // so we can monitor text changes + others
		/*
		Search is now just presenting a view controller. As such, normal view controller
		presentation semantics apply. Namely that presentation will walk up the view controller
		hierarchy until it finds the root view controller or one that defines a presentation context.
		*/
		definesPresentationContext = true
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	// MARK: UISearchBarDelegate
	
	func searchBarSearchButtonClicked(searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
	// MARK: UISearchControllerDelegate
	
	func presentSearchController(searchController: UISearchController) {
		debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
	}
	
	func willPresentSearchController(searchController: UISearchController) {
		debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
	}
	
	func didPresentSearchController(searchController: UISearchController) {
		debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
	}
	
	func willDismissSearchController(searchController: UISearchController) {
		debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
	}
	
	func didDismissSearchController(searchController: UISearchController) {
		debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
	}
	
	
	// MARK: - Table view data source
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		// #warning Potentially incomplete method implementation.
		// Return the number of sections.
		return 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return allCurrencies.count
	}
	
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellIdentifier = "AllCurrencyCell"
		let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AllCurrenciesTableViewCell
		cell.setCurrency(allCurrencies[indexPath.row])
		return cell
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		// Check to see which table view cell was selected.
		if tableView === self.tableView {
			selectedCurrency = allCurrencies[indexPath.row]
			if self.selectedCurrency != nil {
				self.delegate!.setCurrency(self.selectedCurrency!)
			}
			self.dismissViewControllerAnimated(true, completion: nil)
			self.navigationController?.popViewControllerAnimated(true)
		}
		else {
			selectedCurrency = resultsTableController.filteredCurrencies[indexPath.row]
			searchController.dismissViewControllerAnimated(true, completion: {
				() in
				//(self.tableView.delegate as! AllCurrenciesTableViewController).performSegueWithIdentifier("addCurrencyToConverter", sender: nil)
				if self.selectedCurrency != nil {
					self.delegate!.setCurrency(self.selectedCurrency!)
				}
				self.navigationController?.popViewControllerAnimated(true)
			})
			
		}
	}
	
	
	@IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
		self.dismissViewControllerAnimated(true, completion: nil)
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
	
	
	// MARK: - Search Bar
	func updateSearchResultsForSearchController(searchController: UISearchController)
	{
		guard let searchText = searchController.searchBar.text else {
			return
		}
		print(searchText)
		let searchPredicate = NSPredicate(format: "(code CONTAINS[c] %@) OR (name CONTAINS[c] %@) OR (code = %@)", searchText, searchText, searchText)
		let array = NSArray(array: allCurrencies).filteredArrayUsingPredicate(searchPredicate)
		
		// Hand over the filtered results to our search results table.
		let resultsController = searchController.searchResultsController as! ResultsTableController
		resultsController.filteredCurrencies = array as! [Currency]
		resultsController.tableView.reloadData()

	}
	
	/*
	func filterContentForSearchText(searchText: String) {
		// Filter the array using the filter method
		self.filteredCurrencies = self.allCurrencies.filter({(currency: Currency) -> Bool in
			let nameMatch = currency.name!.rangeOfString(searchText)
			let codeMatch = currency.code.rangeOfString(searchText)
			return (nameMatch != nil) && (codeMatch != nil)
		})
	}
	
	func searchController(controller: UISearchController, shouldReloadTableForSearchString searchString: String?) -> Bool {
		guard searchString != nil else {
			return true
		}
		self.filterContentForSearchText(searchString!)
		return true
	}
 
	func searchController(controller: UISearchController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
		self.filterContentForSearchText(self.searchController!.searchBar.text!)
		return true
	}
	*/
	
	// MARK: - Navigation
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		if segue.identifier == "addCurrencyToConverter"
		{
			if let cell = sender as? UITableViewCell
			{
				let indexPath = tableView.indexPathForCell(cell)
				if let index = indexPath?.row
				{
					selectedCurrency = allCurrencies[index]
				}
			}
		}
	}


}
