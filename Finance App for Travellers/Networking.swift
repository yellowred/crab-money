//
//  Networking.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 09/07/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit
import Alamofire

//@see http://www.raywenderlich.com/85080/beginning-alamofire-tutorial
class Networking
{
	let kEventUpdateAll = "UpdateAll"
	
	private let api1:String = "http://api.fixer.io/latest?base=USD"
	private let api2:String = "https://openexchangerates.org/api/api/latest.json?app_id=fc667c4ed0af4675835f20c90b8a4276"
	private let currencyDownloadEndpoint:String = "http://sandbox.kubrakov.devel.local/currency.php"

	static let sharedInstance = Networking()
	
	lazy var crabApi: CrabApi = {return CrabApi()}()
	
	func updateAll() {
		crabApi.currencies({(data:AnyObject?) in
			for currencyRateData:NSDictionary in data as! [NSDictionary] {
				if let currency = self.app().model.getCurrencyByCode(currencyRateData.valueForKey("charcode") as! String) {
					currency.setValue(currencyRateData.valueForKey("rate"), forKey: "rate")
				}
			}
		})
		app().model.saveStorage()
		app().model.setEventTime(kEventUpdateAll)
	}
	
	func app() -> AppDelegate {
		return UIApplication.sharedApplication().delegate as! AppDelegate
	}
}