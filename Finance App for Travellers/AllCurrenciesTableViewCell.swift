//
//  AllCurrenciesTableViewCell.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 22/10/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class AllCurrenciesTableViewCell: UITableViewCell {

	@IBOutlet weak var flag: UIImageView!
	@IBOutlet weak var code: UILabel!
	@IBOutlet weak var name: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	
	func setCurrency(currency: Currency) {
		self.code.text = currency.code.uppercaseString
		self.flag.image = currency.getFlag()
		self.name.text = currency.getLocalizedName()
	}

}
