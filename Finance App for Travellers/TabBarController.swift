//
//  TabBarController.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 18/01/16.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	override func encodeRestorableState(with coder: NSCoder) {
		super.encodeRestorableState(with: coder)
		coder.encode(self.selectedIndex, forKey: "TabBarCurrentTab")
		print("Encode state", self.selectedIndex)
	}
	
	override func decodeRestorableState(with coder: NSCoder) {
		super.encodeRestorableState(with: coder)
		self.selectedIndex = coder.decodeInteger(forKey: "TabBarCurrentTab")
		print("Decode state", self.selectedIndex)
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
