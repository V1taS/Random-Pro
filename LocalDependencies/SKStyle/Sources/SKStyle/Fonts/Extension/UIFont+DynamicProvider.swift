//
//  UIFont+DynamicProvider.swift
//
//  Created by Vitalii Sosin on 01.05.2022.
//

import UIKit

extension UIFont {
  static func get(font: FontToken) -> UIFont {
    switch font {
      // MARK: - Medium
      
      /// Medium 32
    case .h1:
      return UIFont.systemFont(ofSize: 32, weight: .medium)
      
      /// Medium 22
    case .h2:
      return UIFont.systemFont(ofSize: 22, weight: .medium)
      
      /// Medium 19
    case .h3:
      return UIFont.systemFont(ofSize: 19, weight: .medium)
      
      /// Medium 17
    case .b1Medium:
      return UIFont.systemFont(ofSize: 17, weight: .medium)
      
      /// Medium 15
    case .b2Medium:
      return UIFont.systemFont(ofSize: 15, weight: .medium)
      
      /// Medium 13
    case .b3Medium:
      return UIFont.systemFont(ofSize: 13, weight: .medium)
      
      /// Medium 11
    case .b4Medium:
      return UIFont.systemFont(ofSize: 11, weight: .medium)
      
      /// Medium 9
    case .b5Medium:
      return UIFont.systemFont(ofSize: 9, weight: .medium)
      
      // MARK: - Regular
      
      /// Regular 36
    case .largeTitle:
      return UIFont.systemFont(ofSize: 36, weight: .regular)
      
      /// Regular 17
    case .b1:
      return UIFont.systemFont(ofSize: 17, weight: .regular)
      
      /// Regular 15
    case .b2:
      return UIFont.systemFont(ofSize: 15, weight: .regular)
      
      /// Regular 13
    case .b3:
      return UIFont.systemFont(ofSize: 13, weight: .regular)
      
      /// Regular 11
    case .b4:
      return UIFont.systemFont(ofSize: 11, weight: .regular)
      
      /// Regular 9
    case .b5:
      return UIFont.systemFont(ofSize: 9, weight: .regular)
    }
  }
}
