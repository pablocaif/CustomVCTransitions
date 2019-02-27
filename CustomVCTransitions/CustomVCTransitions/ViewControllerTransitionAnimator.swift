//
//  TransitionAnimator.swift
//  CustomVCTransitions
//
//  Created by Pablo Caif on 27/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import UIKit

class ViewControllerTransitionAnimator:NSObject, UIViewControllerAnimatedTransitioning {
    var animator: UIViewImplicitlyAnimating?
    let duration: TimeInterval

    init(duration: TimeInterval = 0.3) {
        self.duration = duration
        super.init()
    }

    func createAnimator(for transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        preconditionFailure("This method must be overridden")
    }
}

extension ViewControllerTransitionAnimator {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animator = createAnimator(for: transitionContext)
        animator?.startAnimation()
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        guard let animator = animator
            else {
                let animator = createAnimator(for: transitionContext)
                self.animator = animator
                return animator
        }
        return animator
    }
}
