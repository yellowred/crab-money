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

enum PurchaseError: Error {
	case cantFindProductBy(tag: Int)
}

public class Purchase: NSObject, SKProductsRequestDelegate {
	
	public static var sharedInstance = Purchase()
	
	//MARK: - Initialize
	public override init() {
		super.init()
	}

	func canAddTransaction(to model: Model) -> Bool {
		if let transactionsMaxFree = Config.read(value: "transactions-max-free") {
			if model.getTransactionsList().count >= transactionsMaxFree as! Int {
				return isPurchasedUnlimitedTransactions()
			}
		}
		return true
	}
	
	
	func canUseConverter() -> Bool {
		let isFree = Config.read(value: "converter-free") as! Bool
		return isFree || isPurchasedConverter()
	}
	
	func getConverterProducts(cb:@escaping (RetrieveResults)->()) {
		if let products = getConverterProductIds() {
			let productsSet:Set<String> = Set(products)
			SwiftyStoreKit.retrieveProductsInfo(productsSet, completion: cb)
		} else {
			print("No converter products configs found")
		}
	}
	
	
	func getConverterProductIds() -> Array<String>? {
		guard let productDescriptions:NSDictionary = Config.read(value: "products") as! NSDictionary? else {
			return nil
		}
		return productDescriptions["converter"] as! Array<String>?
	}
	
	func purchase(productId: String, cb: @escaping (PurchaseResult) -> ()) {
		print("Purchasing: \(productId)")
		SwiftyStoreKit.purchaseProduct(productId, completion: cb)
	}
	
	
	func setPurchasedConverter() {
		UserDefaults.standard.set(true, forKey: "purchase_converter")
	}
	
	
	func setPurchasedUnlimitedTransactions() {
		UserDefaults.standard.set(true, forKey: "unlimited_transactions")
	}
	
	
	func setPurchased(productId: String) {
		if (getConverterProductIds()?.contains(productId))! {
			setPurchasedConverter()
		} else if getUnlimitedTransactionsProductId() == productId {
			setPurchasedUnlimitedTransactions()
		} else {
			print("Unrecognized productId: \(productId)")
		}
	}
	
	
	func isPurchasedConverter() -> Bool {
		return UserDefaults.standard.bool(forKey: "purchase_converter")
	}
	
	
	func isPurchasedUnlimitedTransactions() -> Bool {
		return UserDefaults.standard.bool(forKey: "unlimited_transactions")
	}
	
	
	func getUnlimitedTransactionsProductId() -> String? {
		if let productDescriptions:NSDictionary = Config.read(value: "products") as! NSDictionary? {
			return productDescriptions["unlimited_transactions"] as? String
		} else {
			return nil
		}
	}
	
	
	func restorePurchases(cb: @escaping (String) -> ()) {
		SwiftyStoreKit.restorePurchases(atomically: true) { results in
			var message = ""
			if results.restoreFailedProducts.count > 0 {
				print("Restore Failed: \(results.restoreFailedProducts)")
				message = "Can not restore. Please check the internet connection and try again.".localized
			}
			else if results.restoredProducts.count > 0 {
				print("Restore Success: \(results.restoredProducts)")
				message = "Succesful.".localized + " \(results.restoredProducts.count) " + " products have been restored.".localized
			}
			else {
				print("Nothing to Restore")
				message = "Nothing to restore. Please purchase a PRO version or Currency Converter.".localized
			}
			cb(message)
		}
	}
	
	
	func canMakePayments() -> Bool {
		return SwiftyStoreKit.canMakePayments
	}
	
	//MARK: - Dump
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
