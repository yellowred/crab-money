//
//  AllCurrenciesTableViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 20/07/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

protocol CurrencySelectDelegate {
	func setCurrency(_ currency: Currency)
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
		
		//searchController.hidesNavigationBarDuringPresentation = false
		//definesPresentationContext = false
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	// MARK: UISearchBarDelegate
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
	// MARK: UISearchControllerDelegate
	
	func presentSearchController(_ searchController: UISearchController) {
		debugPrint("UISearchControllerDelegate invoked method: \(#function).")
	}
	
	func willPresentSearchController(_ searchController: UISearchController) {
		debugPrint("UISearchControllerDelegate invoked method: \(#function).")
		
		//self.navigationController?.navigationBar.translucent = true;
	}
	
	func didPresentSearchController(_ searchController: UISearchController) {
		debugPrint("UISearchControllerDelegate invoked method: \(#function).")
	}
	
	func willDismissSearchController(_ searchController: UISearchController) {
		debugPrint("UISearchControllerDelegate invoked method: \(#function).")
		//self.navigationController?.navigationBar.translucent = true;
	}
	
	func didDismissSearchController(_ searchController: UISearchController) {
		debugPrint("UISearchControllerDelegate invoked method: \(#function).")
	}
	
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Potentially incomplete method implementation.
		// Return the number of sections.
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return allCurrencies.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifier = "AllCurrencyCell"
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AllCurrenciesTableViewCell
		cell.setCurrency(allCurrencies[(indexPath as NSIndexPath).row])
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		// Check to see which table view cell was selected.
		if tableView === self.tableView {
			selectedCurrency = allCurrencies[(indexPath as NSIndexPath).row]
			if self.selectedCurrency != nil {
				self.delegate!.setCurrency(self.selectedCurrency!)
			}
			self.dismiss(animated: true, completion: nil)
			self.navigationController?.popViewController(animated: true)
		}
		else {
			selectedCurrency = resultsTableController.filteredCurrencies[(indexPath as NSIndexPath).row]
			searchController.dismiss(animated: true, completion: {
				() in
				//(self.tableView.delegate as! AllCurrenciesTableViewController).performSegueWithIdentifier("addCurrencyToConverter", sender: nil)
				if self.selectedCurrency != nil {
					self.delegate!.setCurrency(self.selectedCurrency!)
				}
				self.navigationController?.popViewController(animated: true)
			})
			
		}
	}
	
	
	@IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}
	
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
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
	func updateSearchResults(for searchController: UISearchController)
	{
		guard let searchText = searchController.searchBar.text else {
			return
		}
		print(searchText)
		let searchPredicate = NSPredicate(format: "(code CONTAINS[c] %@ OR localizedName CONTAINS[c] %@) OR (code = %@)", searchText, searchText, searchText)
		let array = NSArray(array: allCurrencies).filtered(using: searchPredicate)
		
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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?)
	{
		if segue.identifier == "addCurrencyToConverter"
		{
			if let cell = sender as? UITableViewCell
			{
				let indexPath = tableView.indexPath(for: cell)
				if let index = (indexPath as NSIndexPath?)?.row
				{
					selectedCurrency = allCurrencies[index]
				}
			}
		}
	}


}
