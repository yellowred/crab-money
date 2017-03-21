//
//  InsightsCategoriesTableViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 13/12/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class InsightsCategoriesTableViewController: UITableViewController, TransactionsViewDelegate {

	fileprivate let kInsightsCategoryCellIdentifier = "InsightsCategoryCell"
	fileprivate let kShowCategoryTransactions = "ShowCategoryTransactions"
	
	var currentPeriod: PeriodMonth?
	
	var expenseCategories: [Category] = []
	var earningCategories: [Category] = []
	
	var currentCategory: Category?
	var finmath: Math?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		loadData()
		NotificationCenter.default.addObserver(self,
			selector: #selector(InsightsCategoriesTableViewController.onModelDataChanged(_:)),
			name: NSNotification.Name(rawValue: app().model.kNotificationDataChanged),
			object: nil)
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
		return 44
	}
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

	
	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let delete = UITableViewRowAction(style: .destructive, title: "Delete".localized) { (action, indexPath) in
			
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
		
		let edit = UITableViewRowAction(style: .normal, title: "Edit".localized) { (action, indexPath) in
			// share item at indexPath
			
			var category: Category
			if indexPath.section == 0 && self.earningCategories.count > 0 {
				category = self.earningCategories[indexPath.row]
			} else {
				category = self.expenseCategories[indexPath.row]
			}
		
			let alertController = UIAlertController(title: "Edit category".localized, message: "", preferredStyle: .alert)
			
			let saveAction = UIAlertAction(title: "Save".localized, style: .default, handler: {
				alert -> Void in
				
				let firstTextField = alertController.textFields![0] as UITextField
				
				if let categoryName = firstTextField.text {
					if categoryName != "" {
						category.name = categoryName
						self.app().model.saveStorage()
					}
				}
				
			})
			
			let cancelAction = UIAlertAction(title: "Cancel".localized, style: .default, handler: {
				(action : UIAlertAction!) -> Void in
				
			})
			
			alertController.addTextField { (textField : UITextField!) -> Void in
				textField.placeholder = "Category name".localized
				textField.autocapitalizationType = .sentences
				textField.text = category.name
			}
			let colorSelectView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
			
			let redColor = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
			redColor.backgroundColor = UIColor.red
			
			let greenColor = UIView(frame: CGRect(x: 40, y: 0, width: 40, height: 30))
			redColor.backgroundColor = UIColor.green
			
			colorSelectView.addSubview(redColor)
			colorSelectView.addSubview(greenColor)
			
			alertController.view.addSubview(colorSelectView)
			alertController.addAction(saveAction)
			alertController.addAction(cancelAction)
			self.present(alertController, animated: true, completion: nil)

				
		}
		edit.backgroundColor = UIColor(red:0.20, green:0.80, blue:0.00, alpha:1.0)
		
		return [delete, edit]
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
