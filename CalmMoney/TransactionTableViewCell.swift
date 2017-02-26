//
//  TransactionTableViewCell.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 18/08/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
	
	@IBOutlet weak var trnLabel: UILabel!
	@IBOutlet weak var trnAmount: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	
	func setTransaction(_ transaction: Transaction) {
		var attributedString:NSMutableAttributedString
		let numberFormatter: NumberFormatter
		numberFormatter = NumberFormatter().formatterMoney(transaction.currency)
		guard let string = numberFormatter.string(from: transaction.amount) else {
			trnAmount.attributedText = NSMutableAttributedString(string: "")
			return
		}
		let amountString = NSString(string: string)
		let firstAttributes = [NSFontAttributeName: UIFont.light(ofSize: 16)]
		let secondAttributes = [NSFontAttributeName: UIFont.light(ofSize: 28)]
		
		attributedString = NSMutableAttributedString(string: amountString as String, attributes: firstAttributes)
		
		let dollarsValue = NumberFormatter().formatterDollars().string(from: transaction.amount.abs())
		let range = amountString.range(of: dollarsValue!)
			
		attributedString.addAttributes(secondAttributes, range: range)
		
		trnAmount.attributedText = attributedString
		if let category = transaction.category {
			let categoryText = NSMutableAttributedString(string: category.name)
			if transaction.text.length > 0 {
				let noteForFinancialString = transaction.text
				let substringIndex = noteForFinancialString.index(noteForFinancialString.startIndex, offsetBy: noteForFinancialString.characters.count <= 32 ? noteForFinancialString.characters.count : 32)
				
				let noteForFinancial = NSMutableAttributedString(string: "\n" +	noteForFinancialString.substring(to: substringIndex), attributes: [
						NSFontAttributeName: UIFont.light(ofSize: 13),
						NSStrokeColorAttributeName: UIColor.lightGray
					])
				categoryText.append(noteForFinancial)
			}
			trnLabel.attributedText = categoryText
		} else {
			trnLabel.attributedText = NSMutableAttributedString(string: "undefined".localized)
		}
	}
}
