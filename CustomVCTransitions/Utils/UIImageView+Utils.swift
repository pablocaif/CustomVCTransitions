//
//  UIImageView+Utils.swift
//  CustomVCTransitions
//
//  Created by Pablo Caif on 23/2/19.
//  Copyright © 2019 Pablo Caif. All rights reserved.
//

import AVFoundation
import UIKit

extension UIImageView {
    func rectFromDisplayedImage() -> CGRect {
        guard let containedImage = image else { return CGRect.zero }
        let rect = AVMakeRect(aspectRatio: containedImage.size, insideRect: bounds)

        return rect.integral
    }
}
