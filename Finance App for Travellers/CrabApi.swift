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
	private let apiUrl:String = "https://ec2-52-91-250-91.compute-1.amazonaws.com/crabapi/"
	private lazy var currencyDownloadEndpoint: String = {
		return self.apiUrl + "currencies.php"
	}()

	func currencies(finishCallback: (data: AnyObject?) -> Void) {
		Alamofire.request(.GET, currencyDownloadEndpoint).responseJSON() {
			response in
			
			debugPrint(response.data)
			finishCallback(data: response.data!)
		}
	}
}