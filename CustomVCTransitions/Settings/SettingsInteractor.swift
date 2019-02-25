//
//  SettingsInteractor.swift
//  CustomVCTransitions
//
//  Created by Pablo Caif on 17/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

struct SettingsInteractor {
    
    func loadSettings() -> [String] {
        var settings = [String]()
        for setting in 1...50 {
            settings.append("Setting \(setting)")
        }
        
        return settings
    }
}
