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
		guard let string = NumberFormatter().formatterMoney(transaction.currency).string(from: transaction.amount) else {
			trnAmount.attributedText = NSMutableAttributedString(string: "")
			return
		}
		let amountString = NSString(string: string)
		let firstAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 20)]
		let secondAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 32)]
		
		attributedString = NSMutableAttributedString(string: amountString as String, attributes: firstAttributes)
			
		let dollarsValue = NumberFormatter().formatterDollars().string(from: transaction.amount.abs())
		let range = amountString.range(of: dollarsValue!)
			
		attributedString.addAttributes(secondAttributes, range: range)
		
		trnAmount.attributedText = attributedString
		if let category = transaction.category {
			trnLabel.text = category.name
		}
	}
}
