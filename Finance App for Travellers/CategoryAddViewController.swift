//
//  CategoryAddViewController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 09/11/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class CategoryAddViewController: UIViewController, UITextFieldDelegate {

	var categoryName: String = ""
	var delegate: CategoriesCollectionViewController?
	
	@IBOutlet weak var category: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.category.delegate = self
		self.category.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		self.view.endEditing(true);
		performSegueWithIdentifier("saveCategory", sender: nil)
		return false;
	}

	
	// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let categoryNameTextUnwrapped = category.text {
			categoryName = categoryNameTextUnwrapped
		}
    }
	
}