//
//  InteractiveModalPresentationType.swift
//  InteractivePresentations
//
//  Created by Pablo Caif on 18/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import UIKit

///This protocol abstract parts of the interactive presentation and aims to make the implementation easier in the Coordinators
protocol InteractiveModalPresentationType: UIViewControllerTransitioningDelegate, SwipeDownInteractiveTransitionDelegate {
    func configureViewControlerForInteractivePresentation(viewController: UIViewController, swipeDownInteractiveTransition: SwipeDownInteractiveTransition)
}

extension InteractiveModalPresentationType {

    func configureViewControlerForInteractivePresentation(viewController: UIViewController, swipeDownInteractiveTransition: SwipeDownInteractiveTransition) {
        viewController.transitioningDelegate = self
        swipeDownInteractiveTransition.configureInteractiveTransitionDelegate(delegate: self)
    }
}
