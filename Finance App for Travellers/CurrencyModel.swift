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
    func createFakeData()
    {
        let persistenStoreCoordinator: NSPersistentStoreCoordinator = getManagedContext().persistentStoreCoordinator!
        let managedObjectModel: NSManagedObjectModel = persistenStoreCoordinator.managedObjectModel
        
        println("All loaded entities are: \(managedObjectModel.entitiesByName)");
        
        clearStorage()
        
        let russia: Country = createCountry("RU", name: "Россия");
        let usa: Country = createCountry("US", name: "США");
        let australia: Country = createCountry("AU", name: "Австралия");
        
        createCurrency("RUB", value: 25, country: russia)
        createCurrency("USD", value: 100, country: usa)
        createCurrency("AUD", value: 85, country: australia)

        saveStorage()
        
        //
        //        currencies = [
        //            Currency(code: "RUB", country: "RU", rate: 25, flag: UIImage(named: "flag_ru"))!,
        //            Currency(code: "USD", country: "RU", rate: 100, flag: UIImage(named: "flag_us"))!,
        //            Currency(code: "AUD", country: "RU", rate: 85, flag: UIImage(named: "flag_au"))!
        //        ]
    }
    
    
    func createEntity(name: String) -> NSEntityDescription
    {
        let appDelegate     = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext  = appDelegate.managedObjectContext!
        
        return NSEntityDescription.entityForName("Currency", inManagedObjectContext: managedContext)!
    }
    
    func getManagedContext() -> NSManagedObjectContext
    {
        let appDelegate     = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext!
    }
    
    func saveStorage()
    {
        var error: NSError?
        if !getManagedContext().save(&error)
        {
            println("Could not save \(error), \(error?.userInfo)")
        }

    }
    
    func createCurrency(code: String, value: Float, country: Country) -> Currency
    {
        let newCurrency = Currency(entity: createEntity("Currency"),
            insertIntoManagedObjectContext:getManagedContext())
        
        newCurrency.setValue(code, forKey: "code")
        newCurrency.setValue(value, forKey: "value")
        newCurrency.setValue(country, forKey: "country")
        
        return newCurrency
    }
    
    
    func createCountry(code: String, name: String) -> (Country)
    {
        let newCountry = Country(entity: createEntity("Country"), insertIntoManagedObjectContext:getManagedContext())
        
        newCountry.setValue(code, forKey: "code")
        newCountry.setValue(name, forKey: "name")
        
        return newCountry
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

    
    func getCountriesList() -> [Country]
    {
        let fetchRequest = NSFetchRequest(entityName:"Country")
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
    
}