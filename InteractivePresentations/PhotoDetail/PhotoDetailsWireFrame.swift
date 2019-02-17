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

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
    }

    func showPhotoDetails(photoURL: URL) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoDetailViewController") as? PhotoDetailViewController else { return }

        viewController.photoURL = photoURL
        navigationController.pushViewController(viewController, animated: true)
    }
}
