//
//  Dog.swift
//  CustomVCTransitions
//
//  Created by Pablo Caif on 16/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import Foundation

struct Dog {
    let pictureURL: URL
    let id: Int
    
    init(id: Int, pictureURL: URL) {
        self.id = id
        self.pictureURL = pictureURL
    }
}
