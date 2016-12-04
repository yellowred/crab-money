//
//  Purchase.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 2/12/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import StoreKit

public class Purchase: NSObject, SKProductsRequestDelegate {
	
	public static var sharedInstance = Purchase()
	
	//MARK: - Initialize
	public override init() {
		super.init()
	}

	func canAddTransaction(to model: Model) -> Bool {
		if let transactionsMaxFree = Config.read(value: "transactions-max-free") {
			if model.getTransactionsList().count >= transactionsMaxFree as! Int {
				return false
			}
		}
		return true
	}
	
	
	func canUseConverter() -> Bool {
		return Config.read(value: "converter-free") as! Bool
	}
	
	
	func dumpAllProducts() {
		if let productDescriptions:NSDictionary = Config.read(value: "products") as! NSDictionary? {
			if let productName:String = productDescriptions["unlimited_transactions"] as! String? {
				dumpProductData(name: productName)
			}
		}
	}
	
	func dumpProductData(name: String) {
		SwiftyStoreKit.retrieveProductsInfo([name]) { result in
			if let productObject = result.retrievedProducts.first {
				let priceString = productObject.localizedPrice!
				print("Product: \(productObject.localizedDescription), price: \(priceString)")
				dump(productObject)
			}
			else if let invalidProductId = result.invalidProductIDs.first {
				dump(result)
				print("Invalid product identifier: \(invalidProductId)")
			}
			else {
				print("Error: \(result.error)")
			}
		}
	}
	
	func dumpProductDataNative(name: String) {
		let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: ["com.surfingcathk.calmmoney.unlimited_transactions"])
		productsRequest.delegate = self
		productsRequest.start()
	}
	
	public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
		dump(response)
	}
	
	public func request(_ request: SKRequest, didFailWithError error: Error) {
		dump(error)
	}
}
