//
//  Finance_App_for_TravellersTests.swift
//  Finance App for TravellersTests
//
//  Created by Oleg Kubrakov on 19/06/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit
import XCTest
//import ChameleonFramework

//@testable import Finance_App_for_Travellers;


class Finance_App_for_TravellersTests: XCTestCase {
	
	//var model: Model = {return TestModel()}()
	
	var transactions = [Transaction]()
	var currencies = [Currency]()
	
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		//preloadData()
		currencies = [
			Currency(code: "RUB", rate: 100),
			Currency(code: "AUD", rate: 1.5),
			Currency(code: "USD", rate: 1),
		]
		transactions = [
			Transaction(amount: -3000, date: "2015-11-15 10:00:00", rate: 100, currency: currencies[0]),
			Transaction(amount: -100, date: "2015-11-16 10:00:00", rate: 1, currency: currencies[2]),
			Transaction(amount: -300, date: "2015-12-05 10:00:00", rate: 1.5, currency: currencies[1]),
			Transaction(amount: 3000, date: "2015-11-18 10:00:00", rate: 1.5, currency: currencies[2]),
			Transaction(amount: 2000, date: "2015-11-18 11:00:00", rate: 2, currency: currencies[2]),
		]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMath() {
		XCTAssertEqual(transactions.count, 5)
		XCTAssertEqual(currencies.count, 3)
		let math = Math(
			transactions: transactions,
			homeCurrency: currencies[2],
			currentPeriod: Period(
				startDate: NSDate().fromString("2015-11-15 10:00:00")!,
				endDate: NSDate().fromString("2015-12-15 10:00:00")!,
				length: PeriodLength.Month,
				initialDate: NSDate().fromString("2015-10-15 10:00:00")!
			)
		)
		XCTAssertEqual(math.expenses.count, 3)
		XCTAssertEqual(math.earnings.count, 2)
		XCTAssertEqual(math.earningsTotal, 3000)
		XCTAssertEqual(math.expensesTotal, 330)
		XCTAssertEqual(math.expensesAvg, 11)
		XCTAssertEqual(math.earningsAvg, 100)
		XCTAssertEqual(math.expensesProjected, 330)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
	
	
	/*
	func preloadData () {
		// Retrieve data from the source file
		populateCurrenciesWithData(loadDataFromJson("currencies")!)
		populateCategoriesWithData(loadDataFromJson("categories")!)
		populateTransactionsWithData(loadDataFromJson("transactions")!)
	}

	
	func loadDataFromJson(name: String) -> [NSDictionary]? {
		if let contentsOfURL = NSBundle(forClass: self.dynamicType).URLForResource(name, withExtension: "json") {
			let parsedObject: AnyObject?
			do {
				parsedObject = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: contentsOfURL)!,
					options: NSJSONReadingOptions.AllowFragments)
			} catch let error as NSError {
				parsedObject = nil
				debugPrint(error)
				abort()
			}
			if let parsedDictionary = parsedObject as? [NSDictionary] {
				return parsedDictionary
			}
		}
		return nil
	}
	
	func getCurrencyByCode(code: String) {
		
	}
	
	func populateCurrenciesWithData(data: [NSDictionary]) {
		var flagPngData:NSData? = nil
		for currencyData:NSDictionary in data
		{
			if currencyData.valueForKey("flag") != nil
			{
				
				flagPngData = NSData(base64EncodedString: currencyData.valueForKey("flag") as! String, options: [])
			}
			else
			{
				flagPngData = nil
			}
			let currency = model.createCurrency(
				currencyData.valueForKey("code") as! String,
				rate: currencyData.valueForKey("rate") as! Float,
				flag: flagPngData,
				name: currencyData.valueForKey("name") as? String
				//					country: model.getCountryByCode(currencyData.valueForKey("country") as! String)
			)
			print(currency)
		}
		model.saveStorage()
	}
	
	func populateCategoriesWithData(data: [NSDictionary]) {
		for categoryData:NSDictionary in data
		{
			let _ = model.createCategory(categoryData.valueForKey("name") as! String, logo: nil)
		}
	}
	
	func populateTransactionsWithData(data: [NSDictionary]) {
		for transactionData:NSDictionary in data
		{
			let newTransaction = model.createTransaction(
				Money(amount: NSDecimalNumber(float: transactionData.valueForKey("amount") as! Float), currency: model.getCurrencyByCode(transactionData.valueForKey("currency") as! String)!),
				isExpense: transactionData.valueForKey("isExpense") as! Bool)
			newTransaction.setValue(NSDate().fromString(transactionData.valueForKey("date") as! String), forKey: "date")
			newTransaction.setValue(NSDecimalNumber(integer: transactionData.valueForKey("rate") as! Int), forKey: "rate")
			newTransaction.category = model.getCategoriesList().first
		}
	}
*/
}
