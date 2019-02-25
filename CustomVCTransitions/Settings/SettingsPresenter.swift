//
//  SettingsPresenter.swift
//  CustomVCTransitions
//
//  Created by Pablo Caif on 17/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

struct SettingsPresenter {
    private let interactor: SettingsInteractor

    var settingsTitle: String {
        return "Settings"
    }

    init(interactor: SettingsInteractor) {
        self.interactor = interactor
    }
    
    func loadSettings() -> [String] {
        return interactor.loadSettings()
    }
}
