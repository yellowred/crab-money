//
//  CategoriesCollectionViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 20/08/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

let reuseIdentifier = "CategoryCell"

class CategoriesCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate {

	private var app: AppDelegate = {return UIApplication.sharedApplication().delegate as! AppDelegate}()
	var categories = [Category]()
	private let kCategoryCellIdentifier = "CategoryCell"
	private let kReturnCategory = "ReturnCategory"
	var category:Category?
	var isDeletionModeActive:Bool = false
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
		//self.collectionView!.registerClass(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: kCategoryCellIdentifier)
		
		categories = app.model.getCategoriesList()
		let longPress = UILongPressGestureRecognizer(target: self, action: "activateDeletionMode:")
		longPress.delegate = self
		collectionView?.addGestureRecognizer(longPress)
		let tap = UITapGestureRecognizer(target: self, action: "endDeletionMode:")
		tap.delegate = self
		collectionView?.addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func activateDeletionMode(gr:UILongPressGestureRecognizer) {
		if gr.state == UIGestureRecognizerState.Began {
			if let _ = collectionView?.indexPathForItemAtPoint(gr.locationInView(collectionView)) {
				isDeletionModeActive = true
				collectionView?.reloadData()
			}
		}
	}

	
	func endDeletionMode(gr:UILongPressGestureRecognizer) {
		if isDeletionModeActive {
			if let _ = collectionView?.indexPathForItemAtPoint(gr.locationInView(collectionView)) {
				isDeletionModeActive = false
				collectionView?.reloadData()
			}
		} else {
			if let indexPath:NSIndexPath = collectionView?.indexPathForItemAtPoint(gr.locationInView(collectionView)) {
				if let cell:CategoryCollectionViewCell = collectionView?.cellForItemAtIndexPath(indexPath) as? CategoryCollectionViewCell {
					category = cell.category
					performSegueWithIdentifier(kReturnCategory, sender: cell)
				}
			}
		}
	}
	

	func deleteCell(sender: UIButton) {
		let indexPath:NSIndexPath = (collectionView?.indexPathForCell(sender.superview?.superview as! UICollectionViewCell))!
		let category = categories.removeAtIndex(indexPath.row)
		collectionView?.deleteItemsAtIndexPaths([indexPath])
		app.model.deleteCategory(category)
	}
	
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == kReturnCategory {
			if let categoryCell = sender as? CategoryCollectionViewCell {
				category = categoryCell.category
			}
		}
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCategoryCellIdentifier, forIndexPath: indexPath) as! CategoryCollectionViewCell
		cell.categoryTitle.text = categories[indexPath.row].name
		cell.category = categories[indexPath.row]
		cell.categoryTitle.autoresizingMask = UIViewAutoresizing.FlexibleHeight
		cell.categoryTitle.layer.opacity = 0.7
		cell.categoryTitle.layer.masksToBounds = true
		cell.categoryTitle.layer.cornerRadius = (collectionView.bounds.width - 30 * 4) / 4
		//cell.contentView.superview?.clipsToBounds = false
		cell.deleteButton?.addTarget(self, action: "deleteCell:", forControlEvents: UIControlEvents.TouchUpInside)

		
		if isDeletionModeActive {
			cell.showDeleteButton()
		} else {
			cell.hideDeleteButton()
		}
        return cell
    }
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let cellWidth = (collectionView.bounds.width - 30 * 4) / 2
		return CGSize(width: cellWidth, height: cellWidth)
	}

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */


    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		if isDeletionModeActive {
			return false
		}
		return true
    }


    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
	@IBAction func createNewCategory(segue:UIStoryboardSegue) {
		if let createNewCategoryController = segue.sourceViewController as? CategoryAddViewController
		{
			print("New category: \(createNewCategoryController.categoryName)")
			
			if createNewCategoryController.categoryName != "" {
				let newCategory = app.model.createCategory(createNewCategoryController.categoryName, logo: nil)
				app.model.saveStorage()
				categories.append(newCategory)
				collectionView?.reloadData()
			}
		}
	}
}
