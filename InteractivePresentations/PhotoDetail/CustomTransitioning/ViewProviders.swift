//
//  ViewProviders.swift
//  InteractivePresentations
//
//  Created by Pablo Caif on 24/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import UIKit

protocol CollectionViewProvider where Self: UIViewController {
    var collectionViewKey: Int { get }
}

protocol ImageViewProvider where Self: UIViewController {
    var imageViewKey: Int { get }
}
