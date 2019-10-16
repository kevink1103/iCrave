//
//  UIColorExtension.swift
//  iCrave
//
//  Created by Kevin Kim on 17/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit

extension UIColor
{
    var isBright: Bool {
        if let colorSpace = self.cgColor.colorSpace {
            if colorSpace.model == .rgb {
                guard let components = cgColor.components, components.count > 2 else {return false}
                let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
                return (brightness > 0.5)
            }
            else {
                var white : CGFloat = 0.0
                self.getWhite(&white, alpha: nil)
                return white >= 0.5
            }
        }
        return false
    }
    
    func generateTextColor() -> UIColor {
        if self.isBright {
            return .black
        }
        return .white
    }
}
