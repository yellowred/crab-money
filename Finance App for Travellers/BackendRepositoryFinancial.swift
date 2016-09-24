//
//  BackendModelFinancial.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 13/9/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation
import LoopBack

class BackendRepositoryFinancial : LBPersistedModelRepository {
	override init() {
		super.init(className: "financials")
	}
	class func repository() -> BackendRepositoryFinancial {
		return BackendRepositoryFinancial()
	}
	
}
