//
//  CategoryEditView.swift
//  CalmMoney
//
//  Created by Oleg Kubrakov on 21/3/2017.
//  Copyright © 2017 Oleg Kubrakov. All rights reserved.
//  https://github.com/itsmeichigo/DateTimePicker/blob/master/Source/DateTimePicker.swift

import UIKit

class CategoryEditView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

	internal var colors: [UIColor]! = [UIColor.green, UIColor.red, UIColor.blue, UIColor.cyan, UIColor.magenta]
	let contentHeight: CGFloat = 310
	private var contentView: UIView!
	
	class func show() -> CategoryEditView {
		let categoryEditView = CategoryEditView()
		categoryEditView.configureView()
		UIApplication.shared.keyWindow?.addSubview(categoryEditView)
		return categoryEditView
	}
	
	func configureView() {

		let screenSize = UIScreen.main.bounds.size
		self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
		
		// content view
		self.contentView = UIView(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: contentHeight))
		
		contentView.layer.shadowColor = UIColor(white: 0, alpha: 0.3).cgColor
		contentView.layer.shadowOffset = CGSize(width: 0, height: -2.0)
		contentView.layer.shadowRadius = 1.5
		contentView.layer.shadowOpacity = 0.5
		contentView.backgroundColor = .white
		contentView.isHidden = true
		addSubview(contentView)
		
		
		let titleView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: contentView.frame.width, height: 44)))
		titleView.backgroundColor = .white
		contentView.addSubview(titleView)
		
		let dateTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
		dateTitleLabel.font = UIFont.systemFont(ofSize: 15)
		dateTitleLabel.textColor = UIColor.darkGray
		dateTitleLabel.textAlignment = .center
		dateTitleLabel.text = "Hello world!"
		dateTitleLabel.sizeToFit()
		dateTitleLabel.center = CGPoint(x: contentView.frame.width / 2, y: 22)
		titleView.addSubview(dateTitleLabel)
		
		let categoryNameTextField = UITextField(frame: CGRect(x: 0, y: 44, width: 200, height: 44))
		categoryNameTextField.placeholder = "Enter text here"
		categoryNameTextField.text = "Sport"
		categoryNameTextField.font = UIFont.systemFont(ofSize: 15)
		categoryNameTextField.borderStyle = UITextBorderStyle.roundedRect
		categoryNameTextField.autocorrectionType = UITextAutocorrectionType.no
		categoryNameTextField.keyboardType = UIKeyboardType.default
		categoryNameTextField.returnKeyType = UIReturnKeyType.done
		categoryNameTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
		categoryNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center

		categoryNameTextField.textAlignment = .center
		categoryNameTextField.center = CGPoint(x: contentView.frame.width / 2, y: 66)
		categoryNameTextField.delegate = CategoryNameTextFieldController()
		contentView.addSubview(categoryNameTextField)
		contentView.bringSubview(toFront: categoryNameTextField)
		
		
		let layout = StepCollectionFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumInteritemSpacing = 10
		layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
		layout.itemSize = CGSize(width: 75, height: 80)
		
		let collectionView = UICollectionView(frame: CGRect(x: 0, y: 88, width: contentView.frame.width, height: 100), collectionViewLayout: layout)
		collectionView.backgroundColor = .white
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
		collectionView.dataSource = self
		collectionView.delegate = self
		
		let inset = (collectionView.frame.width - 75) / 2
		collectionView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
		contentView.addSubview(collectionView)

		
		// done button
		let doneButton = UIButton(type: .system)
		doneButton.frame = CGRect(x: 10, y: contentView.frame.height - 10 - 44, width: contentView.frame.width - 20, height: 44)
		doneButton.setTitle("Done".localized, for: .normal)
		doneButton.setTitleColor(.white, for: .normal)
		doneButton.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
		doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
		doneButton.layer.cornerRadius = 3
		doneButton.layer.masksToBounds = true
		doneButton.addTarget(self, action: #selector(CategoryEditView.dismissView), for: .touchUpInside)
		contentView.addSubview(doneButton)
		
		
		
		contentView.isHidden = false
		// animate to show contentView
		UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: .curveEaseIn, animations: {
			self.contentView.frame = CGRect(x: 0,
			                           y: self.frame.height - self.contentHeight,
			                           width: self.frame.width,
			                           height: self.contentHeight)
		}, completion: nil)
	}
	
	func dismissView() {
		UIView.animate(withDuration: 0.3, animations: {
			// animate to show contentView
			self.contentView.frame = CGRect(x: 0,
			                                y: self.frame.height,
			                                width: self.frame.width,
			                                height: self.contentHeight)
		}) { (completed) in
			self.removeFromSuperview()
		}
	}
}

extension CategoryEditView: UICollectionViewDataSource, UICollectionViewDelegate {
	public func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return colors.count
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCollectionViewCell
		
		let color = colors[indexPath.item]
		cell.populateItem(highlightColor: color, darkColor: color)
		
		return cell
	}
	
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		//workaround to center to every cell including ones near margins
		if let cell = collectionView.cellForItem(at: indexPath) {
			let offset = CGPoint(x: cell.center.x - collectionView.frame.width / 2, y: 0)
			collectionView.setContentOffset(offset, animated: true)
		}
		
		// update selected dates
		let color = colors[indexPath.item]
	}
	
	public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		alignScrollView(scrollView)
	}
	
	public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if !decelerate {
			alignScrollView(scrollView)
		}
	}
	
	func alignScrollView(_ scrollView: UIScrollView) {
		if let collectionView = scrollView as? UICollectionView {
			let centerPoint = CGPoint(x: collectionView.center.x + collectionView.contentOffset.x, y: 50);
			if let indexPath = collectionView.indexPathForItem(at: centerPoint) {
				// automatically select this item and center it to the screen
				// set animated = false to avoid unwanted effects
				collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
				if let cell = collectionView.cellForItem(at: indexPath) {
					let offset = CGPoint(x: cell.center.x - collectionView.frame.width / 2, y: 0)
					collectionView.setContentOffset(offset, animated: false)
				}
				
				// update selected date
				let date = colors[indexPath.item]
			}
		}
	}
}

class CategoryNameTextFieldController: UIViewController, UITextFieldDelegate {
	// MARK:- ---> Textfield Delegates
	func textFieldDidBeginEditing(_ textField: UITextField) {
		print("TextField did begin editing method called")
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		print("TextField did end editing method called")
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		print("TextField should begin editing method called")
		return true;
	}
	
	func textFieldShouldClear(_ textField: UITextField) -> Bool {
		print("TextField should clear method called")
		return true;
	}
	
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		print("TextField should snd editing method called")
		return true;
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		print("While entering the characters this method gets called")
		return true;
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		print("TextField should return method called")
		textField.resignFirstResponder();
		return true;
	}
	// MARK: Textfield Delegates <---
}

