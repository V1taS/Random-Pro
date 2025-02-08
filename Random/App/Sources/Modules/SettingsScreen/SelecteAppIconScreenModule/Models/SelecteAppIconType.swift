//
//  SelecteAppIconType.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import SKAbstractions

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
    let mainIconImage = RandomAsset.selecteAppIconDefault.name
    
    let crimsonTideTitle = RandomStrings.Localizable.raspberryTide
    let crimsonTideImage = RandomAsset.selecteAppIconCrimsonTide.name
    
    let lithiumTitle = RandomStrings.Localizable.lithium
    let lithiumImage =  RandomAsset.selecteAppIconLithium.name
    
    let orangeFunTitle = RandomStrings.Localizable.orangePleasure
    let orangeFunImage = RandomAsset.selecteAppIconOrangeFun.name
    
    let midnightCityTitle = RandomStrings.Localizable.midnightCity
    let midnightCityImage = RandomAsset.selecteAppIconMidnightCity.name
    
    let terminalTitle = RandomStrings.Localizable.terminal
    let terminalImage = RandomAsset.selecteAppIconTerminal.name
    
    let harveyTitle = RandomStrings.Localizable.harvey
    let harveyImage = RandomAsset.selecteAppIconHarvey.name
    
    let moonlitAsteroidTitle = RandomStrings.Localizable.moonlitAsteroid
    let moonlitAsteroidImage = RandomAsset.selecteAppIconMoonlitAsteroid.name
    
    let gradeGreyTitle = RandomStrings.Localizable.gray
    let gradeGreyImage = RandomAsset.selecteAppIconGradeGrey.name
    
    let summerDogTitle = RandomStrings.Localizable.summer
    let summerDogImage = RandomAsset.selecteAppIconSummerDog.name
    
    let sinCityRedTitle = RandomStrings.Localizable.redCity
    let sinCityRedImage = RandomAsset.selecteAppIconSinCityRed.name
    
    let blueRaspberryTitle = RandomStrings.Localizable.blueLagoon
    let blueRaspberryImage = RandomAsset.selecteAppIconBlueRaspberry.name
    
    let eveningNightTitle = RandomStrings.Localizable.eveningNight
    let eveningNightImage = RandomAsset.selecteAppIconEveningNight.name
    
    let pureLustTitle = RandomStrings.Localizable.hotChocolate
    let pureLustImage = RandomAsset.selecteAppIconPureLust.name
    
    let moonPurpleTitle = RandomStrings.Localizable.moonlitViolet
    let moonPurpleImage = RandomAsset.selecteAppIconMoonPurple.name
    
    let seleniumTitle = RandomStrings.Localizable.selen
    let seleniumImage = RandomAsset.selecteAppIconSelenium.name
    
    let queensNecklaceTitle = RandomStrings.Localizable.queenNecklace
    let queensNecklaceImage = RandomAsset.selecteAppIconQueenNecklace.name
    
    let marineFuchsiaTitle = RandomStrings.Localizable.seaFuchsia
    let marineFuchsiaImage = RandomAsset.selecteAppIconMarineFuchsia.name
    
    let sandyDesertTitle = RandomStrings.Localizable.sandyDesert
    let sandyDesertIcon = RandomAsset.selecteAppIconSandyDesert.name
    
    let redLimeTitle = RandomStrings.Localizable.redLime
    let redLimeIcon = RandomAsset.selecteAppIconRedLime.name
    
    let heliotropeTitle = RandomStrings.Localizable.heliotrope
    let heliotropeIcon = RandomAsset.selecteAppIconHeliotrope.name
    
    let violetLemonTitle = RandomStrings.Localizable.violetLemon
    let violetLemonIcon = RandomAsset.selecteAppIconVioletLemon.name
    
    let avocadoTitle = RandomStrings.Localizable.avocado
    let avocadoIcon = RandomAsset.selecteAppIconAvocado.name
    
    let frostySkyTitle = RandomStrings.Localizable.frostySky
    let frostySkyIcon = RandomAsset.selecteAppIconFrostySky.name
  }
}
