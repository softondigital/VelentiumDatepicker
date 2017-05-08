//
//  UIColor+Tools.swift
//  VelentiumDatepicker
//
//  Created by Hugo Aguero on 4/27/17.
//  Copyright © 2017 Velentium. All rights reserved.
//

import UIKit

extension UIColor {
    static func getRGBColor (red: CGFloat , green: CGFloat , blue: CGFloat)-> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
}
