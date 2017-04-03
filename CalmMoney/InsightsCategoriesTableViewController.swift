//
//  InsightsCategoriesTableViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 13/12/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class InsightsCategoriesTableViewController: UITableViewController, TransactionsViewDelegate, CategoryEditProtocol {

	
	fileprivate let kCategoryCellHeight = 44
	fileprivate let kInsightsCategoryCellIdentifier = "InsightsCategoryCell"
	fileprivate let kShowCategoryTransactions = "ShowCategoryTransactions"
	
	var currentPeriod: PeriodMonth?
	internal var currentCategory: Category?
	
	var expenseCategories: [Category] = []
	var earningCategories: [Category] = []
	
	var finmath: Math?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
		NotificationCenter.default.addObserver(self,
			selector: #selector(InsightsCategoriesTableViewController.onModelDataChanged(_:)),
			name: NSNotification.Name(rawValue: app().model.kNotificationDataChanged),
			object: nil)
	}
	
    @IBAction func tapEdit(_ sender: UIBarButtonItem) {
		if tableView.isEditing {
			sender.title = "Edit".localized
			tableView.setEditing(false, animated: true)
		} else {
			tableView.setEditing(true, animated: true)
			sender.title = "Done".localized
		}
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		tableView.reloadData()
	}
	
	
	func onModelDataChanged(_ notification: Notification){
		loadData()
	}
	
	func loadData() {
		finmath = Math(
			transactions: app().model.getTransactionsListForPeriod(currentPeriod!),
			homeCurrency: app().model.getCurrentCurrency(),
			currentPeriod: currentPeriod!
		)
		
		earningCategories = finmath!.earningCategories
		expenseCategories = finmath!.expenseCategories
		
		earningCategories = app().model.getCategoriesList(false)
		tableView.reloadData()
	}

	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - TransactionsTVC delegate
	func getTransactions() -> [Transaction] {
		guard self.currentCategory != nil else {
			return []
		}
		return finmath!.getTransactionsForCategoryAndPeriod(self.currentCategory!)
	}
	
	func getCurrentPeriod() -> PeriodMonth {
		return currentPeriod!
	}
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
		/*
		let sectionsNumber = 0
		if earningCategories.count > 0 sectionsNumber += 1
		if expenseCategories.count > 0 sectionsNumber += 1
        return sectionsNumber
		*/
		return [earningCategories.count > 0, expenseCategories.count > 0].reduce(0, {
			if $1 {
				return $0 + 1
			} else {
				return $0
			}
		})
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (section == 0 && earningCategories.count > 0) {
			return earningCategories.count
		} else {
			return expenseCategories.count
		}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: kInsightsCategoryCellIdentifier, for: indexPath) as! InsightsCategoryTableViewCell
		
		var category: Category
		if (indexPath as NSIndexPath).section == 0 && earningCategories.count > 0 {
			category = earningCategories[(indexPath as NSIndexPath).row]
		} else {
			category = expenseCategories[(indexPath as NSIndexPath).row]
		}
		if let color = category.getColor(), !self.tableView.isEditing {
//			let bgView = UIView(frame: CGRect(x: 0, y:0, width: 5, height: kCategoryCellHeight + 2))
//			bgView.backgroundColor = color
			
			let bgView = UIView(frame: CGRect(x: 12, y:12, width: 20, height: 20))
			bgView.layer.cornerRadius = 10
			bgView.backgroundColor = color
			
			cell.addSubview(bgView)
		}
		cell.categoryName.text = category.name
		cell.categoryAmount.text = finmath!.getCategoryAmountForPeriod(category).formatToMoney()
		// cell.categoryAmount.text = NumberFormatter().formatterMoney(app().model.getCurrentCurrency()).string(from: finmath!.getCategoryAmountForPeriod(category))
		return cell
    }
	
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if (section == 0  && earningCategories.count > 0) {
			return "Earnings".localized
		} else {
			return "Expenses".localized
		}
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if (indexPath as NSIndexPath).section == 0 && earningCategories.count > 0 {
			self.currentCategory = earningCategories[(indexPath as NSIndexPath).row]
		} else {
			self.currentCategory = expenseCategories[(indexPath as NSIndexPath).row]
		}
		performSegue(withIdentifier: kShowCategoryTransactions, sender: nil)
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return CGFloat(kCategoryCellHeight)
	}
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

	
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if (editingStyle == UITableViewCellEditingStyle.delete) {
			deleteCategory(indexPath: indexPath as IndexPath)
		}
	}
	
	/*	
	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
		if (self.tableView.isEditing) {
			return UITableViewCellEditingStyle.delete
		}
		return .none
	}
	

	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "Delete".localized) { (action, indexPath) in
			self.deleteCategory(indexPath: indexPath)
		}
		
		let edit = UITableViewRowAction(style: .normal, title: "Edit".localized) { (action, indexPath) in
			self.showEditCateory(indexPath: indexPath)
		}
		edit.backgroundColor = UIColor(red:0.20, green:0.80, blue:0.00, alpha:1.0)
		
		return [delete, edit]
	}
	*/
	
	func showEditCateory(indexPath: IndexPath) {
		if indexPath.section == 0 && self.earningCategories.count > 0 {
			self.currentCategory = self.earningCategories[indexPath.row]
		} else {
			self.currentCategory = self.expenseCategories[indexPath.row]
		}
		let _ = CategoryEditView.show(delegate: self)
	}
	
	
	func deleteCategory(indexPath: IndexPath) {
		var category: Category
		if indexPath.section == 0 && self.earningCategories.count > 0 {
			category = self.earningCategories[indexPath.row]
		} else {
			category = self.expenseCategories[indexPath.row]
		}
		
		if category.getTransactions().count > 0 {
			self.present(Alerter().notify(title: "Category can not be removed".localized, message: "You have transactions assigned to this category. Please remove them first.".localized), animated: true, completion: nil)
		} else {
			if indexPath.section == 0 && self.earningCategories.count > 0 {
				self.earningCategories.remove(at: indexPath.row)
			} else {
				self.expenseCategories.remove(at: indexPath.row)
			}
			if tableView.numberOfRows(inSection: indexPath.section) == 1 {
				tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
			}else{
				tableView.deleteRows(at: [indexPath], with: .automatic)
			}
			self.app().model.deleteCategory(category)
		}
	}
	
	
	func saveCategory(name: String?, color: UIColor?) {
		if (name != nil && (name?.length)! > 0) {
			currentCategory?.name = name!
		}
		if color != nil {
			currentCategory?.logo = String(describing: color).data(using: .utf8) as NSData?
			/*
			(lldb) po color?.cgColor.components
			▿ Optional<Array<CGFloat>>
			▿ some : 4 elements
			- 0 : 0.95686274766922
			- 1 : 0.658823549747467
			- 2 : 0.545098066329956
			- 3 : 1.0
			*/
			//					category.logo = NSData(color)
		}
		self.app().model.saveStorage()
	}
	
	func getCategory() -> Category {
		return currentCategory!
	}
	
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

	override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		showEditCateory(indexPath: indexPath)
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == kShowCategoryTransactions {
			(segue.destination as! TransactionsTableViewController).transactionsViewDelegate = self
		}
    }

}
