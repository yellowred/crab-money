//
//  CategoryEditView.swift
//  CalmMoney
//
//  Created by Oleg Kubrakov on 21/3/2017.
//  Copyright © 2017 Oleg Kubrakov. All rights reserved.
//  https://github.com/itsmeichigo/DateTimePicker/blob/master/Source/DateTimePicker.swift

import UIKit

class CategoryEditView: UIView {
	
	let contentHeight: CGFloat = 220
	
	private var contentView: UIView!
	var categoryNameTextField: UITextField!
	var colorSelect: UICollectionView!
	var currentColor: UIColor?
	var editCategoryDelegate: CategoryEditProtocol!
	
	
	class func show(delegate: CategoryEditProtocol) -> CategoryEditView {
		let categoryEditView = CategoryEditView()
		categoryEditView.editCategoryDelegate = delegate
		categoryEditView.configureView()

		UIApplication.shared.keyWindow?.addSubview(categoryEditView)
		return categoryEditView
	}
	
	
	func configureView() {

		let screenSize = UIScreen.main.bounds.size
		self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
		
		self.contentView = UIView(frame: CGRect(
											x: 0,
											y: self.frame.height,
											width: self.frame.width,
											height: self.contentHeight
										))
		
		contentView.layer.shadowColor = UIColor(white: 0, alpha: 0.3).cgColor
		contentView.layer.shadowOffset = CGSize(width: 0, height: -2.0)
		contentView.layer.shadowRadius = 1.5
		contentView.layer.shadowOpacity = 0.5
		contentView.backgroundColor = .white
		contentView.isHidden = true
		addSubview(contentView)
		
		
		let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
		titleLabel.font = UIFont.medium(ofSize: 18)
		titleLabel.textColor = UIColor.darkGray
		titleLabel.textAlignment = .center
		titleLabel.text = "Edit category".localized
		titleLabel.sizeToFit()
		titleLabel.center = CGPoint(x: contentView.frame.width / 2, y: 25)
		contentView.addSubview(titleLabel)
		
		categoryNameTextField = UITextField(frame: CGRect(x: 0, y: 60, width: contentView.frame.width - 20, height: 40))
		categoryNameTextField.placeholder = "Enter category name".localized
		if (editCategoryDelegate.getCategory().name.length > 0) {
			categoryNameTextField.text = editCategoryDelegate.getCategory().name
		}
		categoryNameTextField.font = UIFont.light(ofSize: 16)
		categoryNameTextField.borderStyle = UITextBorderStyle.roundedRect
//		categoryNameTextField.autocorrectionType = UITextAutocorrectionType.no
		categoryNameTextField.keyboardType = UIKeyboardType.default
		categoryNameTextField.returnKeyType = UIReturnKeyType.done
		categoryNameTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
		categoryNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center

		categoryNameTextField.textAlignment = .center
		categoryNameTextField.center = CGPoint(x: contentView.frame.width / 2, y: 70)
		categoryNameTextField.delegate = self
		contentView.addSubview(categoryNameTextField)
//		contentView.bringSubview(toFront: categoryNameTextField)
		
		
		let layout = StepCollectionFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumInteritemSpacing = 10
		layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
		layout.itemSize = CGSize(width: 50, height: 50)
		let inset = (contentView.frame.width - 75) / 2
		layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
		
		colorSelect = UICollectionView(frame: CGRect(x: 0, y: 100, width: contentView.frame.width, height: 60), collectionViewLayout: layout)
		colorSelect.backgroundColor = .clear
		colorSelect.showsHorizontalScrollIndicator = false
		colorSelect.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
		colorSelect.dataSource = self
		colorSelect.delegate = self
		contentView.addSubview(colorSelect)

		let horizontalLineView = UIView(frame: CGRect(x:0, y: 170, width: contentView.frame.width, height: 1))
		horizontalLineView.backgroundColor = UIColor(rgba: "#f0f0f0")
		contentView.addSubview(horizontalLineView)

		
		// done button
		let doneButton = UIButton(type: .system)
		doneButton.frame = CGRect(x: 10, y: 175, width: contentView.frame.width - 20, height: 40)
		doneButton.setTitle("Done".localized, for: .normal)
//		doneButton.setTitleColor(.white, for: .normal)
//		doneButton.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
		doneButton.titleLabel?.font = UIFont.medium(ofSize: 18)
//		doneButton.layer.cornerRadius = 3
//		doneButton.layer.masksToBounds = true
		doneButton.addTarget(self, action: #selector(CategoryEditView.dismissView), for: .touchUpInside)
		contentView.addSubview(doneButton)
		
		registerForKeyboardNotifications()
		
		contentView.isHidden = false
		
		
		if let color = editCategoryDelegate.getCategory().getColor() {
			
			if let colorIndex = Category.friendlyColors.index(where: { String(describing: $0) == String(describing: color) }) {
				let indexPath = IndexPath(row: colorIndex, section: 0)
				// до 5 индекса не скроллирует
				colorSelect.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
//				colorSelect.setContentOffset(CGPoint(x: CGFloat(colorIndex * 100) - colorSelect.frame.width / 2, y: 0), animated: true)
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
					self.colorSelect.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
				})
				print(indexPath)
			}
		}
		
