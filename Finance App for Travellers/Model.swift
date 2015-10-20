//
//  CurrencyModel.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 07/07/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit
import CoreData

extension NSManagedObject
{
	
	func dumpProperties() {
		for (key, _) in entity.propertiesByName {
			print("\"\(key)\": \(valueForKey(key))")
		}
	}
}


class Model
{
	
	private var context: NSManagedObjectContext
	private var model: NSManagedObjectModel
	

	init(context: NSManagedObjectContext, model: NSManagedObjectModel) {
		self.context = context
		self.model = model
	}
	
	
	func saveStorage()
	{
		var error: NSError? = nil
		if context.hasChanges
		{
			do {
				try context.save()
			} catch let error1 as NSError {
				error = error1
				// Replace this implementation with code to handle the error appropriately.
				// abort() causes the application to generate a crash log and terminate.
				// You should not use this function in a shipping application, although it may be useful during development.
				NSLog("Unresolved error \(error), \(error!.userInfo)")
				abort()
			}
		}
	}
	
	
    // MARK: - Populating
    
    func createFakeData()
    {
        clearStorage()
        
        /*
        let russia: Country = createCountry("RU", name: "Россия");
        let usa: Country = createCountry("US", name: "США");
        let australia: Country = createCountry("AU", name: "Австралия");*/
        
        /*
        createCurrency("RUB", value: 25, country: russia)
        createCurrency("USD", value: 100, country: usa)
        createCurrency("AUD", value: 85, country: australia)*/

        saveStorage()
        
        //
        //        currencies = [
        //            Currency(code: "RUB", country: "RU", rate: 25, flag: UIImage(named: "flag_ru"))!,
        //            Currency(code: "USD", country: "RU", rate: 100, flag: UIImage(named: "flag_us"))!,
        //            Currency(code: "AUD", country: "RU", rate: 85, flag: UIImage(named: "flag_au"))!
        //        ]
    }
	
