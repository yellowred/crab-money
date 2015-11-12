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

	
	func setTransaction(transaction: Transaction) {
		var attributedString:NSMutableAttributedString
		guard let string = NSNumberFormatter().formatterMoney(transaction.currency).stringFromNumber(transaction.amount) else {
			trnAmount.attributedText = NSMutableAttributedString(string: "")
			return
		}
		let amountString = NSString(string: string)
		let firstAttributes = [NSFontAttributeName:UIFont.systemFontOfSize(20)]
		let secondAttributes = [NSFontAttributeName:UIFont.systemFontOfSize(32)]
		
		attributedString = NSMutableAttributedString(string: amountString as String, attributes: firstAttributes)
			
		let dollarsValue = NSNumberFormatter().formatterDollars().stringFromNumber(transaction.amount.abs())
		let range = amountString.rangeOfString(dollarsValue!)
			
		attributedString.addAttributes(secondAttributes, range: range)
//			/attributedString.addAttributes(secondAttributes, range: amountString.rangeOfCharacterFromSet(NSCharacterSet(charactersInString: "-")))
		print(amountString, dollarsValue!)
		
		trnAmount.attributedText = attributedString
		if let category = transaction.category {
			trnLabel.text = category.name
		}
	}
}
