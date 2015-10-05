//
//  Networking.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 09/07/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

//@see http://www.raywenderlich.com/85080/beginning-alamofire-tutorial
class Networking
{
	private let api1:String = "http://api.fixer.io/latest?base=USD"
	private let api2:String = "https://openexchangerates.org/api/api/latest.json?app_id=fc667c4ed0af4675835f20c90b8a4276"
	private let currencyDownloadEndpoint:String = "http://sandbox.kubrakov.devel.local/currency.php"

	private var model: Model
	
	init(model: Model) {
		self.model = model
	}

	
	
	func downloadCountriesDatabase(finishCallback: () -> Void)
	{
		model.clearStorage()
		request(.GET, currencyDownloadEndpoint).responseJSON() {
			(_, _, data) in

			print(data);
			var flagPngData:NSData? = nil
			for countryData:NSDictionary in data as! [NSDictionary]
			{
				if countryData.valueForKey("flag") != nil
				{
					flagPngData = NSData(base64EncodedString: countryData.valueForKey("flag") as! String, options: NSDataBase64DecodingOptions(rawValue: 0))
				}
				else
				{
					flagPngData = nil
				}
				
				var country = self.model.createCountry(
					countryData.valueForKey("code") as! String,
					name: countryData.valueForKey("name_eng") as! String,
					flag: flagPngData,
					currency: self.model.getCurrencyByCode(countryData.valueForKey("currency") as! String)!
				)
			}
			self.model.saveStorage()
			finishCallback()
		}
		
	}
	
	func downloadCurrenciesDatabase(finishCallback: () -> Void)
	{
		model.clearCurrencies()
		
		request(.GET, currencyDownloadEndpoint).responseJSON() {
			(_, response, data) in
			
			
			
			print(data);
			var flagPngData:NSData? = nil
			var currencyIndex = 0;
			for currencyData:NSDictionary in data as! [NSDictionary]
			{
				if currencyData.valueForKey("flag") != nil
				{
					
					flagPngData = NSData(base64EncodedString: currencyData.valueForKey("flag") as! String, options: NSDataBase64DecodingOptions(rawValue: 0))
				}
				else
				{
					flagPngData = nil
				}
				var currency = self.model.createCurrency(
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
			print("Saved: \(currencyIndex)")
			self.model.saveStorage()
			finishCallback()
		}
	}
	
}