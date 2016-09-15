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
	let kEventUpdateAllMinHours = 4
	
	fileprivate let api1:String = "http://api.fixer.io/latest?base=USD"
	fileprivate let api2:String = "https://openexchangerates.org/api/api/latest.json?app_id=fc667c4ed0af4675835f20c90b8a4276"
	fileprivate let currencyDownloadEndpoint:String = "http://sandbox.kubrakov.devel.local/currency.php"

	static let sharedInstance = Networking()
	
	lazy var crabApi: CrabApi = {return CrabApi()}()

	lazy var backgroundManager: Alamofire.Manager = {
		let bundleIdentifier = Bundle.main.bundleIdentifier
		return Alamofire.Manager(configuration: URLSessionConfiguration.background(withIdentifier: bundleIdentifier! + ".background"))
	}()
	
	var backgroundCompletionHandler: (() -> Void)? {
		get {
			return backgroundManager.backgroundCompletionHandler
		}
		set {
			backgroundManager.backgroundCompletionHandler = newValue
		}
	}

	
	func updateAll(_ finishCallback: ((_ data: AnyObject?) -> Void)?) {
		print("*** Networking: UpdateAll")
		let lastUpdateTime = self.app().model.getEventTime(self.kEventUpdateAll)
		if (lastUpdateTime == nil || lastUpdateTime!.getHoursTo(Date()) > kEventUpdateAllMinHours)
		{
			crabApi.currencies({(data:AnyObject?) in
				if finishCallback != nil {
					finishCallback!(data: data)
				}
				for currencyRateData:NSDictionary in data as! [NSDictionary] {
					if
						let currency = self.app().model.getCurrencyByCode(currencyRateData.value(forKey: "charcode") as! String)
					{
						let stringRate = String(currencyRateData.value(forKey: "rate")!)
						let rate = NSDecimalNumber(string: stringRate, locale: Locale(localeIdentifier: "en_US"))
						currency.setValue(rate, forKey: "rate")
					}
				}
				self.app().model.saveStorage()
				self.app().model.setEventTime(self.kEventUpdateAll)
				print("*** Networking: UpdateAll: ", self.app().model.getEventTime(self.kEventUpdateAll))
			})
		}
	}
	
	
	func app() -> AppDelegate {
		return UIApplication.shared.delegate as! AppDelegate
	}
}
