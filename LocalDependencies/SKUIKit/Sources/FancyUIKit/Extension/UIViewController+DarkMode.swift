//
//  UIViewController+DarkMode.swift
//  
//
//  Created by Vitalii Sosin on 16.09.2022.
//

import UIKit

public extension UIViewController {
  
  /// Включена темная тема
  var isDarkMode: Bool {
    if #available(iOS 13.0, *) {
      return self.traitCollection.userInterfaceStyle == .dark
    }
    else {
      return false
    }
  }
}
