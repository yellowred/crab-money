//
//  Exporter.swift
//  CalmMoney
//
//  Created by Oleg Kubrakov on 12/2/2017.
//  Copyright © 2017 Oleg Kubrakov. All rights reserved.
//

import Foundation


class Exporter: NSObject {
	
	let kTxFile = "tx_export.csv"
	
	public static var sharedInstance = Exporter()
	
	//MARK: - Initialize
	public override init() {
		super.init()
	}

	
	//MARK: - Export
	func export(transactions: [Transaction]) -> URL? {
		let csvString = NSMutableString()
		csvString.append("Date, Category, Amount, Currency, Rate/USD, Description\n")
		for tx in transactions {
			let params:[String] = [tx.date.toString(), tx.category?.name ?? "undefined".localized, tx.amount.stringValue, tx.currency.code, tx.rate.stringValue, tx.text]
			csvString.append(params.joined(separator: ", ") + String.kNewLine)
		}
		
		if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let path = dir.appendingPathComponent(kTxFile)
			do {
				try csvString.write(to: path, atomically: false, encoding: String.Encoding.utf8.rawValue)
				return path
			}
			catch {
				print("Failed writing to URL: \(path), Error: " + error.localizedDescription)
			}
		}
		return nil
	}
}
