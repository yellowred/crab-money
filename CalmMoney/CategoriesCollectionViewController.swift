//
//  CategoriesCollectionViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 20/08/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

protocol CategorySelectDelegate {
	func setCategory(_ category:Category)
	func isExpense() -> Bool
}

class CategoriesCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate {

	var delegate:CategorySelectDelegate? = nil
	var categories: [Category]?
	fileprivate let kCategoryCellIdentifier = "CategoryCell"
	fileprivate let kReturnCategory = "ReturnCategory"
	var category:Category?
	var isDeletionModeActive:Bool = false
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

		categories = app().model.getCategoriesList(delegate!.isExpense())
		let longPress = UILongPressGestureRecognizer(target: self, action: #selector(CategoriesCollectionViewController.activateDeletionMode(_:)))
		longPress.delegate = self
		collectionView?.addGestureRecognizer(longPress)
		let tap = UITapGestureRecognizer(target: self, action: #selector(CategoriesCollectionViewController.endDeletionMode(_:)))
		tap.delegate = self
		collectionView?.addGestureRecognizer(tap)

    }

	@IBAction func cancelCategorySelect(_ sender: UIBarButtonItem) {
		self.navigationController?.dismiss(animated: true, completion: nil)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func activateDeletionMode(_ gr:UILongPressGestureRecognizer) {
		if gr.state == UIGestureRecognizerState.began {
			if let _ = collectionView?.indexPathForItem(at: gr.location(in: collectionView)) {
				isDeletionModeActive = true
				collectionView?.reloadData()
			}
		}
	}

	
	func endDeletionMode(_ gr:UILongPressGestureRecognizer) {
		if isDeletionModeActive {
			if let _ = collectionView?.indexPathForItem(at: gr.location(in: collectionView)) {
				isDeletionModeActive = false
				collectionView?.reloadData()
			}
		} else {
			if let indexPath:IndexPath = collectionView?.indexPathForItem(at: gr.location(in: collectionView)) {
				if let cell:CategoryCollectionViewCell = collectionView?.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
					delegate?.setCategory(cell.category!)
					self.dismiss(animated: true, completion: nil)
				}
			}
		}
	}
	

	func deleteCell(_ sender: UIButton) {
		if categories != nil {
			let indexPath:IndexPath = (collectionView?.indexPath(for: sender.superview?.superview as! UICollectionViewCell))!
			if let category = categories?[indexPath.row] {
				if category.getTransactions().count > 0 {
					present(Alerter().notify(title: "Category can not be removed".localized, message: "You have transactions assigned to this category. Please remove them first.".localized), animated: true, completion: nil)
				} else {
					categories!.remove(at: indexPath.row)
					collectionView?.deleteItems(at: [indexPath])
					app().model.deleteCategory(category)
				}
			}
		}
	}
	
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == kReturnCategory {
			if let categoryCell = sender as? CategoryCollectionViewCell {
				category = categoryCell.category
			}
		}
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return categories == nil ? 0 : categories!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCategoryCellIdentifier, for: indexPath) as! CategoryCollectionViewCell
		cell.categoryTitle.text = categories![(indexPath as NSIndexPath).row].name
		cell.category = categories![(indexPath as NSIndexPath).row]
		cell.categoryTitle.autoresizingMask = UIViewAutoresizing.flexibleHeight
		cell.categoryTitle.layer.masksToBounds = true
		cell.categoryTitle.layer.cornerRadius = (collectionView.bounds.width - 20 - 10 * 2) / 6
		//cell.contentView.superview?.clipsToBounds = false
		cell.deleteButton?.addTarget(self, action: #selector(CategoriesCollectionViewController.deleteCell(_:)), for: UIControlEvents.touchUpInside)

		
		if isDeletionModeActive {
			cell.showDeleteButton()
		} else {
			cell.hideDeleteButton()
		}
        return cell
    }
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
		let cellWidth = (collectionView.bounds.width - 20 - 10 * 2) / 3
		return CGSize(width: cellWidth, height: cellWidth)
	}

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */


    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		if isDeletionModeActive {
			return false
		}
		return true
    }


	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let cell:CategoryCollectionViewCell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
			delegate?.setCategory(cell.category!)
			performSegue(withIdentifier: kReturnCategory, sender: cell)
		}
	}
	
	
	
	@IBAction func returnCategoryToDelegate(_ segue:UIStoryboardSegue) {
		
	}
	
	@IBAction func addCategory(_ sender: UIBarButtonItem) {
		let alertController = UIAlertController(title: "Add category".localized, message: "", preferredStyle: .alert)
		
		let saveAction = UIAlertAction(title: "Add".localized, style: .default, handler: {
			alert -> Void in
			
			let firstTextField = alertController.textFields![0] as UITextField
			
			print("New category: \(String(describing: firstTextField.text))")
			if let categoryName = firstTextField.text {
				if categoryName != "" {
					let newCategory = self.app().model.createCategory(categoryName, isExpense: self.delegate!.isExpense(), logo: nil)
					self.app().model.saveStorage()
					self.categories!.append(newCategory)
					self.collectionView?.reloadData()
				}
			}
			
		})
		
		let cancelAction = UIAlertAction(title: "Cancel".localized, style: .default, handler: {
			(action : UIAlertAction!) -> Void in
			
		})
		
		alertController.addTextField { (textField : UITextField!) -> Void in
			textField.placeholder = "Category name".localized
			textField.autocapitalizationType = .sentences
		}
		alertController.addAction(saveAction)
		alertController.addAction(cancelAction)
		self.present(alertController, animated: true, completion: nil)
	}

}
