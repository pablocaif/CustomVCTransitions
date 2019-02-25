//
//  DogsInteractor.swift
//  CustomVCTransitions
//
//  Created by Pablo Caif on 16/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//
import Foundation

enum LoadDogsResult {
    case success(dogs: [Dog])
    case failure(error: String)
}

typealias LoadDogsCompletionHandler = (LoadDogsResult) -> Void

struct DogsInteractor {
    private let executionQueue = DispatchQueue(label: "CustomVCTransitions.DogsInteractor.processing.queue")
    
    func loadDogs(completionQueue: DispatchQueue, completionHandler: @escaping LoadDogsCompletionHandler) {
        executionQueue.async {
            let bundle = Bundle.main
            let paths = bundle.paths(forResourcesOfType: ".jpg", inDirectory: "Dogs")
            guard !paths.isEmpty else {
                completionQueue.async {
                    completionHandler(.failure(error: "Not found"))
                }
                return
            }
            
            var dogs = [Dog]()
            paths.enumerated().forEach{ (index, path) in
                let dog = Dog(id: index, pictureURL: URL(fileURLWithPath: path))
                dogs.append(dog)
            }
            
            completionQueue.async {
                completionHandler(.success(dogs: dogs))
            }
        }
    }
}