	func preloadData () {
		if !isEventHappen("prepopulateCurrencies") {
			clearCurrencies()
			
			// Retrieve data from the source file
			if let contentsOfURL = NSBundle.mainBundle().URLForResource("currencies", withExtension: "json") {
				let parsedObject: AnyObject?
				do {
					parsedObject = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: contentsOfURL)!,
						options: NSJSONReadingOptions.AllowFragments)
				} catch let error as NSError {
					parsedObject = nil
					debugPrint(error)
					abort()
				}
				if let currencies = parsedObject as? [NSDictionary] {
					populateCurrenciesWithData(currencies)
					setEventHappen("prepopulateCurrencies")
				}
			}
		}
	}
	
	func populateCurrenciesWithData(data: [NSDictionary]) {
		print(data);
		var flagPngData:NSData? = nil
		var currencyIndex = 0;
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
			let currency = createCurrency(
				currencyData.valueForKey("code") as! String,
				rate: currencyData.valueForKey("rate") as! Float,
				flag: flagPngData,
				name: currencyData.valueForKey("name") as? String
				//					country: model.getCountryByCode(currencyData.valueForKey("country") as! String)
			)
			if currency != nil
			{
				currency?.dumpProperties()
				currencyIndex++
			}
			else
			{
				print("Skipped currency: ", currencyData.valueForKey("code"), currencyData.valueForKey("country"))
			}
			
		}
		print("Populated: \(currencyIndex)")
		saveStorage()
	}
	
    // MARK: - Model Manipulations
   
    func createEntity(name: String) -> NSEntityDescription
    {
        return NSEntityDescription.entityForName("Currency", inManagedObjectContext: context)!
    }
	
    
	func createCountry(code: String, name: String, flag: NSData?, currency: Currency) -> (Country)
    {
        let newCountry = NSEntityDescription.insertNewObjectForEntityForName( NSStringFromClass(Country.classForCoder()), inManagedObjectContext: context) as! Country
        
        //let newCountry = Country(entity: createEntity("Country"), insertIntoManagedObjectContext:context) as Country
        
        newCountry.setValue(code, forKey: "code")
        newCountry.setValue(name, forKey: "name")
        newCountry.setValue(currency, forKey: "currency")
        if flag != nil
        {
            newCountry.setValue(flag!, forKey: "flag")
        }

		print("Country", newCountry.valueForKey("code"), newCountry.valueForKey("flag"))
        
        return newCountry
    }

	
	
    func clearStorage()
    {
        for currency: Currency in getCurrenciesList()
        {
            context.deleteObject(currency)
        }
        for country: Country in getCountriesList()
        {
            context.deleteObject(country)
        }
        
        do {
			try context.save()
		} catch _ {
		}
    }
	
	
	func clearCountries()
	{
		for country: Country in getCountriesList()
		{
			context.deleteObject(country)
		}
		do {
			try context.save()
		} catch _ {
		}
	}
	
	
	func getObjectsList(objectClass: AnyClass) -> [AnyObject] {
		// Create request on Event entity
		let fetchRequest = NSFetchRequest(entityName: NSStringFromClass(objectClass))
		
		//Execute Fetch request
		var fetchedResults = Array<AnyObject>()
		do {
			fetchedResults = try context.executeFetchRequest(fetchRequest)
		} catch let fetchError as NSError {
			print("getObjectsList error: \(fetchError.localizedDescription)")
		}
		
		return fetchedResults
	}
	
	
    func getCountriesList() -> [Country]
    {
		return getObjectsList(Country.classForCoder()) as! [Country]
    }
	
 
	func getCountryByCode(code:String) -> Country?
	{
		let fetchRequest = NSFetchRequest(entityName:"Country")
		let pred = NSPredicate(format: "(code = %@)", code)
		fetchRequest.predicate = pred
	
		var fetchedResults = Array<Country>()
		do {
			try fetchedResults = context.executeFetchRequest(fetchRequest) as! [Country]
		} catch let fetchError as NSError {
			print("getCountryByCode error: \(fetchError.localizedDescription)")
		}
		if fetchedResults.count > 0
		{
			return fetchedResults.first
		}
		else
		{
			return nil
		}
	}
	
 
	func getCurrencyByCode(code:String) -> Currency?
	{
		let fetchRequest = NSFetchRequest(entityName:"Currency")
		let pred = NSPredicate(format: "(code = %@)", code)
		fetchRequest.predicate = pred
		
		var fetchedResults = Array<Currency>()
		do {
			try fetchedResults = context.executeFetchRequest(fetchRequest) as! [Currency]
		} catch let fetchError as NSError {
			print("getCountryByCode error: \(fetchError.localizedDescription)")
		}
		if fetchedResults.count > 0
		{
			return fetchedResults.first
		}
		else
		{
			return nil
		}
	}
	
	
    func showAllEntities()
    {
		let appDelegate     = UIApplication.sharedApplication().delegate as! AppDelegate
        print("All loaded entities are: \(appDelegate.managedObjectModel.entitiesByName)");
    }
	
	
	// MARK: - Currency
	
	func createCurrency(code: String, rate: Float, flag: NSData?, name: String?) -> Currency?
	{
		let newCurrency = Currency(entity: createEntity("Currency"),
			insertIntoManagedObjectContext:context) as Currency
		
		newCurrency.setValue(code, forKey: "code")
		newCurrency.setValue(rate, forKey: "rate")
		newCurrency.setValue(flag, forKey: "flag")
		newCurrency.setValue(name, forKey: "name")
		return newCurrency
	}
	
	func clearCurrencies() -> Bool
	{
		//Persist deletion
		var success:Bool
		do {
			for currency: Currency in getCurrenciesList()
			{
				context.deleteObject(currency)
			}
			
			//Persist deletion to datastore
			try context.save()
			success = true
		} catch let deleteError as NSError {
			print("clearCurrencies error: \(deleteError.localizedDescription)")
			success = false
		}
		return success
	}
	
	
	func getCurrenciesList() -> [Currency]
	{
		return getObjectsList(Currency.classForCoder()) as! [Currency]
	}
	
	
	func getCurrenciesNotInConverter() -> [Currency]
	{
		/*
		let fetchRequest = NSFetchRequest(entityName:"Currency")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "code", ascending: true)]
		fetchRequest.predicate = NSPredicate(format: "handsOnCurrency == nil || handsOnCurrency.@count =0")
		*/
		
		let fetchRequest = NSFetchRequest(entityName: NSStringFromClass(Currency.classForCoder()))
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "code", ascending: true)]
		fetchRequest.predicate = NSPredicate(format: "in_converter <> 1")
		
		var fetchedResults = Array<Currency>()
		do {
			try fetchedResults = context.executeFetchRequest(fetchRequest) as! [Currency]
		} catch let fetchError as NSError {
			print("getCurrenciesNotHandsOn error: \(fetchError.localizedDescription)")
		}
		return fetchedResults
	}
	
	
	func getCurrenciesInConverter() -> [Currency]
	{
		let fetchRequest = NSFetchRequest(entityName: NSStringFromClass(Currency.classForCoder()))
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "code", ascending: true)]
		fetchRequest.predicate = NSPredicate(format: "in_converter = 1")
		
		var fetchedResults = Array<Currency>()
		do {
			try fetchedResults = context.executeFetchRequest(fetchRequest) as! [Currency]
		} catch let fetchError as NSError {
			print("getCurrenciesNotHandsOn error: \(fetchError.localizedDescription)")
		}
		return fetchedResults
	}

	
	func getHandsOnCurrenciesStructure(amount: Money) -> [HandsOnCurrency] {
		var handson: [HandsOnCurrency] = []
		var handsOnAmount: Money?
		for currency:Currency in getCurrenciesInConverter() {
			if amount.currency != currency {
				handsOnAmount = amount.toCurrency(currency)
			} else {
				handsOnAmount = amount
			}
			handson.append(HandsOnCurrency(amount: handsOnAmount!, textField: nil))
		}
		return handson
	}
	
	
	func deleteHandsOnCurrencyByCurrency(currency:Currency)
	{
		context.deleteObject(currency.valueForKey("handsOnCurrency") as! NSManagedObject)
		do {
			try context.save()
		} catch _ {
		}
	}

	
	func getCurrentCurrency() -> Currency {
		let defaults = NSUserDefaults.standardUserDefaults()
		let currentCurrencyCode:String? = defaults.stringForKey("currentCurrencyCode")
		return getCurrencyByCode(currentCurrencyCode ?? "AUD")!
	}
	
	func isEventHappen(name: String) -> Bool {
		let defaults = NSUserDefaults.standardUserDefaults()
		if let eventHappen = defaults.boolForKey("event_" + name) as Bool? {
			if eventHappen {
				return true
			}
		}
		return false
	}
	
	
	func setEventHappen(name:String) {
		let defaults = NSUserDefaults.standardUserDefaults()
		defaults.setBool(true, forKey: "event_" + name)
	}
	
	
	// MARK: - transactions
	func createTransaction(amount: Money, isExpense: Bool) -> (Transaction)
	{
		let newTransaction = NSEntityDescription.insertNewObjectForEntityForName(
			NSStringFromClass(Transaction.classForCoder()),
			inManagedObjectContext: context
		) as! Transaction
		
		newTransaction.setValue(amount.amount.decimalNumberByMultiplyingBy(isExpense ? -1 : 1), forKey: "amount")
		newTransaction.setValue(amount.currency, forKey: "currency")
		newTransaction.setValue(NSDate(), forKey: "date")
		
		print("createTransaction \(amount.amount)")
		
		return newTransaction
	}
	
	
	func getTransactionsList() -> [Transaction]
	{
		return getObjectsList(Transaction.classForCoder()) as! [Transaction]
	}

	
	func getTransactionsListForMonth(dateInMonth: NSDate) -> [Transaction]
	{
		let calendar = NSCalendar.currentCalendar()
		calendar.timeZone = NSTimeZone.systemTimeZone()
		var startDate: NSDate?
		var duration: NSTimeInterval = 0
		calendar.rangeOfUnit(NSCalendarUnit.Month, startDate: &startDate, interval: &duration, forDate: dateInMonth)
		let fetchRequest = NSFetchRequest(entityName: NSStringFromClass(Transaction.classForCoder()))
		guard startDate != nil else {
			return []
		}
		fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate!, (startDate?.dateByAddingTimeInterval(duration))!)
		
		//Execute Fetch request
		var fetchedResults = Array<AnyObject>()
		do {
			fetchedResults = try context.executeFetchRequest(fetchRequest)
		} catch let fetchError as NSError {
			print("getObjectsList error: \(fetchError.localizedDescription)")
		}
		
		return fetchedResults as! [Transaction]
	}
	
	
	func deleteTransaction(transaction:Transaction)
	{
		context.deleteObject(transaction)
		do {
			try context.save()
		} catch _ {
		}
	}

	
	// MARK: - category
	func createCategory(name: String, logo: NSData) -> (Category)
	{
		let newCategory = NSEntityDescription.insertNewObjectForEntityForName(
			NSStringFromClass(Category.classForCoder()),
			inManagedObjectContext: context
			) as! Category
		
		newCategory.setValue(name, forKey: "name")
		newCategory.setValue(logo, forKey: "logo")
		
		print("createCategory \(name)")
		return newCategory
	}
	
	
	func getCategoriesList() -> [Category]
	{
		return getObjectsList(Category.classForCoder()) as! [Category]
	}
}