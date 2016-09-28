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
}

extension String: ParameterEncoding {
	public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
		var request = try urlRequest.asURLRequest()
		request.httpBody = data(using: .utf8, allowLossyConversion: false)
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		return request
	}
}
