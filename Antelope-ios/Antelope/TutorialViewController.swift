//
//  TutorialViewController.swift
//  Antelope
//
//  Created by Jae Lee on 8/31/15.
//  Copyright © 2015 Antelope. All rights reserved.
//

import UIKit

protocol TutorialFlowDelegate {
    func tutorialDidFinish()
}

class TutorialViewController: ScrollViewController, TutorialStepDelegate {
    @IBOutlet weak var tutorialSplash: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var delegate: TutorialFlowDelegate!
    
    var colorKit = AntelopeColors()
    
    var absoluteStep: NSInteger = 0
    var step: NSInteger!
    
    var segueFromNotificationSetupFlow: Bool = false
    
    var tutorialStepZero: TutorialStepZero!
    var tutorialStepOne: TutorialStepOne!
    var tutorialStepTwo: TutorialStepTwo!
    var tutorialStepFour: TutorialStepFour!
    var tutorialStepThree: TutorialStepThree!
    
    var viewControllersForSteps: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.redColor()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.scrollView.delegate = self
        
        tutorialStepZero = storyboard.instantiateViewControllerWithIdentifier("TutorialStepZero") as? TutorialStepZero
        tutorialStepZero.delegate = self
        
        tutorialStepOne = storyboard.instantiateViewControllerWithIdentifier("TutorialStepOne") as? TutorialStepOne
        tutorialStepOne.delegate = self
        
        tutorialStepTwo = storyboard.instantiateViewControllerWithIdentifier("TutorialStepTwo") as? TutorialStepTwo
        tutorialStepTwo.delegate = self
        
        tutorialStepFour = storyboard.instantiateViewControllerWithIdentifier("TutorialStepFour") as? TutorialStepFour
        tutorialStepFour.delegate = self
        
        tutorialStepThree = storyboard.instantiateViewControllerWithIdentifier("TutorialStepThree") as? TutorialStepThree
        tutorialStepThree.delegate = self
        
        //viewControllersForSteps = [tutorialStepZero, tutorialStepOne, tutorialStepTwo, tutorialStepFour, tutorialStepThree, shareViewController]
        
        if segueFromNotificationSetupFlow {
            viewControllersForSteps = [tutorialStepThree]
            self.pageControl.numberOfPages = 0
        } else {
            viewControllersForSteps = [tutorialStepZero, tutorialStepThree]
            self.pageControl.numberOfPages = Int(viewControllersForSteps.count)
        }
        
        self.addChildViewControllers(viewControllersForSteps)
        self.view.bringSubviewToFront(self.pageControl)
        
        // START TUTORIAL, self-invoking
        _ = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "startTutorial", userInfo: nil, repeats: false)
        
    }
    
    func nextStep(index: NSInteger) {
        
        if index == self.childViewControllers.count - 1 {
            self.finishTutorial()
        } else {
            self.scrollToViewControllerAtIndex(index + 1)
        }
    }
    
    func startTutorial() {
        if let intro = self.childViewControllers[0] as? TutorialStepZero {
            intro.initialize()
        }
    }
    
    func finishTutorial() {
        
        if let settingsURL: NSURL = NSURL(string: "prefs:root") {
            let application: UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(settingsURL)) {
                application.openURL(settingsURL)
            } else {
                print("cant open settings")
            }
        }
        
        TutorialStep().delay(1.0) {
            self.delegate.tutorialDidFinish()
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let totalWidth: CGFloat = self.scrollView.frame.size.width
        let pageNumber: Int = Int(floor(self.scrollView.contentOffset.x - totalWidth/50) / totalWidth + 1)
        
        self.pageControl.currentPage = pageNumber
    }
    
    @IBAction func pageChanged(sender: AnyObject) {
        let pageNumber: Int = self.pageControl.currentPage
        self.scrollToViewControllerAtIndex(pageNumber)
    }
    
    override func scrollToViewControllerAtIndex(index: NSInteger) {
        super.scrollToViewControllerAtIndex(index)
    }
    
}
