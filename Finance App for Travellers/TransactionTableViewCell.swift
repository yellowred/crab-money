//
//  TransactionTableViewCell.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 18/08/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

	@IBOutlet weak var flag: UIImageView!
	@IBOutlet weak var currencyCode: UILabel!
	@IBOutlet weak var amount: UILabel!
	@IBOutlet weak var date: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
