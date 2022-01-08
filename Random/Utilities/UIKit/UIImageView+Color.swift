//
//  UIImageView+Color.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 08.01.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
