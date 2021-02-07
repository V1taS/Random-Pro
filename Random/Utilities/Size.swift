//
//  Size.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import UIKit

class Size {
    static let shared = Size()
    
    func getAdaptSizeHeight(px num: CGFloat) -> CGFloat {
        let heightScreen: CGFloat = 812
        return num / heightScreen
    }

    func getAdaptSizeWidth(px num: CGFloat) -> CGFloat {
        let widthScreen: CGFloat = 375
        return num / widthScreen
    }
}
