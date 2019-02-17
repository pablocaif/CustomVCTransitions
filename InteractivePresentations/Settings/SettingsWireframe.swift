//
//  SettingsWireframe.swift
//  InteractivePresentations
//
//  Created by Pablo Caif on 18/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import UIKit

class SettingsWireFrame: NSObject {

    private weak var presentingViewController: UIViewController?

    func showSettings(onViewController viewController: UIViewController) {
        guard let navViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsNavigationController") as? UINavigationController,
            let destinationViewController = navViewController.topViewController as? SettingsViewController
            else {
                return
        }

        destinationViewController.navigationDelegate = self
        viewController.present(navViewController, animated: true, completion: nil)
        self.presentingViewController = viewController
    }
}

extension SettingsWireFrame: SettingsNavigationDelegate {
    func dismiss() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
