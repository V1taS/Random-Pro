//
//  UIColor+Guide.swift
//
//
//  Created by Vitalii Sosin on 01.05.2022.
//

import UIKit

/// Расширение для `UIColor`
public extension UIColor {
  
  /// Список цветов `Fancy`
  class var fancy: ColorGuide { colorGuide }
}

/// Расширение для `CGColor`
public extension CGColor {
  
  /// Список цветов `Fancy`
  class var fancy: ColorGuide { colorGuide }
}

// MARK: - Public property

public var fancyColor: ColorGuide { colorGuide }

// MARK: - Private property

private let colorGuide = ColorGuide(darkAndLightTheme: ColorGuide.DarkAndLightTheme(),
                                    only: ColorGuide.Only())
