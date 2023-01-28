//
//  SelecteAppIconType.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

// MARK: - SectionType

/// Тип выбранной секции
enum SelecteAppIconType: UserDefaultsCodable, CaseIterable {
  
  /// Иконка цвета
  var imageName: String {
    let appearance = Appearance()
    switch self {
    case .defaultIcon:
      return appearance.mainIconImage
    case .crimsonTide:
      return appearance.crimsonTideImage
    case .lithium:
      return appearance.lithiumImage
    case .orangeFun:
      return appearance.orangeFunImage
    case .midnightCity:
      return appearance.midnightCityImage
    case .terminal:
      return appearance.terminalImage
    case .harvey:
      return appearance.harveyImage
    case .moonlitAsteroid:
      return appearance.moonlitAsteroidImage
    case .gradeGrey:
      return appearance.gradeGreyImage
    case .summerDog:
      return appearance.summerDogImage
    case .sinCityRed:
      return appearance.sinCityRedImage
    case .blueRaspberry:
      return appearance.blueRaspberryImage
    case .eveningNight:
      return appearance.eveningNightImage
    case .pureLust:
      return appearance.pureLustImage
    case .moonPurple:
      return appearance.moonPurpleImage
    case .selenium:
      return appearance.seleniumImage
    }
  }
  
  /// Название цвета
  var title: String {
    let appearance = Appearance()
    switch self {
    case .defaultIcon:
      return appearance.mainIconTitle
    case .crimsonTide:
      return appearance.crimsonTideTitle
    case .lithium:
      return appearance.lithiumTitle
    case .orangeFun:
      return appearance.orangeFunTitle
    case .midnightCity:
      return appearance.midnightCityTitle
    case .terminal:
      return appearance.terminalTitle
    case .harvey:
      return appearance.harveyTitle
    case .moonlitAsteroid:
      return appearance.moonlitAsteroidTitle
    case .gradeGrey:
      return appearance.gradeGreyTitle
    case .summerDog:
      return appearance.summerDogTitle
    case .sinCityRed:
      return appearance.sinCityRedTitle
    case .blueRaspberry:
      return appearance.blueRaspberryTitle
    case .eveningNight:
      return appearance.eveningNightTitle
    case .pureLust:
      return appearance.pureLustTitle
    case .moonPurple:
      return appearance.moonPurpleTitle
    case .selenium:
      return appearance.seleniumTitle
    }
  }
  
  /// Стандартная иконка
  case defaultIcon
  
  /// Малиновый прилив
  case crimsonTide
  
  /// Литий
  case lithium
  
  /// Оранжевое удовольствие
  case orangeFun
  
  /// Полуночный Город
  case midnightCity
  
  /// Терминал
  case terminal
  
  /// Харви
  case harvey
  
  /// Залитый лунным светом астероид
  case moonlitAsteroid
  
  /// Серый
  case gradeGrey
  
  /// Летняя собака
  case summerDog
  
  /// Красный город грехов
  case sinCityRed
  
  /// Голубая малина
  case blueRaspberry
  
  /// Вечерняя ночь
  case eveningNight
  
  /// Чистая похоть
  case pureLust
  
  /// Лунный фиолетовый
  case moonPurple
  
  /// Селен
  case selenium
}

// MARK: - Appearance

private extension SelecteAppIconType {
  struct Appearance {
    let mainIconTitle = NSLocalizedString("Основная", comment: "")
    let mainIconImage = "selecte_app_icon_default"
    
    let crimsonTideTitle = NSLocalizedString("Малиновый прилив", comment: "")
    let crimsonTideImage = "selecte_app_icon_crimson_tide"
    
    let lithiumTitle = NSLocalizedString("Литий", comment: "")
    let lithiumImage =  "selecte_app_icon_lithium"
    
    let orangeFunTitle = NSLocalizedString("Оранжевое удовольствие", comment: "")
    let orangeFunImage = "selecte_app_icon_orange_fun"
    
    let midnightCityTitle = NSLocalizedString("Полуночный Город", comment: "")
    let midnightCityImage = "selecte_app_icon_midnight_city"
    
    let terminalTitle = NSLocalizedString("Терминал", comment: "")
    let terminalImage = "selecte_app_icon_terminal"
    
    let harveyTitle = NSLocalizedString("Харви", comment: "")
    let harveyImage = "selecte_app_icon_harvey"
    
    let moonlitAsteroidTitle = NSLocalizedString("Залитый лунным светом астероид", comment: "")
    let moonlitAsteroidImage = "selecte_app_icon_moonlit_asteroid"
    
    let gradeGreyTitle = NSLocalizedString("Серый", comment: "")
    let gradeGreyImage = "selecte_app_icon_grade_grey"
    
    let summerDogTitle = NSLocalizedString("Летний", comment: "")
    let summerDogImage = "selecte_app_icon_summer_dog"
    
    let sinCityRedTitle = NSLocalizedString("Красный город", comment: "")
    let sinCityRedImage = "selecte_app_icon_sin_city_red"
    
    let blueRaspberryTitle = NSLocalizedString("Голубая лагуна", comment: "")
    let blueRaspberryImage = "selecte_app_icon_blue_raspberry"
    
    let eveningNightTitle = NSLocalizedString("Вечерняя ночь", comment: "")
    let eveningNightImage = "selecte_app_icon_evening_night"
    
    let pureLustTitle = NSLocalizedString("Горячий шоколад", comment: "")
    let pureLustImage = "selecte_app_icon_pure_lust"
    
    let moonPurpleTitle = NSLocalizedString("Лунный фиолетовый", comment: "")
    let moonPurpleImage = "selecte_app_icon_moon_purple"
    
    let seleniumTitle = NSLocalizedString("Селен", comment: "")
    let seleniumImage = "selecte_app_icon_selenium"
  }
}
