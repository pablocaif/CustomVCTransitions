//
//  SlideUpAnimatedTransition.swift
//  CustomVCTransitions
//
//  Created by Pablo Caif on 18/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import UIKit

///This Animation controller will produce a slide up animation when presenting modaly a ViewController
class SlideUpAnimatedTransition: ViewControllerTransitionAnimator {
   
    override func createAnimator(for transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        //By using snapshots we avoid doing constraints manipulation such as activating and deactivating constraints
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let fromSnapshot = fromViewController.view.snapshotView(afterScreenUpdates: true),
            let toViewController = transitionContext.viewController(forKey: .to),
            let window = UIApplication.shared.keyWindow
            else {
                return UIViewPropertyAnimator(duration: 0, timingParameters: UICubicTimingParameters(animationCurve: .easeInOut))
        }

        //We need to make sure the presented view has the right size before taking the snapshoot
        //For some reason some times the size is incorrect this fix that issue
        let containerView = transitionContext.containerView
        toViewController.view.frame.size = containerView.frame.size
        guard let toSnapshot = toViewController.view.snapshotView(afterScreenUpdates: true)
            else {
                return UIViewPropertyAnimator(duration: 0, timingParameters: UICubicTimingParameters(animationCurve: .easeInOut))
        }

        //Prepare the presented view for the presentation animation
        let finalFrame = transitionContext.finalFrame(for: toViewController)
        var initialFrame = finalFrame
        initialFrame.origin.y = window.frame.height + 10.0
        toSnapshot.frame = initialFrame
        toSnapshot.layer.masksToBounds = true
        toViewController.view.isHidden = true

        //Prepare the presenting view for presenting animation
        fromSnapshot.layer.masksToBounds = true
        fromViewController.view.isHidden = true

        containerView.addSubview(fromSnapshot)
        containerView.addSubview(toViewController.view)
        containerView.addSubview(toSnapshot)

        let duration = transitionDuration(using: transitionContext)
        
        let animator = UIViewPropertyAnimator(
            duration: duration,
            dampingRatio: 0.7) {
                let percentageToScale = CGFloat(0.96)
                toSnapshot.frame = finalFrame
                fromSnapshot.layer.setAffineTransform(CGAffineTransform(scaleX: percentageToScale, y: percentageToScale))
                
        }
        animator.addCompletion { _ in
            toViewController.view.isHidden = false
            toSnapshot.removeFromSuperview()
            transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
        }
        
        return animator
    }
}

