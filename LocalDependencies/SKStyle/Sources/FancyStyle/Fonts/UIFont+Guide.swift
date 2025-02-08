//
//  UIFont+Guide.swift
//
//  Created by Vitalii Sosin on 01.05.2022.
//

import UIKit

/// Расширение для `UIFont`
public extension UIFont {
  
  /// Список цветов `RandomFont`
  class var fancy: FontGuide { fontGuide }
}

// MARK: - Public property

public var fancyFont: FontGuide { fontGuide }

// MARK: - Private property

private let fontGuide = FontGuide()
