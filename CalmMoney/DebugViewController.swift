//
//  DebugViewController.swift
//  CalmMoney
//
//  Created by Oleg Kubrakov on 1/1/2017.
//  Copyright © 2017 Oleg Kubrakov. All rights reserved.
//

import UIKit

class DebugViewController: UIViewController {

    @IBOutlet weak var debugInfo: UITextView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func debugApp(_ sender: UIButton) {
		print("OK DEBUG")
		let currencies = app().model.getCurrenciesList()
		var index = 0
		var errors = 0
		for elem in currencies {
			debugInfo.text = debugInfo.text + "\n" + elem.code + " checking..."
			index += 1
			if elem.rate == NSDecimalNumber.notANumber {
				
				print(elem, "is not a number")
				
				debugInfo.text = debugInfo.text + "\n" + elem.code + " has not a number in rate"
				errors += 1
			}
		}
		debugInfo.text = debugInfo.text + "\nTotal currencies checked: " + String(index) + ". Errors found: " + String(errors)
    }

    @IBAction func exitDebug(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
