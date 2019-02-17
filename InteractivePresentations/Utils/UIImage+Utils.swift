//
//  UIImage+Utils.swift
//  InteractivePresentations
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
        let croppedImrect =
            CGRect(origin: CGPoint(x: (targetSize.width - croppedImsize.width)/2.0,
                                   y: (targetSize.height - croppedImsize.height)/2.0),
                   size: croppedImsize)
        return UIGraphicsImageRenderer(size: croppedImsize).image { [weak self ]_ in
            self?.draw(in:  CGRect(origin: .zero, size: croppedImsize))
            //self?.draw(at: CGPoint(x:-croppedImrect.origin.x, y:-croppedImrect.origin.y))
        }
    }
}
