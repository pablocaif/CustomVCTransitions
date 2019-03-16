//
//  PhotoZoomInAnimatedTransition.swift
//  CustomVCTransitions
//
//  Created by Pablo Caif on 20/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import UIKit

class PhotoZoomInAnimatedTransition: ViewControllerTransitionAnimator {

    override func createAnimator(for transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        guard let sourceViewProvider = transitionContext.viewController(forKey: .from) as? CollectionViewProvider,
            let destinationProvier = transitionContext.viewController(forKey: .to) as? ImageViewProvider,
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
            else {
                return UIViewPropertyAnimator(duration: 0, timingParameters: UICubicTimingParameters(animationCurve: .easeInOut))
        }

        //Find the cell from where we need to originate the animation
        guard let collectionView = fromView.viewWithTag(sourceViewProvider.collectionViewKey) as? UICollectionView,
            let sourceView = sourceViewProvider.findSelectedCell()
            else {
                return UIViewPropertyAnimator(duration: 0, timingParameters: UICubicTimingParameters(animationCurve: .easeInOut))
        }

        //Prepare to and from view for the animations
        sourceView.isHidden = true
        transitionContext.containerView.addSubview(fromView)
        toView.alpha = 0.0
        transitionContext.containerView.addSubview(toView)

        //Calculate the initial frame for the zoom in
        var sourceViewFrame = sourceView.frame
        sourceViewFrame.origin = CGPoint(x: sourceViewFrame.origin.x - collectionView.contentOffset.x, y: sourceViewFrame.origin.y - collectionView.contentOffset.y)

        //Find the image view in the destination view controller and prepare for presentation
        guard let destinationImageView = toView.viewWithTag(destinationProvier.imageViewKey) as? UIImageView,
            let destinationImage = destinationImageView.image
            else {
                return UIViewPropertyAnimator(duration: 0, timingParameters: UICubicTimingParameters(animationCurve: .easeInOut))
        }
        destinationImageView.frame = toView.frame
        destinationImageView.isHidden = true

        //Get the final frame for the photo zoom in
        let destinationFrame = destinationImageView.rectFromDisplayedImage()

        //Create an image view to do the zoom in animation
        let imageToAnimate = UIImageView(image: destinationImage)
        imageToAnimate.frame = sourceViewFrame
        imageToAnimate.clipsToBounds = true
        imageToAnimate.contentMode = .scaleAspectFill
        transitionContext.containerView.addSubview(imageToAnimate)

        let animator = UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext),
            dampingRatio: 0.7) {
                fromView.alpha = 0.0
                toView.alpha = 1.0
                imageToAnimate.frame = destinationFrame
        }
        animator.addCompletion { _ in
            destinationImageView.isHidden = false
            imageToAnimate.removeFromSuperview()
            transitionContext.completeTransition(transitionContext.transitionWasCancelled == false)
        }
        
        return animator
    }
}
