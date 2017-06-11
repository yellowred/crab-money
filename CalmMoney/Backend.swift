//
//  loopback.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 13/9/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation
import Alamofire

class Backend {
	static let kEventUpdateAll = "UpdateAll"
	static let kEventUpdateAllMinHours = 4

	
	static let API_URL:String = "http://calm-money.com/api/"
	static let sharedInstance = Backend()
	
	
	// backup user data
	// NOT IMPLEMENTED
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
	
	
	func updateRates(model: Model, completionHandler: ((Array<Any>) -> Void)?) {
		let lastUpdateTime = self.app().model.getEventTime(Backend.kEventUpdateAll)
		if (Purchase().isPurchasedConverter() || lastUpdateTime == nil) {
			if (lastUpdateTime == nil || lastUpdateTime!.getHoursTo(Date()) > Backend.kEventUpdateAllMinHours)
			{
				print("*** Backend: updateRates")
				print(Backend.API_URL + "currencies?filter[fields][code]=true&filter[fields][rate]=true")
				Alamofire.request(Backend.API_URL + "currencies?filter[fields][code]=true&filter[fields][rate]=true").responseJSON() {
					response in
					var array:Array<NSDictionary> = []
					if (response.result.isSuccess) {
						array = response.result.value as! Array<NSDictionary>
					}
					
					model.saveRatesFrom(array: array)
					model.setEventTime(Backend.kEventUpdateAll)
					completionHandler?(array)
				}
			}
		}
	}

	
	lazy var backgroundManager: Alamofire.SessionManager = {
		let bundleIdentifier = Bundle.main.bundleIdentifier
		return Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: bundleIdentifier! + ".background"))
	}()
	
	
	var backgroundCompletionHandler: (() -> Void)? {
		get {
			return backgroundManager.backgroundCompletionHandler
		}
		set {
			backgroundManager.backgroundCompletionHandler = newValue
		}
	}
	
	
	func app() -> AppDelegate {
		return UIApplication.shared.delegate as! AppDelegate
	}
}
