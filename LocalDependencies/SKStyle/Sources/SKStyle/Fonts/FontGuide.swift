//
//  Font+Guide.swift
//
//
//  Created by Vitalii Sosin on 25.11.2023.
//

import SwiftUI

/// Гайд по шрифтам в приложении
public struct FontGuide {
  
  /// Шрифты для текста
  public let text: Text
  
  /// Константные размеры
  public let constant: Constant

  /// Шрифты для текста
  public struct Text {
    /// Medium 32
    public let largeTitle = Font.get(font: .h1)
    /// Medium 22
    public let title = Font.get(font: .h3)
    /// Medium 17
    public let regularMedium = Font.get(font: .b1Medium)
    /// Regular 17
    public let regular = Font.get(font: .b1)
    /// Regular 15
    public let small = Font.get(font: .b2)
  }
  
  /// Константные шрифты
  public struct Constant {
    // MARK: - Medium
    
    /// Medium 32
    public let h1 = Font.get(font: .h1)
    
    /// Medium 22
    public let h2 = Font.get(font: .h2)
    
    /// Medium 19
    public let h3 = Font.get(font: .h3)
    
    /// Medium 17
    public let b1Medium = Font.get(font: .b1Medium)
    
    /// Medium 15
    public let b2Medium = Font.get(font: .b2Medium)
    
    /// Medium 13
    public let b3Medium = Font.get(font: .b3Medium)
    
    // MARK: - Regular
    
    /// Regular 36
    public let largeTitle = Font.get(font: .largeTitle)
    
    /// Regular 17
    public let b1 = Font.get(font: .b1)
    
    /// Regular 15
    public let b2 = Font.get(font: .b2)
    
    /// Regular 13
    public let b3 = Font.get(font: .b3)
  }
}
