//
//  Font+DynamicProvider.swift
//
//
//  Created by Vitalii Sosin on 25.11.2023.
//

import SwiftUI

extension Font {
  static func get(font: FontToken) -> Font {
    switch font {
      // MARK: - Medium
      
      /// Medium 32
    case .h1:
      return Font.system(size: 32, weight: .medium)
      
      /// Medium 22
    case .h2:
      return Font.system(size: 22, weight: .medium)
      
      /// Medium 19
    case .h3:
      return Font.system(size: 19, weight: .medium)
      
      /// Medium 17
    case .b1Medium:
      return Font.system(size: 17, weight: .medium)
      
      /// Medium 15
    case .b2Medium:
      return Font.system(size: 15, weight: .medium)
      
      /// Medium 13
    case .b3Medium:
      return Font.system(size: 13, weight: .medium)
      
      /// Medium 11
    case .b4Medium:
      return Font.system(size: 11, weight: .medium)
      
      /// Medium 9
    case .b5Medium:
      return Font.system(size: 9, weight: .medium)
      
      // MARK: - Regular
      
      /// Regular 36
    case .largeTitle:
      return Font.system(size: 36, weight: .regular)
      
      /// Regular 17
    case .b1:
      return Font.system(size: 17, weight: .regular)
      
      /// Regular 15
    case .b2:
      return Font.system(size: 15, weight: .regular)
      
      /// Regular 13
    case .b3:
      return Font.system(size: 13, weight: .regular)
      
      /// Regular 11
    case .b4:
      return Font.system(size: 11, weight: .regular)
      
      /// Regular 9
    case .b5:
      return Font.system(size: 9, weight: .regular)
    }
  }
}
