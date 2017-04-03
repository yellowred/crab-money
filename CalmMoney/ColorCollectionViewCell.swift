//
//  ColorCollectionViewCell.swift
//  CalmMoney
//
//  Created by Oleg Kubrakov on 21/3/2017.
//  Copyright © 2017 Oleg Kubrakov. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
	
	var dayLabel: UILabel! // rgb(128,138,147)
	var numberLabel: UILabel!
	var darkColor = UIColor(red: 0, green: 22.0/255.0, blue: 39.0/255.0, alpha: 1)
	var highlightColor = UIColor(red: 0/255.0, green: 199.0/255.0, blue: 194.0/255.0, alpha: 1)
	
	override init(frame: CGRect) {
		
		/*
		dayLabel = UILabel(frame: CGRect(x: 5, y: 15, width: frame.width - 10, height: 20))
		dayLabel.font = UIFont.systemFont(ofSize: 10)
		dayLabel.textAlignment = .center
		
		numberLabel = UILabel(frame: CGRect(x: 5, y: 30, width: frame.width - 10, height: 40))
		numberLabel.font = UIFont.systemFont(ofSize: 25)
		numberLabel.textAlignment = .center
		*/
		
		super.init(frame: frame)
		
		/*
		contentView.addSubview(dayLabel)
		contentView.addSubview(numberLabel)
		*/
		contentView.backgroundColor = .white
		contentView.layer.cornerRadius = 25
		contentView.layer.masksToBounds = true
		contentView.layer.borderWidth = 0
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override var isSelected: Bool {
		didSet {
			contentView.layer.borderWidth = isSelected == true ? 5 : 0
		}
	}
	
	func populateItem(highlightColor: UIColor, darkColor: UIColor) {
		self.highlightColor = highlightColor
		self.darkColor = darkColor

		contentView.layer.borderColor = UIColor.darkGray.cgColor
		contentView.backgroundColor = UIColor.lightGray
		contentView.layer.borderWidth = 0
		contentView.backgroundColor = highlightColor
	}

}
