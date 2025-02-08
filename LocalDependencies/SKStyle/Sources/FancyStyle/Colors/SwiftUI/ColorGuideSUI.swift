//
//  ColorGuideSUI.swift
//  FancyStyle
//
//  Created by Vitalii Sosin on 09.09.2023.
//

import SwiftUI

/// Гайд по цветам в приложении, для светлой и темной темы
public struct ColorGuideSUI {
  
  /// Цвета для темной и светлой темы
  public let darkAndLightTheme: DarkAndLightTheme
  
  /// Только определенный цвет
  public let only: Only
  
  // MARK: - Only
  
  /// Только конкретный цвет
  public struct Only: ColorOnlyGuideProtocol {
    
    /// Темно-серый цвет
    public let primaryGray = Color(UIColor(hexString: ColorToken.primaryGray.hexString))
    
    /// Cерый цвет
    public let secondaryGray = Color(UIColor(hexString: ColorToken.secondaryGray.hexString))
    
    /// Светло-серый цвет
    public let lightGray = Color(UIColor(hexString: ColorToken.lightGray.hexString))
    
    /// Очень светло-серый цвет
    public let tertiaryGray = Color(UIColor(hexString: ColorToken.tertiaryGray.hexString))
    
    /// Темно-зеленый цвет
    public let primaryGreen = Color(UIColor(hexString: ColorToken.primaryGreen.hexString))
    
    /// Светло-зеленый цвет
    public let secondaryGreen = Color(UIColor(hexString: ColorToken.secondaryGreen.hexString))
    
    /// Очень светло-зеленый цвет
    public let tertiaryGreen = Color(UIColor(hexString: ColorToken.tertiaryGreen.hexString))
    
    /// Основной синий цвет
    public let primaryBlue = Color(UIColor(hexString: ColorToken.primaryBlue.hexString))
    
    /// Светло-синий цвет
    public let secondaryBlue = Color(UIColor(hexString: ColorToken.secondaryBlue.hexString))
    
    /// Светло-синий цвет
    public let tertiaryBlue = Color(UIColor(hexString: ColorToken.tertiaryBlue.hexString))
    
    /// Ярко-красный цвет
    public let primaryRed = Color(UIColor(hexString: ColorToken.primaryRed.hexString))
    
    /// Основной розовый цвет
    public let primaryPink = Color(UIColor(hexString: ColorToken.primaryPink.hexString))
    
    /// Основной оранжевый
    public let primaryOrange = Color(UIColor(hexString: ColorToken.primaryOrange.hexString))
    
    /// Основной Желтый
    public let primaryYellow = Color(UIColor(hexString: ColorToken.primaryYellow.hexString))
    
    /// Основной фиолетовый
    public let primaryPurple = Color(UIColor(hexString: ColorToken.primaryPurple.hexString))
    
    /// Светло-белый цвет
    public let primaryWhite = Color(UIColor(hexString: ColorToken.primaryWhite.hexString))
    
    /// Темно-белый цвет
    public let secondaryWhite = Color(UIColor(hexString: ColorToken.secondaryWhite.hexString))
    
    /// Основной черный цвет
    public let primaryBlack = Color(UIColor(hexString: ColorToken.primaryBlack.hexString))
    
    /// Темный цвет Apple
    public let darkApple = Color(UIColor(hexString: ColorToken.darkApple.hexString))
  }
  
  // MARK: - DarkAndLightTheme
  
  /// Темная и светлая тема
  public struct DarkAndLightTheme: ColorDarkAndLightGuideProtocol {
    
    /// Темно-серый цвет
    public let primaryGray = Color(UIColor(light: .primaryGray, dark: .primaryWhite))
    
    /// Светло-серый цвет
    public let secondaryGray = Color(UIColor(light: .secondaryGray, dark: .secondaryWhite))
    
    /// Очень светло-зеленый цвет
    public let tertiaryGreen = Color(UIColor(light: .tertiaryGreen, dark: .secondaryGreen))
    
    /// Светло-белый цвет
    public let primaryWhite = Color(UIColor(light: .primaryWhite, dark: .darkApple))
    
    /// Темно-белый цвет
    public let secondaryWhite = Color(UIColor(light: .secondaryWhite, dark: .primaryGray))
    
    /// Основной черный цвет
    public let primaryBlack = Color(UIColor(light: .primaryBlack, dark: .primaryWhite))
  }
}
