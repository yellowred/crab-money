//
//  CurrencyModel.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 07/07/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit
import CoreData

class CurrencyModel
{
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "kubrakov.Finance_App_for_Travellers" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
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
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("CurrencyStorage.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
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
    
    // MARK: - Core Data Saving support
    
    func saveStorage () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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
    
        
    // MARK: - Model Manipulations
   
    func createEntity(name: String) -> NSEntityDescription
    {
        return NSEntityDescription.entityForName("Currency", inManagedObjectContext: managedObjectContext!)!
    }
  
    
    func createCurrency(code: String, rate: Float?, country: Country?) -> Currency
    {
        let newCurrency = Currency(entity: createEntity("Currency"),
            insertIntoManagedObjectContext:managedObjectContext!) as Currency
        
        newCurrency.setValue(code, forKey: "code")
        newCurrency.setValue(rate, forKey: "rate")
        newCurrency.setValue(country, forKey: "country")
        
        return newCurrency
    }
    
    
    func createCountry(code: String, name: String, flag: NSData?) -> (Country)
    {
        let newCountry = NSEntityDescription.insertNewObjectForEntityForName( NSStringFromClass(Country.classForCoder()), inManagedObjectContext: managedObjectContext!) as! Country
        
        //let newCountry = Country(entity: createEntity("Country"), insertIntoManagedObjectContext:getManagedContext()) as Country
        
        newCountry.setValue(code, forKey: "code")
        newCountry.setValue(name, forKey: "name")
        
        println(flag)
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
            managedObjectContext!.deleteObject(currency)
        }
        for country: Country in getCountriesList()
        {
            managedObjectContext!.deleteObject(country)
        }
        
        managedObjectContext!.save(nil)
    }

    
    func getCountriesList() -> [Country]
    {
        let fetchRequest = NSFetchRequest(entityName:"Country")
        var error: NSError?
        let fetchedResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [Country]
        if (error != nil)
        {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        return fetchedResults!
    }
    
    
    func getCurrenciesList() -> [Currency]
    {
        let fetchRequest = NSFetchRequest(entityName:"Currency")
        var error: NSError?
        let fetchedResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [Currency]
        if (error != nil)
        {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        return fetchedResults!
    }
 
	func getCountryByCode(code:String) -> Country?
	{
		var fetchRequest = NSFetchRequest(entityName:"Country")
		let pred = NSPredicate(format: "(code = %@)", code)
		fetchRequest.predicate = pred
	
		var error: NSError?
		let fetchedResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [Country]
		if (error != nil)
		{
			println("Could not fetch \(error), \(error!.userInfo)")
		}
		if fetchedResults != nil && fetchedResults!.count > 0
		{
			return fetchedResults!.first
		}
		else
		{
			return nil
		}
	}
	
    func showAllEntities()
    {
        println("All loaded entities are: \(managedObjectModel.entitiesByName)");
    }
}