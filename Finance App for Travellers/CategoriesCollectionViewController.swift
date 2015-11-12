//
//  CategoriesCollectionViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 20/08/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

let reuseIdentifier = "CategoryCell"

class CategoriesCollectionViewController: UICollectionViewController {

	private var app: AppDelegate = {return UIApplication.sharedApplication().delegate as! AppDelegate}()
	var categories = [Category]()
	private let kCategoryCellIdentifier = "CategoryCell"
	private let kReturnCategory = "ReturnCategory"
	var category:Category?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
		//self.collectionView!.registerClass(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: kCategoryCellIdentifier)
		
		categories = app.model.getCategoriesList()
		debugPrint(categories)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
		print(categories.count)
        return categories.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCategoryCellIdentifier, forIndexPath: indexPath) as! CategoryCollectionViewCell
		cell.backgroundColor = UIColor.blackColor()
		cell.categoryTitle.text = categories[indexPath.row].name
		cell.category = categories[indexPath.row]
		cell.layer.cornerRadius = (collectionView.bounds.width - 30 * 4) / 4
		print(cell.categoryTitle.text)
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

	/*
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		if indexPath.row > categories.count {
			
		}
    }
*/

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
				//				collectionView?.reloadData()
			}
		}
	}
}
