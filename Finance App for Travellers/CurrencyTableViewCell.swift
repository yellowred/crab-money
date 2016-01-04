//
//  CurrencyTableViewCell.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 22/06/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell, UITableViewDelegate {

    @IBOutlet weak var valueInput: UITextField!
	@IBOutlet weak var flag: UIImageView!
	@IBOutlet weak var code: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(text text: String?, placeholder: String) {
        valueInput.text = text
        valueInput.placeholder = placeholder
        
        valueInput.accessibilityValue = text
        valueInput.accessibilityLabel = placeholder
    }

	
	func setHandsOnCurrency(handsOnCurrency: HandsOnCurrency) {
		self.code.text = handsOnCurrency.amount.currency.code.uppercaseString
		self.flag.image = handsOnCurrency.amount.currency.getFlag()
		self.flag.layer.cornerRadius = 15
		self.flag.layer.masksToBounds = true
		self.code.layer.cornerRadius = 5
		self.code.layer.masksToBounds = true
		self.valueInput.text = handsOnCurrency.amount.amount.stringValue
		(self.valueInput as! AmountTextField).correspondingCurrency = handsOnCurrency
	}

	
	func setCurrency(currency: Currency) {
		self.code.text = currency.code.uppercaseString
		self.flag.image = currency.getFlag()
	}
}
