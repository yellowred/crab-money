//
//  Networking.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 09/07/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit
import Alamofire

//@see http://www.raywenderlich.com/85080/beginning-alamofire-tutorial
class Networking
{
	private let api1:String = "http://api.fixer.io/latest?base=USD"
	private let api2:String = "https://openexchangerates.org/api/api/latest.json?app_id=fc667c4ed0af4675835f20c90b8a4276"
	private let api3:String = "http://tutu.kubrakov.devel.local/test.php"
	

    func downloadAllData()
    {
		Alamofire.request(.GET, api1).responseJSON() {
			(_, _, data, _) in
			let currenciesData = (data!.valueForKey("rates") as! [NSDictionary])
		}
    }
	
	
	func downloadCountriesDatabase(finishCallback: () -> Void)
	{
		let model = CurrencyModel();
		model.clearStorage()
		Alamofire.request(.GET, api3).responseJSON() {
			(_, _, data, error) in

			if error != nil
			{
				println(error)
			}
			
			
			println(data);
			var flagPngData:NSData? = nil
			for countryData:NSDictionary in data as! [NSDictionary]
			{
				if countryData.valueForKey("flag") != nil
				{
					
					flagPngData = NSData(base64EncodedString: countryData.valueForKey("flag") as! String, options: nil)
				}
				else
				{
					flagPngData = nil
				}
				
				var country = model.createCountry(
					countryData.valueForKey("code") as! String,
					name: countryData.valueForKey("name_eng") as! String,
					flag: flagPngData
				)
			}
			model.saveStorage()
			finishCallback()
		}
		
	}
	
	func downloadCurrenciesDatabase(finishCallback: () -> Void)
	{
		let model = CurrencyModel();

		for currency: Currency in model.getCurrenciesList()
		{
			currency.delete(self)
		}
		model.saveStorage()
		
		
		Alamofire.request(.GET, api3).responseJSON() {
			(_, _, data, error) in
			
			if error != nil
			{
				println(error)
			}
			
			
			println(data);
			for currencyData:NSDictionary in data as! [NSDictionary]
			{
				var currency = model.createCurrency(
					currencyData.valueForKey("code") as! String,
					rate: currencyData.valueForKey("rate") as? Float,
					country: model.getCountryByCode(currencyData.valueForKey("country") as! String)
				)
			}
			model.saveStorage()
			finishCallback()
		}
		
	}
	
}