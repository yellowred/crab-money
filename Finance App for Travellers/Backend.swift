//
//  loopback.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 13/9/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class Backend {
	static let kEventUpdateAll = "UpdateAll"
	static let kEventUpdateAllMinHours = 4

	static let API_URL:String = "http://calm-money.com/api/"
	static let sharedInstance = Backend()
	
	func sendFinancials(transactions: [Transaction], callback: @escaping () -> Void) -> Void {
		let financials = transactions.map({transaction in
			return transaction.encode()
		})
		let data = try! JSONSerialization.data(withJSONObject: financials, options: [])
		let jsonBatch:String = String(data: data, encoding: .utf8)!
		Alamofire.request(Backend.API_URL + "financials", method: .post, parameters: [:], encoding: jsonBatch, headers: [:]).responseJSON { response in
			debugPrint(response)
			callback()
		}
	}
	
	
	func updateRates() {
		let lastUpdateTime = self.app().model.getEventTime(Backend.kEventUpdateAll)
		if (lastUpdateTime == nil || lastUpdateTime!.getHoursTo(Date()) > Backend.kEventUpdateAllMinHours)
		{
			print("*** Backend: updateRates")
			print(Backend.API_URL + "currencies")
			Alamofire.request(Backend.API_URL + "currencies").responseJSON().then { response -> Void in
				print(response)
				//to get status code
				let JSON = response as! Array<NSDictionary>
				for currencyRateData:NSDictionary in JSON {
					if
						let currency = self.app().model.getCurrencyByCode(currencyRateData.value(forKey: "code") as! String)
					{
						let stringRate = String(describing: currencyRateData.value(forKey: "rate")!)
						let rate = NSDecimalNumber(string: stringRate, locale: Locale(identifier: "en_US"))
						currency.setValue(rate, forKey: "rate")
					}
				}
				self.app().model.saveStorage()
				self.app().model.setEventTime(Backend.kEventUpdateAll)
				print("*** Networking: UpdateAll: ", self.app().model.getEventTime(Backend.kEventUpdateAll) ?? "nil")
			}.catch{ error in
				print("*** Backend: error", error)
			}
		}
		
	}

	/*
	как делать загрузку в бэкраунде с помощью alamofire
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
	*/
	
	func app() -> AppDelegate {
		return UIApplication.shared.delegate as! AppDelegate
	}
}
