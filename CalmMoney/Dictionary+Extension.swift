//
//  Dictionary+Extension.swift
//  CalmMoney
//
//  Created by Oleg Kubrakov on 5/12/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import Foundation

extension Dictionary where Value: Equatable {
	/// Returns all keys mapped to the specified value.
	/// ```
	/// let dict = ["A": 1, "B": 2, "C": 3]
	/// let keys = dict.keysForValue(2)
	/// assert(keys == ["B"])
	/// assert(dict["B"] == 2)
	/// ```
	func keysForValue(value: Value) -> [Key] {
		return flatMap { (key: Key, val: Value) -> Key? in
			value == val ? key : nil
		}
	}
}
