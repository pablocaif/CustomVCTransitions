//
//  SettingsWireframe.swift
//  CustomVCTransitions
//
//  Created by Pablo Caif on 18/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import UIKit
import CoreGraphics

class SettingsWireframe: NSObject {

    private weak var presentingViewController: UIViewController?
    //Interactive presentation
    private let swipeDownInteractiveTransition = SwipeDownInteractiveTransition()
    private var settingsViewController: SettingsViewController?

    func showSettings(onViewController viewController: UIViewController) {
        guard let navViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsNavigationController") as? UINavigationController,
            let destinationViewController = navViewController.topViewController as? SettingsViewController
            else {
                return
        }

        destinationViewController.navigationDelegate = self
        settingsViewController = destinationViewController
        configureViewControlerForInteractivePresentation(viewController: navViewController,
                                                         swipeDownInteractiveTransition: swipeDownInteractiveTransition)
        self.presentingViewController = viewController
        viewController.present(navViewController, animated: true, completion: nil)
    }
}

extension SettingsWireframe: SettingsNavigationDelegate {
    func dismiss() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Interactive presentation
extension SettingsWireframe: InteractiveModalPresentationType {
    func shouldBeginTransition() -> Bool {
        return settingsViewController?.didScrollFarEnoughForDismissal ?? false
    }
    
    //I was trying to add this 2 methods as default implementations to InteractiveModalPresentationType
    //however since UIViewControllerTransitioningDelegate is @objc it won't compile.
    //Even more the compiler crashes refer to https://bugs.swift.org/browse/SR-3349?filter=-4
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return swipeDownInteractiveTransition.interactionInProgress ? swipeDownInteractiveTransition : nil
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideUpAnimatedTransition()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideDownAnimatedTransition()
    }

    func startDismissing() {
        dismiss()
    }

    func viewToAddDismissGesture() -> UIView? {
        return settingsViewController?.view
    }
}
