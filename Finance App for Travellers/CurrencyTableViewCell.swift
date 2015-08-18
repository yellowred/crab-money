//
//  CurrencyTableViewCell.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 22/06/15.
//  Copyright (c) 2015 Oleg Kubrakov. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell, UITableViewDelegate {

    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var currencyCode: UILabel!
    @IBOutlet weak var valueInput: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(#text: String?, placeholder: String) {
        valueInput.text = text
        valueInput.placeholder = placeholder
        
        valueInput.accessibilityValue = text
        valueInput.accessibilityLabel = placeholder
    }

}
