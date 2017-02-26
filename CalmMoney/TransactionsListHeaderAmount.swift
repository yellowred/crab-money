//
//  TransactionsListHeaderAmount.swift
//  CalmMoney
//
//  Created by Oleg Kubrakov on 27/2/2017.
//  Copyright © 2017 Oleg Kubrakov. All rights reserved.
//

import UIKit

class TransactionsListHeaderAmount: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

	override func drawText(in rect: CGRect) {
		let insets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 18)
		super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
	}
}