		// animate to show contentView
		UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: .curveEaseIn, animations: {
			self.contentView.frame = CGRect(x: 0,
			                                y: self.frame.height - self.contentHeight,
			                                width: self.frame.width,
			                                height: self.contentHeight)
		}, completion: nil)

	}
	
	
	func dismissView(_ sender: UIView) {
		unregisterFromKeyboardNotifications()
		UIView.animate(withDuration: 0.3, animations: {
			// animate to show contentView
			self.contentView.frame = CGRect(x: 0,
			                                y: self.frame.height,
			                                width: self.frame.width,
			                                height: self.contentHeight)
		}) { (completed) in
			self.editCategoryDelegate.saveCategory(name: self.categoryNameTextField.text, color: self.currentColor)
			self.removeFromSuperview()
		}
	}
	
	
	func registerForKeyboardNotifications()
	{
		//Adding notifies on keyboard appearing
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	
	func unregisterFromKeyboardNotifications()
	{
		//Removing notifies on keyboard appearing
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	func keyboardWasShown(notification: NSNotification)
	{
		//Need to calculate keyboard exact size due to Apple suggestions
		let info : NSDictionary = notification.userInfo! as NSDictionary
		let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size

		contentView.frame = CGRect(x: 0,
		                           y: contentView.frame.minY - keyboardSize!.height,
		                           width: contentView.frame.width,
		                           height: contentView.frame.height)
	}
	
	
	func keyboardWillBeHidden(notification: NSNotification)
	{
		//Once keyboard disappears, restore original positions
		let info : NSDictionary = notification.userInfo! as NSDictionary
		let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
		contentView.frame = CGRect(x: 0,
		                           y: contentView.frame.minY + keyboardSize!.height,
		                           width: contentView.frame.width,
		                           height: contentView.frame.height)
	}
}

extension CategoryEditView: UICollectionViewDataSource, UICollectionViewDelegate {
	public func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return Category.friendlyColors.count
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCollectionViewCell
		
		let color = Category.friendlyColors[indexPath.item]
		cell.populateItem(highlightColor: color, darkColor: color)
		
		return cell
	}
	
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		//workaround to center to every cell including ones near margins
		if let cell = collectionView.cellForItem(at: indexPath) {
			let offset = CGPoint(x: cell.center.x - collectionView.frame.width / 2, y: 0)
			collectionView.setContentOffset(offset, animated: true)
		}
		
		currentColor = Category.friendlyColors[indexPath.item]
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
				currentColor = Category.friendlyColors[indexPath.item]
			}
		}
	}
}

extension CategoryEditView: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder();
		self.endEditing(true)
		return false;
	}
}

protocol CategoryEditProtocol {
	func saveCategory(name: String?, color: UIColor?)
	func getCategory() -> Category
}

