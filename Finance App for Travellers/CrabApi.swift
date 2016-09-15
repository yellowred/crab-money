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
	fileprivate let apiUrl:String = "http://ec2-52-91-250-91.compute-1.amazonaws.com:3000/"
	fileprivate lazy var currencyDownloadEndpoint: String = {
		return self.apiUrl + "currency"
	}()

	func currencies(_ finishCallback: @escaping (_ data: AnyObject?) -> Void) {
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
