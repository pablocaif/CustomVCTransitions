//
//  PhotoDetailViewController.swift
//  InteractivePresentations
//
//  Created by Pablo Caif on 17/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    var photoURL: URL?
    static let photoImageViewTag = 1500
    @IBOutlet var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        navigationItem.title = "Photo Details"
        guard let url = photoURL else { return }
        photoImageView.tag = PhotoDetailViewController.photoImageViewTag
        photoImageView.image = UIImage(contentsOfFile: url.path)
    }
}

extension PhotoDetailViewController: ImageViewProvider {
    var imageViewKey: Int {
        return PhotoDetailViewController.photoImageViewTag
    }
}
