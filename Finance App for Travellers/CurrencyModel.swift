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
		for (key, _) in entity.propertiesByName as! [String : AnyObject] {
			println("\"\(key)\": \(valueForKey(key))")
		}
	}
}


class CurrencyModel
{
	func getManagedContext() -> NSManagedObjectContext
	{
		let appDelegate     = UIApplication.sharedApplication().delegate as! AppDelegate
		return appDelegate.managedObjectContext!
	}
	
	
	func saveStorage()
	{
		var error: NSError? = nil
		if getManagedContext().hasChanges && !getManagedContext().save(&error)
		{
			// Replace this implementation with code to handle the error appropriately.
			// abort() causes the application to generate a crash log and terminate.
			// You should not use this function in a shipping application, although it may be useful during development.
			NSLog("Unresolved error \(error), \(error!.userInfo)")
			abort()
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
        return NSEntityDescription.entityForName("Currency", inManagedObjectContext: getManagedContext())!
    }
  
    
	func createCurrency(code: String, rate: Float, flag: NSData?, name: String?) -> Currency?
    {
        let newCurrency = Currency(entity: createEntity("Currency"),
            insertIntoManagedObjectContext:getManagedContext()) as Currency
        
        newCurrency.setValue(code, forKey: "code")
        newCurrency.setValue(rate, forKey: "rate")
        newCurrency.setValue(flag, forKey: "flag")
		newCurrency.setValue(name, forKey: "name")
        return newCurrency
    }
    
    
	func createCountry(code: String, name: String, flag: NSData?, currency: Currency) -> (Country)
    {
        let newCountry = NSEntityDescription.insertNewObjectForEntityForName( NSStringFromClass(Country.classForCoder()), inManagedObjectContext: getManagedContext()) as! Country
        
        //let newCountry = Country(entity: createEntity("Country"), insertIntoManagedObjectContext:getManagedContext()) as Country
        
        newCountry.setValue(code, forKey: "code")
        newCountry.setValue(name, forKey: "name")
        newCountry.setValue(currency, forKey: "currency")
        if flag != nil
        {
            newCountry.setValue(flag!, forKey: "flag")
        }

		println("Country", newCountry.valueForKey("code"), newCountry.valueForKey("flag"))
        
        return newCountry
    }
	
	
	func addCurrencyToHandsOnList(currency:Currency)
	{
		let entity:NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName("HandsOnCurrency", inManagedObjectContext: getManagedContext()) as! NSManagedObject
		entity.setValue(currency, forKey: "currency")
	}
	
	
    func clearStorage()
    {
        for currency: Currency in getCurrenciesList()
        {
            getManagedContext().deleteObject(currency)
        }
        for country: Country in getCountriesList()
        {
            getManagedContext().deleteObject(country)
        }
        
        getManagedContext().save(nil)
    }
	
	
	func clearCountries()
	{
		for country: Country in getCountriesList()
		{
			getManagedContext().deleteObject(country)
		}
		getManagedContext().save(nil)
	}
	
	
	func clearCurrencies()
	{
		for currency: Currency in getCurrenciesList()
		{
			getManagedContext().deleteObject(currency)
		}
		getManagedContext().save(nil)
	}
	
	
    func getCountriesList() -> [Country]
    {
        let fetchRequest = NSFetchRequest(entityName:NSStringFromClass(Country.classForCoder()))
        var error: NSError?
        let fetchedResults = getManagedContext().executeFetchRequest(fetchRequest, error: &error) as? [Country]
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
        let fetchedResults = getManagedContext().executeFetchRequest(fetchRequest, error: &error) as? [Currency]
        if (error != nil)
        {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        return fetchedResults!
    }
	
	func getCurrenciesNotHandsOn() -> [Currency]
	{
		let fetchRequest = NSFetchRequest(entityName:"Currency")
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "code", ascending: true)]
		fetchRequest.predicate = NSPredicate(format: "handsOnCurrency == nil || handsOnCurrency.@count =0")

		var error: NSError?
		let fetchedResults = getManagedContext().executeFetchRequest(fetchRequest, error: &error) as? [Currency]
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
		let fetchedResults = getManagedContext().executeFetchRequest(fetchRequest, error: &error) as? [Country]
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
	
 
	func getCurrencyByCode(code:String) -> Currency?
	{
		var fetchRequest = NSFetchRequest(entityName:"Currency")
		let pred = NSPredicate(format: "(code = %@)", code)
		fetchRequest.predicate = pred
		
		var error: NSError?
		let fetchedResults = getManagedContext().executeFetchRequest(fetchRequest, error: &error) as? [Currency]
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
		let appDelegate     = UIApplication.sharedApplication().delegate as! AppDelegate
        println("All loaded entities are: \(appDelegate.managedObjectModel.entitiesByName)");
    }
	
	func getHandsOnCurrenciesList() -> [Currency]
	{
		var handsOnCurrencies = [Currency]()
		
		let fetchRequest = NSFetchRequest(entityName:"HandsOnCurrency")
		var error: NSError?
		let fetchedResults = getManagedContext().executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
		if (error != nil)
		{
			println("Could not fetch \(error), \(error!.userInfo)")
		}
		else
		{
			if (fetchedResults != nil)
			{
				for handsOnCurrency:NSManagedObject in fetchedResults!
				{
					var currency: Currency? = handsOnCurrency.valueForKey("currency") as? Currency
					if (currency != nil)
					{
						handsOnCurrencies.append(currency!)
					}
				}
			}
		}
		return handsOnCurrencies
	}

	func deleteHandsOnCurrencyByCurrency(currency:Currency)
	{
		getManagedContext().deleteObject(currency.valueForKey("handsOnCurrency") as! NSManagedObject)
		getManagedContext().save(nil)
	}

	
	func preloadData () {
		clearCurrencies()

		var error:NSError?
		// Retrieve data from the source file
		if let contentsOfURL = NSBundle.mainBundle().URLForResource("currencies", withExtension: "json") {
				var parseError: NSError?
				let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: contentsOfURL)!,
					options: NSJSONReadingOptions.AllowFragments,
					error:&parseError)
				if let currencies = parsedObject as? [NSDictionary] {
					populateCurrenciesWithData(currencies)
				}
		}
	}
		
	func populateCurrenciesWithData(data: [NSDictionary]) {
		println(data);
		var flagPngData:NSData? = nil
		var currencyIndex = 0;
		for currencyData:NSDictionary in data
		{
			if currencyData.valueForKey("flag") != nil
			{
				
				flagPngData = NSData(base64EncodedString: currencyData.valueForKey("flag") as! String, options: nil)
			}
			else
			{
				flagPngData = nil
			}
			var currency = createCurrency(
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
				println("Skipped currency: ", currencyData.valueForKey("code"), currencyData.valueForKey("country"))
			}
			
		}
		println("Populated: \(currencyIndex)")
		saveStorage()
	}
}