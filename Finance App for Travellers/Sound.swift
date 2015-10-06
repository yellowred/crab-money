//
//  Sound.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 06/10/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import Foundation
import AudioToolbox

class Sound {
	let soundFileTapObject: SystemSoundID = 0
	
	init() {
		// Create the URL for the source audio file. The URLForResource:withExtension: method is
		//    new in iOS 4.0.
		// NSBundle.mainBundle().pathForResource("Tock", ofType: "aiff")
		if let tapSound = NSBundle.mainBundle().pathForResource("tap", ofType: "aif") {
			let fileURL = NSURL(fileURLWithPath: tapSound)
			AudioServicesCreateSystemSoundID(fileURL, &soundFileTapObject)
		}
	}
	
	
	func playTap()
	{
		AudioServicesPlaySystemSound(soundFileTapObject)
	}
}