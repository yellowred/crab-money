//
//  loopback.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 13/9/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation
import LoopBack

class Loopback {
	
	static let adapter:LBRESTAdapter = LBRESTAdapter(url: URL(string: "http://0.0.0.0:3015/api/"))
	static let customers:BackendRepositoryCustomer = adapter.repository(with: BackendRepositoryCustomer) as! BackendRepositoryCustomer
	static let financials:BackendRepositoryFinancial = adapter.repository(with: BackendRepositoryFinancial) as! BackendRepositoryFinancial
	
	func save() {
		let financialModel = Loopback.financials.model(with: nil) as? BackendModelFinancial
	}
}
