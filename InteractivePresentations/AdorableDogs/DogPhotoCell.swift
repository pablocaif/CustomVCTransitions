//
//  DogPhotoCellCollectionViewCell.swift
//  InteractivePresentations
//
//  Created by Pablo Caif on 17/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import UIKit

class DogPhotoCell: UICollectionViewCell {
    
    private let cellProcessingQueue = DispatchQueue(label: "InteractivePresentations.DogPhotoCell.queue", qos: DispatchQoS.userInteractive)
    
    @IBOutlet weak var photo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(withPhotoURL photoURL: URL) {
        guard photo.image == nil else { return }
        let viewFrame = frame
        cellProcessingQueue.async { [weak self] in
            guard let self = self ,let image = UIImage(contentsOfFile: photoURL.path) else { return }
            let resizedImage = image.resize(toSize: viewFrame.size)
            
            self.fadeInPhoto(image: resizedImage)
        }
    }
    
    private func fadeInPhoto(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.photo.alpha = 0
            self?.photo.image = image
            UIView.animate(withDuration: 0.3, animations: {
                self?.photo.alpha = 1
            })
        }
    }
    
    override func prepareForReuse() {
        photo.image = nil
    }
}
