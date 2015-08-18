//
//  MenuTransitionManager.swift
//  Menu
//
//  Created by Mathew Sanders on 9/7/14.
//  Copyright (c) 2014 Mat. All rights reserved.
//

import UIKit

class MenuTransitionManager: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning {
	
	private var presenting = false
	private var interactive = false
	
	private var enterPanGesture: UIScreenEdgePanGestureRecognizer!
	private var statusBarBackground: UIView!
	
	var sourceViewController: ViewController! {
		// We’re going to add an observer to our sourceViewController property.
		// With the following syntax we can create a mini block of code that will get executed anytime that variable is updated.
		didSet {
			self.enterPanGesture = UIScreenEdgePanGestureRecognizer()
			self.enterPanGesture.addTarget(self, action:"handleOnstagePan:")
			self.enterPanGesture.edges = UIRectEdge.Left
			self.sourceViewController.view.addGestureRecognizer(self.enterPanGesture)	
		}
	}
	
	private var exitPanGesture: UIPanGestureRecognizer!
	
	var transViewController: UIViewController! {
		didSet {
			self.exitPanGesture = UIPanGestureRecognizer()
			self.exitPanGesture.addTarget(self, action:"handleOffstagePan:")
			self.transViewController.view.addGestureRecognizer(self.exitPanGesture)
		}
	}
	
	func handleOnstagePan(pan: UIPanGestureRecognizer){
		// how much distance have we panned in reference to the parent view?
		let translation = pan.translationInView(pan.view!)
		
		// do some math to translate this to a percentage based value
		let d = translation.x / CGRectGetWidth(pan.view!.bounds) * 0.5
		
		// now lets deal with different states that the gesture recognizer sends
		switch (pan.state) {
			
		case UIGestureRecognizerState.Began:
			// set our interactive flag to true
			self.interactive = true
			
			// trigger the start of the transition
			self.sourceViewController.performSegueWithIdentifier(self.sourceViewController.kShowTransactionSegue, sender: self)
			break
			
		case UIGestureRecognizerState.Changed:
			
			// update progress of the transition
			self.updateInteractiveTransition(d)
			break
			
		default: // .Ended, .Cancelled, .Failed ...
			
			// return flag to false and finish the transition
			self.interactive = false
			if(d > 0.2){
				// threshold crossed: finish
				self.finishInteractiveTransition()
			}
			else {
				// threshold not met: cancel
				self.cancelInteractiveTransition()
			}
		}
	}
	
	// pretty much the same as 'handleOnstagePan' except
	// we're panning from right to left
	// perfoming our exitSegeue to start the transition
	func handleOffstagePan(pan: UIPanGestureRecognizer){
		
		let translation = pan.translationInView(pan.view!)
		let d =  translation.x / CGRectGetWidth(pan.view!.bounds) * -0.5
		
		switch (pan.state) {
			
		case UIGestureRecognizerState.Began:
			self.interactive = true
			self.transViewController.performSegueWithIdentifier("dismissMenu", sender: self)
			break
			
		case UIGestureRecognizerState.Changed:
			self.updateInteractiveTransition(d)
			break
			
		default: // .Ended, .Cancelled, .Failed ...
			self.interactive = false
			if(d > 0.1){
				self.finishInteractiveTransition()
			}
			else {
				self.cancelInteractiveTransition()
			}
		}
	}
	
	// MARK: UIViewControllerAnimatedTransitioning protocol methods
	
	// animate a change from one viewcontroller to another
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		
		// get reference to our fromView, toView and the container view that we should perform the transition in
		let container = transitionContext.containerView()
		
		// create a tuple of our screens
		let screens : (from:UIViewController, to:UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
		
		// assign references to our menu view controller and the 'bottom' view controller from the tuple
		// remember that our transViewController will alternate between the from and to view controller depending if we're presenting or dismissing
		let transViewController = !self.presenting ? screens.from as! TransactionsTableViewController : screens.to as! TransactionsTableViewController
		let topViewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
		
		let menuView = transViewController.view
		let topView = topViewController.view
		
		// prepare menu items to slide in
		if (self.presenting){
			self.offStageTransControllerInteractive(transViewController) // offstage for interactive
		}
		
		// add the both views to our view controller
		
		container.addSubview(menuView)
		container.addSubview(topView)
		container.addSubview(self.statusBarBackground)
		
		let duration = self.transitionDuration(transitionContext)
		
		// perform the animation!
		UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: {
			
			if (self.presenting){
				self.offStageTransController(transViewController) // onstage items: slide in
				topView.transform = self.offStage(290)
			}
			else {
				topView.transform = CGAffineTransformIdentity
				self.offStageTransControllerInteractive(transViewController)
			}
			
			}, completion: { finished in
				
				// tell our transitionContext object that we've finished animating
				if(transitionContext.transitionWasCancelled()){
					
					transitionContext.completeTransition(false)
					// bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
					UIApplication.sharedApplication().keyWindow?.addSubview(screens.from.view)
					
				}
				else {
					
					transitionContext.completeTransition(true)
					// bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
					UIApplication.sharedApplication().keyWindow?.addSubview(screens.to.view)
					
				}
				UIApplication.sharedApplication().keyWindow?.addSubview(self.statusBarBackground)
				
		})
		
	}

	
	func offStage(amount: CGFloat) -> CGAffineTransform {
		return CGAffineTransformMakeTranslation(amount, 0)
	}
	
	func offStageTransControllerInteractive(transViewController: TransactionsTableViewController){
		
		transViewController.view.alpha = 0
		self.statusBarBackground.backgroundColor = self.sourceViewController.view.backgroundColor
		
		// setup paramaters for 2D transitions for animations
		let offstageOffset  :CGFloat = -200
		
		transViewController.view.transform = self.offStage(offstageOffset)
	}
	
	
	func offStageTransController(transViewController: TransactionsTableViewController){
		
		// prepare menu to fade in
		transViewController.view.alpha = 1
		self.statusBarBackground.backgroundColor = UIColor.blackColor()
		
		transViewController.view.transform = CGAffineTransformIdentity
	}
	
	// return how many seconds the transiton animation will take
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
		return 0.5
	}
	
	// MARK: UIViewControllerTransitioningDelegate protocol methods
	// return the animataor when presenting a viewcontroller
	// rememeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
	func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		self.presenting = true
		return self
	}
	
	// return the animator used when dismissing from a viewcontroller
	func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		self.presenting = false
		return self
	}
	
	func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		// if our interactive flag is true, return the transition manager object
		// otherwise return nil
		return self.interactive ? self : nil
	}
	
	func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return self.interactive ? self : nil
	}
	
}