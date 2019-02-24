//
//  SwipeDownInteractiveTransition.swift
//  InteractivePresentations
//
//  Created by Pablo Caif on 18/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import UIKit

///This protocol allows to communicate with the Coordinator
///of the view controller that will be interactively dismissed
protocol SwipeDownInteractiveTransitionDelegate: class {
    func startDismissing()
    func shouldBeginTransition() -> Bool
    func viewToAddDismissGesture() -> UIView?
}

extension SwipeDownInteractiveTransitionDelegate {
    ///Default implementation for optional method
    func shouldBeginTransition() -> Bool { return true }
}

///This class allows to start the dismissal of a ViewController by a vertical swipe gesture
///It's also able to progress or reverse the dismissal animation
class SwipeDownInteractiveTransition: UIPercentDrivenInteractiveTransition {
    public private(set) var interactionInProgress = false
    private var shouldCompleteTransition = false
    private weak var interactiveTransitionDelegate: SwipeDownInteractiveTransitionDelegate?
    private var gesture: UIPanGestureRecognizer?

    func configureInteractiveTransitionDelegate(delegate: SwipeDownInteractiveTransitionDelegate) {
        removeGestureRecogniser()
        self.interactiveTransitionDelegate = delegate
        guard let view = interactiveTransitionDelegate?.viewToAddDismissGesture() else { return }
        prepareGestureRecognizerIn(view: view)
    }

    deinit {
        removeGestureRecogniser()
    }

    private func removeGestureRecogniser() {
        guard let view = interactiveTransitionDelegate?.viewToAddDismissGesture(), let gesture = gesture else { return }

        view.removeGestureRecognizer(gesture)
    }

    private func prepareGestureRecognizerIn(view: UIView) {
        gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(gestureRecognizer:)))
        gesture!.delegate = self
        gesture!.minimumNumberOfTouches = 1
        view.addGestureRecognizer(gesture!)
    }

    @objc func handleGesture(gestureRecognizer: UIPanGestureRecognizer) {
        guard let interactiveTransitionDelegate = interactiveTransitionDelegate,
            let presentedView = interactiveTransitionDelegate.viewToAddDismissGesture() else { return }

        let translation = gestureRecognizer.translation(in: presentedView)
        var progress = (translation.y / (presentedView.frame.size.height * 0.75))
        progress = CGFloat(fmaxf(Float(progress), 0.0))

        switch gestureRecognizer.state {
        case .began where interactiveTransitionDelegate.shouldBeginTransition():
            interactionInProgress = true
            interactiveTransitionDelegate.startDismissing()
        case .changed where interactiveTransitionDelegate.shouldBeginTransition():
            if interactionInProgress == false {
                interactionInProgress = true
                interactiveTransitionDelegate.startDismissing()
            }
            shouldCompleteTransition = progress > 0.5 || gestureRecognizer.velocity(in: presentedView).y > 500
            update(progress)
        case .cancelled:
            interactionInProgress = false
            cancel()
        case .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }
}

extension SwipeDownInteractiveTransition: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
