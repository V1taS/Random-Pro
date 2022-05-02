//
//  FPSStatusBarWindow.swift
//  Improving the application
//
//  Created by Vitalii Sosin on 26.06.2021.
//

import UIKit


class FPStatusBarWindow: UIWindow {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // don't hijack touches from the main window
        return false
    }
}
