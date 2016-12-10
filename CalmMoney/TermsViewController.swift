//
//  TermsViewController.swift
//  CalmMoney
//
//  Created by Oleg Kubrakov on 9/12/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    @IBOutlet weak var webpage: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
 		webpage.loadRequest(NSURLRequest(url: NSURL(string: "http://calm-money.com/licence.html")! as URL) as URLRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
