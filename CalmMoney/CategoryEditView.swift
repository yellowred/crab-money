//
//  CategoryEditView.swift
//  CalmMoney
//
//  Created by Oleg Kubrakov on 21/3/2017.
//  Copyright © 2017 Oleg Kubrakov. All rights reserved.
//  https://github.com/itsmeichigo/DateTimePicker/blob/master/Source/DateTimePicker.swift

import UIKit

class CategoryEditView: UIView {

	internal var colors: [UIColor] = [
			#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1), #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1), #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
		]
	
	let contentHeight: CGFloat = 220
	
	private var contentView: UIView!
	internal var categoryNameTextField: UITextField!
	internal var colorSelect: UICollectionView!
	internal var currentColor: UIColor?
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
		
		// content view
		self.contentView = UIView(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: contentHeight))
		
		contentView.layer.shadowColor = UIColor(white: 0, alpha: 0.3).cgColor
		contentView.layer.shadowOffset = CGSize(width: 0, height: -2.0)
		contentView.layer.shadowRadius = 1.5
		contentView.layer.shadowOpacity = 0.5
		contentView.backgroundColor = .white
		contentView.isHidden = true
		addSubview(contentView)
		
		
		let dateTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
		dateTitleLabel.font = UIFont.medium(ofSize: 18)
		dateTitleLabel.textColor = UIColor.darkGray
		dateTitleLabel.textAlignment = .center
		dateTitleLabel.text = "Edit category".localized
		dateTitleLabel.sizeToFit()
		dateTitleLabel.center = CGPoint(x: contentView.frame.width / 2, y: 25)
		contentView.addSubview(dateTitleLabel)
		
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
		
		colorSelect = UICollectionView(frame: CGRect(x: 0, y: 100, width: contentView.frame.width, height: 60), collectionViewLayout: layout)
		colorSelect.backgroundColor = .clear
		colorSelect.showsHorizontalScrollIndicator = false
		colorSelect.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
		colorSelect.dataSource = self
		colorSelect.delegate = self
		
		let inset = (colorSelect.frame.width - 75) / 2
		colorSelect.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)

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
			
			if let colorIndex = colors.index(where: { String(describing: $0) == String(describing: color) }) {
				let indexPath = IndexPath(row: colorIndex, section: 0)
				// до 5 индекса не скроллирует
				colorSelect.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
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
		
		currentColor = colors[indexPath.item]
		print("Selected color at \(indexPath)")
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
				currentColor = colors[indexPath.item]
			}
		}
	}
}

extension CategoryEditView: UITextFieldDelegate {
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
		self.endEditing(true)
		return false;
	}
	// MARK: Textfield Delegates <---
}

protocol CategoryEditProtocol {
	func saveCategory(name: String?, color: UIColor?)
	func getCategory() -> Category
}

