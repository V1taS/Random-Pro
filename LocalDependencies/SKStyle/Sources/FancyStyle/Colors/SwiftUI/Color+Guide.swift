//
//  Color+Guide.swift
//  FancyStyle
//
//  Created by Vitalii Sosin on 09.09.2023.
//

import SwiftUI

/// Расширение для `Color`
public extension Color {
  
  /// Список цветов `Fancy`
  static var fancy: ColorGuideSUI { colorGuide }
}

// MARK: - Public property

public var fancyColorSUI: ColorGuideSUI { colorGuide }

// MARK: - Private property

private let colorGuide = ColorGuideSUI(darkAndLightTheme: ColorGuideSUI.DarkAndLightTheme(),
                                       only: ColorGuideSUI.Only())
