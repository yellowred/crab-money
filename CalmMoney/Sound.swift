//
//  Sound.swift
//  Finance App for Travellers
//
//  Created by Oleg Kubrakov on 06/10/15.
//  Copyright © 2015 Oleg Kubrakov. All rights reserved.
//

import Foundation
import AVFoundation

class Sound {
	var tapSound:URL?
	var tapPlayer:AVAudioPlayer?
	
	static let sharedInstance = Sound()

	init() {
		/*
		tapSound = NSBundle.mainBundle().URLForResource("tap-mellow", withExtension: "aif")
		do {
			try self.tapPlayer = AVAudioPlayer(contentsOfURL: tapSound!)
		} catch let error as NSError {
			print("init Sound error: \(error.localizedDescription)")
			self.tapPlayer = nil
		}
		if self.tapPlayer != nil {
			self.tapPlayer!.prepareToPlay()
		}
		*/
	}

	func playTap()
	{
		if tapPlayer != nil {
			tapPlayer!.play()
		}
	}
}
