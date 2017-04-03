//
//  String+Extension.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 16/10/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import Foundation
import Alamofire

extension String {
	var localized: String {
		return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
	}
	
	func floatValue() -> Float? {
		guard let doubleValue = Double(self) else {
			return nil
		}
		
		return Float(doubleValue)
	}
}

extension String: ParameterEncoding {
	
	// new line delimiter
	static let kNewLine = "\n"
	
	public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
		var request = try urlRequest.asURLRequest()
		request.httpBody = data(using: .utf8, allowLossyConversion: false)
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		return request
	}
}
