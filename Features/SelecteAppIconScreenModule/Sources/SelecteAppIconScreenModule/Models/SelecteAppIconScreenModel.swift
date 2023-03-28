//
//  SelecteAppIconScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct SelecteAppIconScreenModel: Codable {
  
  /// Выбранная иконка
  let selecteAppIconType: SelecteAppIconType
}

// MARK: - SectionType

/// Тип выбранной секции
enum SelecteAppIconType: CaseIterable, Codable {
  
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
    
    let queensNecklaceTitle = NSLocalizedString("Ожерелье королевы", comment: "")
    let queensNecklaceImage = "selecte_app_icon_queen_necklace"
    
    let marineFuchsiaTitle = NSLocalizedString("Морская фуксия", comment: "")
    let marineFuchsiaImage = "selecte_app_icon_marine_fuchsia"
    
    let sandyDesertTitle = NSLocalizedString("Песчаная пустыня", comment: "")
    let sandyDesertIcon = "selecte_app_icon_sandy_desert"
    
    let redLimeTitle = NSLocalizedString("Красный лайм", comment: "")
    let redLimeIcon = "selecte_app_icon_red_lime"
    
    let heliotropeTitle = NSLocalizedString("Гелиотроп", comment: "")
    let heliotropeIcon = "selecte_app_icon_heliotrope"
    
    let violetLemonTitle = NSLocalizedString("Фиолотово-лимонный", comment: "")
    let violetLemonIcon = "selecte_app_icon_violet_lemon"
    
    let avocadoTitle = NSLocalizedString("Авокадо", comment: "")
    let avocadoIcon = "selecte_app_icon_avocado"
    
    let frostySkyTitle = NSLocalizedString("Морозное небо", comment: "")
    let frostySkyIcon = "selecte_app_icon_frosty_sky"
  }
}
