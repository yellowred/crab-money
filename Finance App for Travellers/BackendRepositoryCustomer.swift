//
//  BackendModelCustomer.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 13/9/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation
import LoopBack

class BackendRepositoryCustomer : LBPersistedModelRepository {
	override init() {
		super.init(className: "customers")
	}
	class func repository() -> BackendRepositoryCustomer {
		return BackendRepositoryCustomer()
	}
	
}