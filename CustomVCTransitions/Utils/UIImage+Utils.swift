//
//  UIImage+Utils.swift
//  CustomVCTransitions
//
//  Created by Pablo Caif on 17/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(toSize targetSize: CGSize) -> UIImage {
        
        var scale: CGFloat = size.width / targetSize.width
        if size.height * scale < targetSize.height {
            scale = size.height / targetSize.height
        }
        let croppedImsize = CGSize(width: size.width/scale, height: size.height/scale)
        return UIGraphicsImageRenderer(size: croppedImsize)
            .image { [weak self ] _ in
                self?.draw(in:  CGRect(origin: .zero, size: croppedImsize))
        }
    }
}
