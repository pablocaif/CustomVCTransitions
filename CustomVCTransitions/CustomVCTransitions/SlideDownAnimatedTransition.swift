//
//  SlideDownAnimatedTransition.swift
//  CustomVCTransitions
//
//  Created by Pablo Caif on 18/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import UIKit

///This Animation controller will produce an slide down animation for modaly presented
///ViewControllers
public class SlideDownAnimatedTransition: NSObject {
    private let duration: TimeInterval
    private let percentageToScale: CGFloat

    public init(duration: TimeInterval = 0.3, percentageToScalePresentingView: CGFloat = 0.96) {
        self.duration = duration
        self.percentageToScale = percentageToScalePresentingView
    }
}
extension SlideDownAnimatedTransition: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //By using snapshots we avoid doing constraints manipulation such as activating and deactivating constraints
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let fromSnapshot = fromViewController.view.snapshotView(afterScreenUpdates: true),
            let toViewController = transitionContext.viewController(forKey: .to),
            let window = UIApplication.shared.keyWindow
            else { return }
        //We need to make sure the frame for the destination view controller is correct before snapshooting
        let containerView = transitionContext.containerView
        toViewController.view.frame = containerView.frame

        //We need to make sure the presenting view controllers view is visible before taking the snapshot
        toViewController.view.isHidden = false
        guard let toSnapshot = toViewController.view.snapshotView(afterScreenUpdates: true) else { return }

        //Prepare presented view for dismissal animation
        let initialFrame = fromViewController.view.frame
        var finalFrame = initialFrame
        finalFrame.origin.y = window.frame.height + 10.0
        fromSnapshot.layer.masksToBounds = true
        fromSnapshot.frame = initialFrame

        //Prepare presenting view for dismissal animation
        toSnapshot.layer.masksToBounds = true
        toSnapshot.clipsToBounds = true
        toSnapshot.layer.setAffineTransform(CGAffineTransform(scaleX: percentageToScale, y: percentageToScale))

        //Add views for the animation
        containerView.addSubview(toViewController.view)
        containerView.addSubview(toSnapshot)
        containerView.addSubview(fromSnapshot)
        fromViewController.view.isHidden = true
        toViewController.view.isHidden = true

        let duration = transitionDuration(using: transitionContext)

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                fromSnapshot.frame = finalFrame
                toSnapshot.layer.setAffineTransform(CGAffineTransform.identity)
        },
            completion: { _ in
                toViewController.view.isHidden = false
                let transitionCancelled = transitionContext.transitionWasCancelled
                toSnapshot.removeFromSuperview()
                fromSnapshot.removeFromSuperview()
                if transitionCancelled {
                    toViewController.view.removeFromSuperview()
                    fromViewController.view.isHidden = false
                } else {
                    fromViewController.view.removeFromSuperview()
                }
                transitionContext.completeTransition(transitionCancelled == false)
        }
        )
    }
}
