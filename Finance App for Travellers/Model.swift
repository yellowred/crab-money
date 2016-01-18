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
	
	let kNotificationDataChanged = "ModelDataChanged"
	private lazy var context: NSManagedObjectContext = {return self.managedObjectContext!}()
	private lazy var model: NSManagedObjectModel = {return self.managedObjectModel}()
	
	
	func saveStorage()
	{
		var error: NSError? = nil
		if context.hasChanges
		{
			do {
				try context.save()
				NSNotificationCenter.defaultCenter().postNotificationName(self.kNotificationDataChanged, object: nil)
				print("*** Notify that Model data changed")
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
	func preloadData() {
		if !isEventHappen("prepopulateData") {
			populateCurrenciesWithData(loadDataFromJson("currencies")!)
			populateCategoriesWithData(loadDataFromJson("categories")!)
			saveStorage()
			setEventHappen("prepopulateData")
		}
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
			let _ = createCurrency(
				currencyData.valueForKey("code") as! String,
				rate: (currencyData.valueForKey("rate") as! NSString).floatValue,
				flag: flagPngData
			)
		}
	}
	
	
	func populateCategoriesWithData(data: [NSDictionary]) {
		for category:NSDictionary in data
		{
			let _ = createCategory(category.valueForKey("name") as! String, logo: nil)
		}
	}
	
	
	func populateTransactionsWithData(data: [NSDictionary]) {
		for transactionData:NSDictionary in data
		{
			let newTransaction = createTransaction(
				Money(amount: NSDecimalNumber(float: transactionData.valueForKey("amount") as! Float), currency: getCurrencyByCode(transactionData.valueForKey("currency") as! String)!),
				isExpense: transactionData.valueForKey("isExpense") as! Bool)
			newTransaction.setValue(NSDate().fromString(transactionData.valueForKey("date") as! String), forKey: "date")
			newTransaction.setValue(NSDecimalNumber(integer: transactionData.valueForKey("rate") as! Int), forKey: "rate")
			newTransaction.category = getCategoriesList().first
		}
	}
	
	func updateAllUsingApi() {
		if !isEventHappen("prepopulateData") {
			populateCurrenciesWithData(loadDataFromJson("currencies")!)
			populateCategoriesWithData(loadDataFromJson("categories")!)
			saveStorage()
			setEventHappen("prepopulateData")
		}
	}

	
    // MARK: - Model Manipulations
   
    func createEntity(name: String) -> NSEntityDescription
    {
        return NSEntityDescription.entityForName(name, inManagedObjectContext: context)!
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
	

    func dumpAllEntities()
    {
        print("All loaded entities are: \(model.entitiesByName)");
    }

	
	// MARK: - Currency
	
	func createCurrency(code: String, rate: Float, flag: NSData?) -> Currency?
	{
		let newCurrency = Currency(entity: createEntity("Currency"),
			insertIntoManagedObjectContext:context) as Currency
		
		newCurrency.setValue(code, forKey: "code")
		newCurrency.setValue(rate, forKey: "rate")
		newCurrency.setValue(flag, forKey: "flag")
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

	
	func getCurrencyByCode(code:String) -> Currency?
	{
		let fetchRequest = NSFetchRequest(entityName:"Currency")
		let pred = NSPredicate(format: "(code = %@)", code)
		fetchRequest.predicate = pred

		do {
			let fetchedResults = try context.executeFetchRequest(fetchRequest)
			if fetchedResults.count > 0
			{
				return fetchedResults.first as! Currency
			}
		} catch let fetchError as NSError {
			print("getCountryByCode error: \(fetchError.localizedDescription)")
		}
		return nil
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
	
	
	func deleteCurrencyFromConverter(currency:Currency)
	{
		currency.setValue(0, forKey: "in_converter")
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

	
	func setCurrentCurrency(currency:Currency) {
		NSUserDefaults.standardUserDefaults().setValue(currency.code, forKey: "currentCurrencyCode")
	}
	

	// MARK: - User Defaults
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
	
	
	func setEventTime(name:String) {
		NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: name)
	}
	
	
	func getEventTime(name:String) -> NSDate? {
		return NSUserDefaults.standardUserDefaults().objectForKey(name) as? NSDate
	}
	
	
	// MARK: - transactions
	func createTransaction(amount: Money, isExpense: Bool) -> Transaction
	{
		let newTransaction = NSEntityDescription.insertNewObjectForEntityForName(
			NSStringFromClass(Transaction.classForCoder()),
			inManagedObjectContext: context
		) as! Transaction
		
		newTransaction.setValue(amount.amount.decimalNumberByMultiplyingBy(isExpense ? -1 : 1), forKey: "amount")
		newTransaction.setValue(amount.currency, forKey: "currency")
		newTransaction.setValue(amount.currency.rate, forKey: "rate")
		newTransaction.setValue(NSDate(), forKey: "date")
		
		print("createTransaction \(amount.amount)")
		
		return newTransaction
	}
	
	func createFakeTransaction() -> Transaction
	{
		let newTransaction = NSEntityDescription.insertNewObjectForEntityForName(
			NSStringFromClass(Transaction.classForCoder()),
			inManagedObjectContext: context
			) as! Transaction
		
		newTransaction.setValue(NSDecimalNumber(integer: -2500), forKey: "amount")
		newTransaction.setValue(getCurrentCurrency(), forKey: "currency")
		newTransaction.setValue(NSDate().fromString("2015-12-15 10:31:23"), forKey: "date")
		newTransaction.setValue(NSDecimalNumber(integer: 73), forKey: "rate")
		newTransaction.category = getCategoriesList().first
		return newTransaction
	}	
	
	func getTransactionsList() -> [Transaction]
	{
		return getObjectsList(Transaction.classForCoder()) as! [Transaction]
	}

	
	func getTransactionsListForPeriod(period: Period) -> [Transaction]
	{
		let fetchRequest = NSFetchRequest(entityName: NSStringFromClass(Transaction.classForCoder()))
		fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", period.startDate, period.endDate)
		
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

	
	func getIinitialTransaction() -> Transaction? {
		let fetchRequest = NSFetchRequest(entityName: NSStringFromClass(Transaction.classForCoder()))
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
		fetchRequest.fetchLimit = 1
		//Execute Fetch request
		var fetchedResults = Array<AnyObject>()
		do {
			fetchedResults = try context.executeFetchRequest(fetchRequest)
		} catch let fetchError as NSError {
			print("getObjectsList error: \(fetchError.localizedDescription)")
		}
		print(fetchedResults.first)
		return fetchedResults.first as? Transaction
	}
	
	
	// MARK: - period
	
	
	// MARK: - category
	func createCategory(name: String, logo: NSData?) -> (Category)
	{
		let newCategory = Category(entity: createEntity("Category"),
			insertIntoManagedObjectContext:context) as Category

		newCategory.setValue(name, forKey: "name")
		if let _ = logo {
			newCategory.setValue(logo, forKey: "logo")
		}
		print("createCategory \(name)")
		return newCategory
	}
	
	
	func getCategoriesList() -> [Category]
	{
		return getObjectsList(Category.classForCoder()) as! [Category]
	}
	
	
	func deleteCategory(category: Category)
	{
		context.deleteObject(category)
		do {
			try context.save()
		} catch _ {
		}
	}
	
	
	// MARK: - Core Data Delegate
	
	lazy var applicationDocumentsDirectory: NSURL = {
		// The directory the application uses to store the Core Data store file. This code uses a directory named "kubrakov.Finance_App_for_Travellers" in the application's documents Application Support directory.
		let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		print(urls);
		return urls[urls.count-1]
	}()
	
	lazy var managedObjectModel: NSManagedObjectModel = {
		// The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
		let modelURL = NSBundle.mainBundle().URLForResource("DataModel", withExtension: "momd")!
		return NSManagedObjectModel(contentsOfURL: modelURL)!
	}()
	
	lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
		// The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
		// Create the coordinator and store
		var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
		let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.getDbName())
		var error: NSError? = nil
		var failureReason = "There was an error creating or loading the application's saved data."
		do {
			try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
		} catch var error1 as NSError {
			error = error1
			coordinator = nil
			// Report any error we got.
			var dict = [String: AnyObject]()
			dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
			dict[NSLocalizedFailureReasonErrorKey] = failureReason
			dict[NSUnderlyingErrorKey] = error
			error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
			// Replace this with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			NSLog("Unresolved error \(error), \(error!.userInfo)")
			abort()
		} catch {
			fatalError()
		}
		
		return coordinator
	}()
	
	lazy var managedObjectContext: NSManagedObjectContext? = {
		// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
		let coordinator = self.persistentStoreCoordinator
		if coordinator == nil {
			return nil
		}
		var managedObjectContext = NSManagedObjectContext()
		managedObjectContext.persistentStoreCoordinator = coordinator
		return managedObjectContext
	}()
	
	
	func getDbName() -> String {
		return "CurrencyStorage.sqlite";
	}

}