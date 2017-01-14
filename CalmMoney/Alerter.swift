//
//  Alert.swift
//  CalmMoney
//
//  Created by Oleg Kubrakov on 10/12/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import UIKit

public class Alerter: NSObject {

	public static var sharedInstance = Alerter()
	
	
	//MARK: - Initialize
	public override init() {
		super.init()
	}
	
	
	//MARK: - Present
	func loading(message: String) -> UIAlertController {
		let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		alert.view.tintColor = UIColor.black
		let rect = CGRect(x: 10, y: 5, width: 50, height: 50)
		let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: rect) as UIActivityIndicatorView
		loadingIndicator.hidesWhenStopped = true
		loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
		loadingIndicator.startAnimating();
		alert.view.addSubview(loadingIndicator)
		return alert
	}
	
	
	func notify(title: String?, message: String) -> UIAlertController {
		let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok".localized, style: .default, handler: nil))
		return alert
	}
	
}
