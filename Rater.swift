//
//  Rater.swift
//  CrabApp
//
//  Created by Oleg Kubrakov on 2/12/2016.
//  Copyright © 2016 Oleg Kubrakov. All rights reserved.
//

import UIKit

let kAppLaunchNumber = "rater_app_launch_number"
let kAppFirstLaunchDate = "rater_app_first_launch_date"
let kAppRatingShown = "rater_app_rating_shown"
let kRequiredLaunchesBeforeRating = "rater-required-launches-before-rating"

public class Rater: NSObject {
	var application: UIApplication!
	var userdefaults = UserDefaults()
	var requiredLaunchesBeforeRating = 3
	
	public var appId: String!
	
	public static var sharedInstance = Rater()
	
	//MARK: - Initialize
	public override init() {
		super.init()
		
		requiredLaunchesBeforeRating = Config.read(value: kRequiredLaunchesBeforeRating) as! Int
		setup()
	}
	
	private func setup() {
		NotificationCenter.default.addObserver(self, selector: #selector(Rater.appDidFinishLaunching(notification:)), name: NSNotification.Name.UIApplicationDidFinishLaunching, object: nil)
	}
	
	func appDidFinishLaunching(notification: NSNotification) {
		if let _application = notification.object as? UIApplication {
			application = _application
			displayRatingPromptIfRequired()
		}
	}
	
	private func displayRatingPromptIfRequired() {
		let launches = getAppLaunchCount()
		print("launches=\(launches), required=\(requiredLaunchesBeforeRating)")
		if launches >= requiredLaunchesBeforeRating {
			rateTheApp()
		}
		incrementAppLaunches()
	}
	
	private func rateTheApp() {
		let message = "Enjoying Calm Money? Please rate us. It helps us to provide better updates.".localized
		let rateAlert = UIAlertController(title:"Rate us".localized, message: message, preferredStyle: .alert)
		rateAlert.addAction(UIAlertAction(title: "Rate".localized, style: .default, handler: { (action) -> Void in
			self.openRatePage()
			self.setAppRatingShown()
		}))
		rateAlert.addAction(UIAlertAction(title: "Not Now", style: .cancel, handler: { (action) -> Void in
			self.resetAppLaunches()
		}))
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(20), execute: {
			let window = self.application.windows[0]
			window.rootViewController?.present(rateAlert, animated: true, completion: nil)
		})
	}
	
	func openRatePage() {
		let url = NSURL(string: "itms-apps://itunes.apple.com/app/id\(Config.read(value: "appstore-id"))")
		UIApplication.shared.openURL(url! as URL)
	}
	
	//MARK: - App Launch Count
	private func getAppLaunchCount()  -> Int{
		return userdefaults.integer(forKey: kAppLaunchNumber)
	}
	
	private func incrementAppLaunches() {
		var launches = userdefaults.integer(forKey: kAppLaunchNumber)
		launches += 1
		userdefaults.set(launches, forKey: kAppLaunchNumber)
	}
	
	
	private func resetAppLaunches() {
		userdefaults.set(0, forKey: kAppLaunchNumber)
	}
	
	//MARK: - Firset Launch Date
	private func setFirstLaunchDate() {
		userdefaults.setValue(NSDate(), forKey: kAppFirstLaunchDate)
	}
	
	private func getFirstLaunchDate() -> NSDate {
		if let date = userdefaults.value(forKey: kAppFirstLaunchDate) as? NSDate {
			return date
		}
		return NSDate()
	}
	
	//MARK: - App Rating Shown
	private func setAppRatingShown() {
		userdefaults.set(true, forKey: kAppRatingShown)
		userdefaults.synchronize()
	}
	
	private func hasShownAppRating() -> Bool {
		return userdefaults.bool(forKey: kAppRatingShown)
	}
	
	
}
