//
//  SettingsViewController.swift
//  InteractivePresentations
//
//  Created by Pablo Caif on 17/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    lazy var presenter = SettingsPresenter(interactor: SettingsInteractor())
    private var settings = [String]()
    
    override func viewDidLoad() {
        loadSettings()
    }
    
    func loadSettings() {
        settings = presenter.loadSettings()
        tableView.reloadData()
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
