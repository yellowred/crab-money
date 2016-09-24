//
//  loopback.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 13/9/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation
import LoopBack

class Backend {
	
	var adapter: LBRESTAdapter
	var customers: LBPersistedModelRepository
	var financials: LBPersistedModelRepository
	
	static let sharedInstance = Backend()
	
	init() {
		let adapterObject = LBRESTAdapter(url: URL(string: "http://0.0.0.0:3015/api/"))
		if (adapterObject === nil) {
			// Report any error we got.
			var dict = [String: AnyObject]()
			dict[NSLocalizedDescriptionKey] = "Failed to initialize an adapter" as AnyObject?
			dict[NSLocalizedFailureReasonErrorKey] = "Adapter is nil" as AnyObject?
			let error = NSError(domain: "BACKEND", code: 1, userInfo: dict)
			// Replace this with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			NSLog("Unresolved error \(error), \(error.userInfo)")
			abort()
		}
		adapter = adapterObject as LBRESTAdapter!
		customers = adapter.repository(withPersistedModelName: "BackendRepositoryCustomer")!
		financials = adapter.repository(withPersistedModelName: "BackendRepositoryFinancial")!
	}
	
	//	http://stackoverflow.com/questions/24939803/using-loopback-defined-data-relations-from-ios-sdk
	func save() {
		// let financialModel = Loopback.financials.model(with: nil) as? BackendModelFinancial
	}
	
	func saveOne() {
		let financial = financials.model(with: nil) as! BackendModelFinancial
		financial.amount = 777
		financial.date = Date()
		financial.rate = 1
		financial.text = "Obama"
		financial.uuid = "OB-AM-AM"
		
		var failure = { (error: (NSError!) -> Void) in
			// failure block
		}
		// financial.saveWithSuccess(nil, nil)
		/*
		financial.save(
			success: {() -> Void in
				NSLog("Financial saved")
			}, failure: nil
		)*/
	}
}
