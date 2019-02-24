//
//  PhotoDetailsWireFrame.swift
//  InteractivePresentations
//
//  Created by Pablo Caif on 18/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import UIKit

class PhotoDetailsWireFrame: NSObject {
    private let navigationController: UINavigationController
    //Interactive presentation
    private let swipeDownInteractiveTransition = SwipeDownInteractiveTransition()
    private var photoDetailViewController: PhotoDetailViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }

    func showPhotoDetails(photoURL: URL) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoDetailViewController") as? PhotoDetailViewController else { return }

        viewController.photoURL = photoURL
        self.photoDetailViewController = viewController
        navigationController.delegate = self
        swipeDownInteractiveTransition.configureInteractiveTransitionDelegate(delegate: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func dismiss() {
        navigationController.popViewController(animated: true)
        navigationController.delegate = nil
    }
}

extension PhotoDetailsWireFrame: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let zoomOutTransition = animationController as? PhotoZoomOutAnimatedTransition,
        swipeDownInteractiveTransition.interactionInProgress
            else { return nil }

        return swipeDownInteractiveTransition
    }

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return PhotoZoomInAnimatedTransition()
        case .pop:
            return PhotoZoomOutAnimatedTransition()
        default:
            return nil
        }
    }
}

extension PhotoDetailsWireFrame: SwipeDownInteractiveTransitionDelegate {
    func startDismissing() {
        navigationController.popViewController(animated: true)
    }

    func viewToAddDismissGesture() -> UIView? {
        return photoDetailViewController?.view
    }
}
