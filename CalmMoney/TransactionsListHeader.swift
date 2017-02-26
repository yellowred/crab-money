//
//  TransactionsListHeader.swift
//  CalmMoney
//
//  Created by Oleg Kubrakov on 26/2/2017.
//  Copyright © 2017 Oleg Kubrakov. All rights reserved.
//

import UIKit

/*
@see http://stackoverflow.com/questions/36926612/swift-how-creating-custom-viewforheaderinsection-using-a-xib-file
protocol TransactionsListHeaderDelegate: class {
	func didTapButton(in section: Int)
}
*/

class TransactionsListHeader: UITableViewHeaderFooterView {
	@IBOutlet weak var customLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
	
	var sectionNumber: Int!
	
}
