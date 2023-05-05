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
    case .queensNecklace:
      return appearance.queensNecklaceImage
    case .marineFuchsia:
      return appearance.marineFuchsiaImage
    case .sandyDesert:
      return appearance.sandyDesertIcon
    case .redLime:
      return appearance.redLimeIcon
    case .heliotrope:
      return appearance.heliotropeIcon
    case .violetLemon:
      return appearance.violetLemonIcon
    case .avocado:
      return appearance.avocadoIcon
    case .frostySky:
      return appearance.frostySkyIcon
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
    case .queensNecklace:
      return appearance.queensNecklaceTitle
    case .marineFuchsia:
      return appearance.marineFuchsiaTitle
    case .sandyDesert:
      return appearance.sandyDesertTitle
    case .redLime:
      return appearance.redLimeTitle
    case .heliotrope:
      return appearance.heliotropeTitle
    case .violetLemon:
      return appearance.violetLemonTitle
    case .avocado:
      return appearance.avocadoTitle
    case .frostySky:
      return appearance.frostySkyTitle
    }
  }
  
  /// Стандартная иконка
  case defaultIcon
  
  /// Гелиотроп
  case heliotrope
  
  /// Литий
  case lithium
  
  /// Оранжевое удовольствие
  case orangeFun
  
  /// Полуночный Город
  case midnightCity
  
  /// Морская фуксия
  case marineFuchsia
  
  /// Терминал
  case terminal
  
  /// Морозное небо
  case frostySky
  
  /// Харви
  case harvey
  
  /// Красный город грехов
  case sinCityRed
  
  /// Фиолотово-лимонный
  case violetLemon
  
  /// Малиновый прилив
  case crimsonTide
  
  /// Залитый лунным светом астероид
  case moonlitAsteroid
  
  /// Серый
  case gradeGrey
  
  /// Летняя собака
  case summerDog
  
  /// Голубая малина
  case blueRaspberry
  
  /// Вечерняя ночь
  case eveningNight
  
  /// Красный лайм
  case redLime
  
  /// Песчаная пустыня
  case sandyDesert
  
  /// Чистая похоть
  case pureLust
  
  /// Авокадо
  case avocado
  
  /// Лунный фиолетовый
  case moonPurple
  
  /// Селен
  case selenium
  
  /// Ожерелье королевы
  case queensNecklace
}

// MARK: - Appearance

private extension SelecteAppIconType {
  struct Appearance {
    let mainIconTitle = RandomStrings.Localizable.main
    let mainIconImage = "selecte_app_icon_default"
    
    let crimsonTideTitle = RandomStrings.Localizable.raspberryTide
    let crimsonTideImage = "selecte_app_icon_crimson_tide"
    
    let lithiumTitle = RandomStrings.Localizable.lithium
    let lithiumImage =  "selecte_app_icon_lithium"
    
    let orangeFunTitle = RandomStrings.Localizable.orangePleasure
    let orangeFunImage = "selecte_app_icon_orange_fun"
    
    let midnightCityTitle = RandomStrings.Localizable.midnightCity
    let midnightCityImage = "selecte_app_icon_midnight_city"
    
    let terminalTitle = RandomStrings.Localizable.terminal
    let terminalImage = "selecte_app_icon_terminal"
    
    let harveyTitle = RandomStrings.Localizable.harvey
    let harveyImage = "selecte_app_icon_harvey"
    
    let moonlitAsteroidTitle = RandomStrings.Localizable.moonlitAsteroid
    let moonlitAsteroidImage = "selecte_app_icon_moonlit_asteroid"
    
    let gradeGreyTitle = RandomStrings.Localizable.gray
    let gradeGreyImage = "selecte_app_icon_grade_grey"
    
    let summerDogTitle = RandomStrings.Localizable.summer
    let summerDogImage = "selecte_app_icon_summer_dog"
    
    let sinCityRedTitle = RandomStrings.Localizable.redCity
    let sinCityRedImage = "selecte_app_icon_sin_city_red"
    
    let blueRaspberryTitle = RandomStrings.Localizable.blueLagoon
    let blueRaspberryImage = "selecte_app_icon_blue_raspberry"
    
    let eveningNightTitle = RandomStrings.Localizable.eveningNight
    let eveningNightImage = "selecte_app_icon_evening_night"
    
    let pureLustTitle = RandomStrings.Localizable.hotChocolate
    let pureLustImage = "selecte_app_icon_pure_lust"
    
    let moonPurpleTitle = RandomStrings.Localizable.moonlitViolet
    let moonPurpleImage = "selecte_app_icon_moon_purple"
    
    let seleniumTitle = RandomStrings.Localizable.selen
    let seleniumImage = "selecte_app_icon_selenium"
    
    let queensNecklaceTitle = RandomStrings.Localizable.queenNecklace
    let queensNecklaceImage = "selecte_app_icon_queen_necklace"
    
    let marineFuchsiaTitle = RandomStrings.Localizable.seaFuchsia
    let marineFuchsiaImage = "selecte_app_icon_marine_fuchsia"
    
    let sandyDesertTitle = RandomStrings.Localizable.sandyDesert
    let sandyDesertIcon = "selecte_app_icon_sandy_desert"
    
    let redLimeTitle = RandomStrings.Localizable.redLime
    let redLimeIcon = "selecte_app_icon_red_lime"
    
    let heliotropeTitle = RandomStrings.Localizable.heliotrope
    let heliotropeIcon = "selecte_app_icon_heliotrope"
    
    let violetLemonTitle = RandomStrings.Localizable.violetLemon
    let violetLemonIcon = "selecte_app_icon_violet_lemon"
    
    let avocadoTitle = RandomStrings.Localizable.avocado
    let avocadoIcon = "selecte_app_icon_avocado"
    
    let frostySkyTitle = RandomStrings.Localizable.frostySky
    let frostySkyIcon = "selecte_app_icon_frosty_sky"
  }
}
