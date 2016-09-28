//
//  loopback.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 13/9/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation
import Alamofire

class Backend {

	let API_URL:String = "http://0.0.0.0:3015/api/financials"
	
	func sendFinancials(transactions: [Transaction], callback: @escaping () -> Void) -> Void {
		let financials = transactions.map({transaction in
			return transaction.encode()
		})
		let data = try! JSONSerialization.data(withJSONObject: financials, options: [])
		let jsonBatch:String = String(data: data, encoding: .utf8)!
		/*
		Alamofire.request(
			"http://0.0.0.0:3015/api/financials",
			method: .post,
			parameters: parameters,
			encoding: JSONEncoding.default
		).responseJSON { response in
			debugPrint(response)
		}
		*/
		print("jsonBatch", jsonBatch)
		/*
		Alamofire.upload((jsonBatch?.data(using: String.Encoding.utf8.rawValue))!, to: "http://0.0.0.0:3015/api/financials").responseJSON { response in
			debugPrint(response)
		}
		*/
		Alamofire.request(API_URL, method: .post, parameters: [:], encoding: jsonBatch, headers: [:]).responseJSON { response in
			debugPrint(response)
			callback()
		}
		//Alamofire.request(API_URL, method: .post, parameters: [:], encoding: "myBody", headers: [:])
		
	}
}
