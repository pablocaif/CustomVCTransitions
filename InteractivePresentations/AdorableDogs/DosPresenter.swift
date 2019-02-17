//
//  DosPresenter.swift
//  InteractivePresentations
//
//  Created by Pablo Caif on 17/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import Foundation

struct DogsPresenter {
    private let interactor: DogsInteractor
    
    init(interactor: DogsInteractor) {
        self.interactor = interactor
    }
    
    func loadDogs(completionHandler: @escaping ([Dog]) -> Void) {
        interactor.loadDogs(completionQueue: .main) { result in
            switch result {
            case .success(let dogs):
                completionHandler(dogs)
            case .failure(let error):
                debugPrint("Error loading dogs = \(error)")
                completionHandler([Dog] ())
            }
        }
    }
}
