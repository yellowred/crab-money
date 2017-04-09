//
//  CurrencyModel.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 07/07/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit
import CoreData

//for carrier info
import CoreTelephony

extension NSManagedObject
{
	func dumpProperties() {
		for (key, _) in entity.propertiesByName {
			print("\"\(key)\": \(String(describing: value(forKey: key)))")
		}
	}
}


class Model
{
	
	let kNotificationDataChanged = "ModelDataChanged"
	fileprivate lazy var context: NSManagedObjectContext = {return self.managedObjectContext!}()
	fileprivate lazy var model: NSManagedObjectModel = {return self.managedObjectModel}()
	
	
	func saveStorage()
	{
		var error: NSError? = nil
		if context.hasChanges
		{
			do {
				try context.save()
				NotificationCenter.default.post(name: Notification.Name(rawValue: self.kNotificationDataChanged), object: nil)
				print("*** Notify that Model data changed")
			} catch let error1 as NSError {
				error = error1
				// Replace this implementation with code to handle the error appropriately.
				// abort() causes the application to generate a crash log and terminate.
				// You should not use this function in a shipping application, although it may be useful during development.
				NSLog("Unresolved error \(String(describing: error)), \(error!.userInfo)")
				abort()
			}
		}
	}
	
	
    // MARK: - Populating
	func preloadData() {
		if !isEventHappen("prepopulateData") {
			populateCurrenciesWithData(loadDataFromJson("currencies")!)
			populateCategoriesWithData(loadDataFromJson("categories")!)
			
			let currency = getDefaultCurrency()
			currency.addToConverter()
			currency.popularity = currency.popularity + 2
			setCurrentCurrency(currency)
			
			saveStorage()
			setEventHappen("prepopulateData")
		}
	}
	
	
	func loadDataFromJson(_ name: String) -> [NSDictionary]? {
		if let contentsOfURL = Bundle(for: type(of: self)).url(forResource: name, withExtension: "json") {
			let parsedObject: Any?
			do {
				parsedObject = try JSONSerialization.jsonObject(with: Data(contentsOf: contentsOfURL),
					options: JSONSerialization.ReadingOptions.allowFragments)
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

	
	func populateCurrenciesWithData(_ data: [NSDictionary]) {
		var flagPngData:NSData? = nil
		for currencyData:NSDictionary in data
		{
			if currencyData.value(forKey: "flag") != nil
			{
				flagPngData = NSData(base64Encoded: currencyData.value(forKey: "flag") as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
			}
			else
			{
				flagPngData = nil
			}
			
			let stringRate = String(describing: currencyData.value(forKey: "rate")!)
			let rate = NSDecimalNumber(string: stringRate, locale: Locale(identifier: "en_US"))
			let currency = createCurrency(
				currencyData.value(forKey: "code") as! String,
				rate: Float(rate),
				flag: flagPngData
			)
			if currency != nil {
				currency!.popularity = Float(currencyData.value(forKey: "is_popular") as! String)!
				if (currency!.code == "USD" || currency!.code == "EUR") {
					currency!.popularity = currency!.popularity + 1
				}
			}
		}
	}
	
	
	func populateCategoriesWithData(_ data: [NSDictionary]) {
		var categoryObject: Category?
		for category:NSDictionary in data
		{
			let type = category.value(forKey: "type") as! String
			categoryObject = createCategory(category.value(forKey: "name") as! String, isExpense: type == "expense", logo: nil)
			if let colorIndex: Int = category.value(forKey: "color") as? Int {
				categoryObject?.logo = String(describing: Category.friendlyColors[colorIndex]).data(using: .utf8) as NSData?
				self.saveStorage()
			}
		}
	}
	
	
	func populateTransactionsWithData(_ data: [NSDictionary]) {
		for transactionData:NSDictionary in data
		{
			let newTransaction = createTransaction(
				Money(amount: NSDecimalNumber(value: transactionData.value(forKey: "amount") as! Float as Float), currency: getCurrencyByCode(transactionData.value(forKey: "currency") as! String)!),
				isExpense: transactionData.value(forKey: "isExpense") as! Bool)
			newTransaction.setValue(
				Date().fromString(transactionData.value(forKey: "date") as! String) as AnyObject?,
				forKey: "date"
			)
			newTransaction.setValue(NSDecimalNumber(value: transactionData.value(forKey: "rate") as! Int as Int), forKey: "rate")
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
	
	
	func saveRatesFrom(array: Array<NSDictionary>)
	{
		for currencyRateData:NSDictionary in array {
			if
				let currency = self.getCurrencyByCode(currencyRateData.value(forKey: "code") as! String)
			{
				let stringRate = String(describing: currencyRateData.value(forKey: "rate")!)
				let rate = NSDecimalNumber(string: stringRate, locale: Locale(identifier: "en_US"))
				currency.setValue(rate, forKey: "rate")
			}
		}
		print("*** Model: \(array.count) rates saved")
		self.saveStorage()
	}

	
    // MARK: - Model Manipulations
    func createEntity(_ name: String) -> NSEntityDescription
    {
        return NSEntityDescription.entity(forEntityName: name, in: context)!
    }
	
    
	func createCountry(_ code: String, name: String, flag: Data?, currency: Currency) -> (Country)
    {
        let newCountry = NSEntityDescription.insertNewObject( forEntityName: NSStringFromClass(Country.classForCoder()), into: context) as! Country
        
        //let newCountry = Country(entity: createEntity("Country"), insertIntoManagedObjectContext:context) as Country
        
        newCountry.setValue(code, forKey: "code")
        newCountry.setValue(name, forKey: "name")
        newCountry.setValue(currency, forKey: "currency")
        if flag != nil
        {
            newCountry.setValue(flag!, forKey: "flag")
        }
        return newCountry
    }

	
    func clearStorage()
    {
        for currency: Currency in getCurrenciesList()
        {
            context.delete(currency)
        }
        for country: Country in getCountriesList()
        {
            context.delete(country)
        }
        saveStorage()
    }
	
	
	func clearCountries()
	{
		for country: Country in getCountriesList()
		{
			context.delete(country)
		}
		saveStorage()
	}
	
	
	func getObjectsList(_ objectClass: AnyClass) -> [AnyObject] {
		// Create request on Event entity
		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: NSStringFromClass(objectClass))

		//Execute Fetch request
		var fetchedResults = Array<AnyObject>()
		do {
			fetchedResults = try context.fetch(fetchRequest)
		} catch let fetchError as NSError {
			print("getObjectsList error: \(fetchError.localizedDescription)")
		}
		
		return fetchedResults
	}
	
	
    func getCountriesList() -> [Country]
    {
		return getObjectsList(Country.classForCoder()) as! [Country]
    }
	
 
	func getCountryByCode(_ code:String) -> Country?
	{
		let fetchRequest: NSFetchRequest<Country> = NSFetchRequest(entityName:"Country")
		let pred = NSPredicate(format: "(code = %@)", code)
		fetchRequest.predicate = pred
	
		var fetchedResults = Array<Country>()
		do {
			try fetchedResults = context.fetch(fetchRequest) 
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
	
	func createCurrency(_ code: String, rate: Float, flag: NSData?) -> Currency?
	{
		let newCurrency = Currency(entity: createEntity("Currency"),
			insertInto:context) as Currency
		
		newCurrency.setValue(code, forKey: "code")
		newCurrency.setValue(rate, forKey: "rate")
		newCurrency.setValue(flag, forKey: "flag")
		return newCurrency
	}
	
	
	func getCurrenciesList() -> [Currency]
	{
		let fetchRequest: NSFetchRequest<Currency> = NSFetchRequest(entityName: NSStringFromClass(Currency.classForCoder()))
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: false), NSSortDescriptor(key: "code", ascending: true)]
		fetchRequest.predicate = NSPredicate(format: "popularity >= 0")
		
		//Execute Fetch request
		var fetchedResults = Array<Currency>()
		do {
			try fetchedResults = context.fetch(fetchRequest)
		} catch let fetchError as NSError {
			print("getCurrenciesNotHandsOn error: \(fetchError.localizedDescription)")
		}
		
		return fetchedResults
	}
	
	
	func getCurrenciesNotInConverter() -> [Currency]
	{
		/*
		let fetchRequest = NSFetchRequest(entityName:"Currency")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "code", ascending: true)]
		fetchRequest.predicate = NSPredicate(format: "handsOnCurrency == nil || handsOnCurrency.@count =0")
		*/
		
		let fetchRequest: NSFetchRequest<Currency> = NSFetchRequest(entityName: NSStringFromClass(Currency.classForCoder()))
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "popularity", ascending: false), NSSortDescriptor(key: "code", ascending: true)]
		fetchRequest.predicate = NSPredicate(format: "in_converter <> 1 && popularity >= 0")
		
		var fetchedResults = Array<Currency>()
		do {
			try fetchedResults = context.fetch(fetchRequest) 
		} catch let fetchError as NSError {
			print("getCurrenciesNotHandsOn error: \(fetchError.localizedDescription)")
		}
		return fetchedResults
	}

	
	func getCurrencyByCode(_ code:String) -> Currency?
	{
		let fetchRequest: NSFetchRequest<Currency> = NSFetchRequest(entityName:"Currency")
		let pred = NSPredicate(format: "(code = %@)", code)
		fetchRequest.predicate = pred

		do {
			let fetchedResults = try context.fetch(fetchRequest)
			if fetchedResults.count > 0
			{
				return fetchedResults.first as Currency!
			}
		} catch let fetchError as NSError {
			print("getCountryByCode error: \(fetchError.localizedDescription)")
		}
		return nil
	}
	
	
	func getCurrenciesInConverter() -> [Currency]
	{
		let fetchRequest: NSFetchRequest<Currency>  = NSFetchRequest(entityName: NSStringFromClass(Currency.classForCoder()))
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "code", ascending: true)]
		fetchRequest.predicate = NSPredicate(format: "in_converter = 1 && popularity >= 0")
		
		var fetchedResults = Array<Currency>()
		do {
			try fetchedResults = context.fetch(fetchRequest) 
		} catch let fetchError as NSError {
			print("getCurrenciesNotHandsOn error: \(fetchError.localizedDescription)")
		}
		return fetchedResults
	}

	
	func getHandsOnCurrenciesStructure(_ amount: Money) -> [HandsOnCurrency] {
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

	func getHandsOnCurrenciesStructureFake(_ amount: Money) -> [HandsOnCurrency] {
		var handson: [HandsOnCurrency] = []
		var handsOnAmount: Money?
		let currencies = ["USD", "RUB", "EUR", "JPY"].map {code in getCurrencyByCode(code)!}
		for currency:Currency in currencies {
			if amount.currency != currency {
				handsOnAmount = amount.toCurrency(currency)
			} else {
				handsOnAmount = amount
			}
			handson.append(HandsOnCurrency(amount: handsOnAmount!, textField: nil))
		}
		return handson
	}

	
	func deleteCurrencyFromConverter(_ currency:Currency)
	{
		currency.setValue(0, forKey: "in_converter")
		saveStorage()
	}

	
	//get HOME currency
	func getCurrentCurrency() -> Currency {
		let defcur = UserDefaults.standard.string(forKey: "currentCurrencyCode")
		guard defcur != nil else {
			return getCurrencyByCode("USD")!
		}
		return getCurrencyByCode(defcur!)!
	}

	
	func setCurrentCurrency(_ currency:Currency) {
		UserDefaults.standard.setValue(currency.code, forKey: "currentCurrencyCode")
	}

	func getNumpadCurrency() -> Currency {
		let numcur = UserDefaults.standard.string(forKey: "numpadCurrencyCode")
		guard numcur != nil else {
			return getCurrentCurrency()
		}
		return getCurrencyByCode(numcur!)!
	}
	
	
	func setNumpadCurrency(_ currency:Currency) {
		UserDefaults.standard.setValue(currency.code, forKey: "numpadCurrencyCode")
	}
	
	func getDefaultCurrency() -> Currency {
		if let currency = getCurrencyByCode(getCurrencyByCurrentLocale()) {
			return currency
		} else {
			return getCurrencyByCode("USD")!
		}
	}
	
	
	func getCurrencyByCurrentLocale() -> String {
		let currentLocale = Locale.current
		return (currentLocale as NSLocale).object(forKey: NSLocale.Key.currencyCode) as! String
	}
	
	
	func getCurrentCountryByCarrier() -> String? {
		// Setup the Network Info and create a CTCarrier object
		let networkInfo = CTTelephonyNetworkInfo()
		let carrier = networkInfo.subscriberCellularProvider
		return carrier?.isoCountryCode
	}
	
	
	// MARK: - Budget
	func getBudget() -> Money {
		if let amount = UserDefaults.standard.object(forKey: "budget_amount") as? NSNumber {
			return Money(amount: NSDecimalNumber(decimal: amount.decimalValue), currency: getCurrencyByCode(UserDefaults.standard.string(forKey: "budget_currency")!)!)
		} else {
			return Money(amount: 0, currency: getCurrentCurrency())
		}
	}
	
	
	func setBudget(_ budget:Money) {
		UserDefaults.standard.set(budget.amount, forKey: "budget_amount")
		UserDefaults.standard.set(budget.currency.code, forKey: "budget_currency")
	}
	
	
	// MARK: - User Defaults
	func isEventHappen(_ name: String) -> Bool {
		let defaults = UserDefaults.standard
		if let eventHappen = defaults.bool(forKey: "event_" + name) as Bool? {
			if eventHappen {
				return true
			}
		}
		return false
	}
	
	
	func setEventHappen(_ name:String) {
		let defaults = UserDefaults.standard
		defaults.set(true, forKey: "event_" + name)
	}
	
	
	func setEventTime(_ name:String) {
		UserDefaults.standard.set(Date(), forKey: name)
	}
	
	
	func getEventTime(_ name:String) -> Date? {
		return UserDefaults.standard.object(forKey: name) as? Date
	}
	
	
	// MARK: - transactions
	func createTransaction(_ amount: Money, isExpense: Bool) -> Transaction
	{
		let newTransaction = NSEntityDescription.insertNewObject(
			forEntityName: NSStringFromClass(Transaction.classForCoder()),
			into: context
		) as! Transaction
		
		newTransaction.setValue(amount.amount.multiplying(by: isExpense ? -1 : 1), forKey: "amount")
		newTransaction.setValue(amount.currency, forKey: "currency")
		newTransaction.setValue(amount.currency.rate, forKey: "rate")
		newTransaction.setValue(Date(), forKey: "date")

		return newTransaction
	}
	
	func createFakeTransaction() -> Transaction
	{
		let newTransaction = NSEntityDescription.insertNewObject(
			forEntityName: NSStringFromClass(Transaction.classForCoder()),
			into: context
			) as! Transaction
		
		newTransaction.setValue(NSDecimalNumber(value: -2500 as Int), forKey: "amount")
		newTransaction.setValue(getCurrentCurrency(), forKey: "currency")
		newTransaction.setValue(Date().fromString("2015-12-15 10:31:23"), forKey: "date")
		newTransaction.setValue(NSDecimalNumber(value: 73 as Int), forKey: "rate")
		newTransaction.category = getCategoriesList().first
		return newTransaction
	}	
	
	func getTransactionsList() -> [Transaction]
	{
		let res = getObjectsList(Transaction.classForCoder()) as! [Transaction]
		healTransactions(res)
		return res
	}

	
	func getTransactionsListForPeriod(_ period: PeriodMonth) -> [Transaction]
	{
		let fetchRequest: NSFetchRequest<Transaction> = NSFetchRequest(entityName: NSStringFromClass(Transaction.classForCoder()))
		fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", period.startDate as CVarArg, period.endDate as CVarArg)
		
		//Execute Fetch request
		var fetchedResults = Array<AnyObject>()
		do {
			fetchedResults = try context.fetch(fetchRequest)
		} catch let fetchError as NSError {
			print("getObjectsList error: \(fetchError.localizedDescription)")
		}
		
		let res = fetchedResults as! [Transaction]
		healTransactions(res)
		return res
	}
	
	
	func healTransactions(_ transactions: [Transaction]) {
		for elem:Transaction in transactions {
			if elem.amount.isEqual(to: NSDecimalNumber.notANumber) {
				elem.amount = NSDecimalNumber(value: 0)
			}
		}
	}
	
	func deleteTransaction(_ transaction:Transaction)
	{
		context.delete(transaction)
		saveStorage()
	}

	
	func getIinitialTransaction() -> Transaction? {
		let fetchRequest: NSFetchRequest<Transaction> = NSFetchRequest(entityName: NSStringFromClass(Transaction.classForCoder()))
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
		fetchRequest.fetchLimit = 1
		//Execute Fetch request
		var fetchedResults = Array<AnyObject>()
		do {
			fetchedResults = try context.fetch(fetchRequest)
		} catch let fetchError as NSError {
			print("getObjectsList error: \(fetchError.localizedDescription)")
		}
		return fetchedResults.first as? Transaction
	}
	
	
	// MARK: - period
	
	
	// MARK: - category
	func createCategory(_ name: String, isExpense: Bool, logo: Data?) -> (Category)
	{
		let newCategory = Category(entity: createEntity("Category"),
			insertInto:context) as Category

		newCategory.setValue(name.capitalized, forKey: "name")
		newCategory.setValue(isExpense, forKey: "is_expense")
		if let _ = logo {
			newCategory.setValue(logo, forKey: "logo")
		}
		return newCategory
	}
	
	
	func getCategoriesList() -> [Category]
	{
		return getObjectsList(Category.classForCoder()) as! [Category]
	}
	
	func getCategoriesList(_ isExpense: Bool) -> [Category] {
		let fetchRequest: NSFetchRequest<Category> = NSFetchRequest(entityName: "Category")
		fetchRequest.predicate = NSPredicate(format: "(is_expense = %@)", isExpense as CVarArg)
		
		var fetchedResults = Array<Category>()
		do {
			try fetchedResults = context.fetch(fetchRequest)
		} catch let fetchError as NSError {
			print("getExpenseCategories error: \(fetchError.localizedDescription)")
		}
		return fetchedResults
	}
	
	
	func deleteCategory(_ category: Category)
	{
		context.delete(category)
		saveStorage()
	}
	
	
	// MARK: - Core Data Delegate
	lazy var applicationDocumentsDirectory: URL = {
		// The directory the application uses to store the Core Data store file. This code uses a directory named "kubrakov.Finance_App_for_Travellers" in the application's documents Application Support directory.
		let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		print(urls);
		return urls[urls.count-1]
	}()
	
	lazy var managedObjectModel: NSManagedObjectModel = {
		// The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
		let modelURL = Bundle.main.url(forResource: "DataModel", withExtension: "momd")!
		return NSManagedObjectModel(contentsOf: modelURL)!
	}()
	
	lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
		// The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
		// Create the coordinator and store
		var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
		let url = self.applicationDocumentsDirectory.appendingPathComponent(self.getDbName())
		var error: NSError? = nil
		var failureReason = "There was an error creating or loading the application's saved data."
		do {
			try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
		} catch var error1 as NSError {
			error = error1
			coordinator = nil
			// Report any error we got.
			var dict = [String: AnyObject]()
			dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
			dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
			dict[NSUnderlyingErrorKey] = error
			error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
			// Replace this with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
			NSLog("Unresolved error \(String(describing: error)), \(error!.userInfo)")
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
		var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		managedObjectContext.persistentStoreCoordinator = coordinator
		return managedObjectContext
	}()

	
	func getDbName() -> String {
		return "CurrencyStorage.sqlite";
	}

}
