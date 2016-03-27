//
//  CrabApi.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 09/01/16.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation
import Alamofire

class CrabApi {
	private let apiUrl:String = "http://ec2-52-91-250-91.compute-1.amazonaws.com:3000/"
	private lazy var currencyDownloadEndpoint: String = {
		return self.apiUrl + "currency"
	}()

	func currencies(finishCallback: (data: AnyObject?) -> Void) {
		print("Request ", currencyDownloadEndpoint)
		Alamofire.request(.GET, currencyDownloadEndpoint).responseJSON() {
			response in
			
			if let JSON = response.result.value {
				finishCallback(data: JSON)
			} else {
				debugPrint("Incorrect response in ", #function)
			}
		}
	}
}