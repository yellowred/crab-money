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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
