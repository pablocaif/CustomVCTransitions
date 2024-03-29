//
//  PhotoZoomOutAnimatedTransition.swift
//  CustomVCTransitions
//
//  Created by Pablo Caif on 20/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import UIKit

class PhotoZoomOutAnimatedTransition: ViewControllerTransitionAnimator {

    override func createAnimator(for transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        guard let sourceViewProvider = transitionContext.viewController(forKey: .from) as? ImageViewProvider,
            let destinationProvier = transitionContext.viewController(forKey: .to) as? CollectionViewProvider,
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
            else {
                return UIViewPropertyAnimator(duration: 0, timingParameters: UICubicTimingParameters(animationCurve: .easeInOut))
        }

        //Find the destination cell for the zoom out animation
        guard let collectionView = toView.viewWithTag(destinationProvier.collectionViewKey) as? UICollectionView,
            let indexPath = collectionView.indexPathsForSelectedItems?[0],
            let destinationView = collectionView.cellForItem(at: indexPath)
            else {
                return UIViewPropertyAnimator(duration: 0, timingParameters: UICubicTimingParameters(animationCurve: .easeInOut))
        }

        //Prepare the from and to view for the animations
        destinationView.isHidden = true
        transitionContext.containerView.addSubview(fromView)
        toView.alpha = 0.0
        transitionContext.containerView.addSubview(toView)

        //Find the final frame for the zoom out animation
        var destinationViewFrame = destinationView.frame
        destinationViewFrame.origin = CGPoint(x: destinationViewFrame.origin.x - collectionView.contentOffset.x, y: destinationViewFrame.origin.y - collectionView.contentOffset.y)

        //Find the image view in the photo details
        guard let sourceImageView = fromView.viewWithTag(sourceViewProvider.imageViewKey) as? UIImageView,
            let destinationImage = sourceImageView.image
            else {
                return UIViewPropertyAnimator(duration: 0, timingParameters: UICubicTimingParameters(animationCurve: .easeInOut))
        }

        //Find the initial frame for the zoom out animation
        let imageVewInitialFrame = sourceImageView.rectFromDisplayedImage()

        //Create an image view to do the zoom in animation
        let imageToAnimate = UIImageView(image: destinationImage)
        imageToAnimate.frame = imageVewInitialFrame
        imageToAnimate.clipsToBounds = true
        imageToAnimate.contentMode = .scaleAspectFill
        transitionContext.containerView.addSubview(imageToAnimate)
        sourceImageView.isHidden = true
        
        let animator = UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext),
            dampingRatio: 0.8) {
                fromView.alpha = 0
                toView.alpha = 1
                imageToAnimate.frame = destinationViewFrame
            }
        animator.addCompletion { _ in
            if transitionContext.transitionWasCancelled {
                fromView.alpha = 1
                toView.alpha = 0
                sourceImageView.isHidden = false
            } else {
                destinationView.isHidden = false
            }
            imageToAnimate.removeFromSuperview()
            transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
        }
        
        return animator
    }
}
