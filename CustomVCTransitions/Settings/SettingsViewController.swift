//
//  SettingsViewController.swift
//  CustomVCTransitions
//
//  Created by Pablo Caif on 17/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import UIKit

protocol SettingsNavigationDelegate: class {
    func dismiss()
}

class SettingsViewController: UITableViewController {
    
    private var settings = [String]()
    lazy var presenter = SettingsPresenter(interactor: SettingsInteractor())
    weak var navigationDelegate: SettingsNavigationDelegate?

    var didScrollFarEnoughForDismissal: Bool {
        var scrollOffset = CGFloat(24.0)
        if let navBarFrame = navigationController?.navigationBar.frame {
            scrollOffset += navBarFrame.size.height + navBarFrame.origin.y
        }
        return tableView.contentOffset.y < -scrollOffset
    }
    
    override func viewDidLoad() {
        loadSettings()
        navigationItem.title = presenter.settingsTitle
    }

    func loadSettings() {
        settings = presenter.loadSettings()
        tableView.reloadData()
    }
    @IBAction func didTapDone(_ sender: Any) {
        navigationDelegate?.dismiss()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        guard settings.count > indexPath.row else { return cell }
        cell.textLabel?.text = settings[indexPath.row]
        
        return cell
    }

}
