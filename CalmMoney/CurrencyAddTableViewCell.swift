//
//  CurrencyAddTableViewCell.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 24/06/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class CurrencyAddTableViewCell: UITableViewCell {

    
	@IBOutlet weak var addCurrency: UIButton!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		subviews.forEach { (view) in
			if type(of: view).description() == "_UITableViewCellSeparatorView" {
				view.isHidden = true
			}
		}
	}

}
