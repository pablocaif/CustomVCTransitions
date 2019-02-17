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
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        guard let url = photoURL else { return }
        photoImageView.image = UIImage(contentsOfFile: url.path)
    }
}
