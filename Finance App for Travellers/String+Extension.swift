//
//  String+Extension.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 16/10/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import Foundation
extension String {
	var localized: String {
		return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
	}
}
