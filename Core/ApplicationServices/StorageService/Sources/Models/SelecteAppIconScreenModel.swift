//
//  SelecteAppIconScreenModel.swift
//  StorageService
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

struct SelecteAppIconScreenModel: Codable, SelecteAppIconScreenModelProtocol {
  
  /// Выбранная иконка
  let selecteAppIconType: SelecteAppIconScreenTypeProtocol
  
  // MARK: - Initialization
  
  init(selecteAppIconType: SelecteAppIconType) {
    self.selecteAppIconType = selecteAppIconType
  }
  
  // MARK: - Initialization `Decode`
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    selecteAppIconType = try container.decode(SelecteAppIconType.self, forKey: .selecteAppIconType)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(selecteAppIconType as? SelecteAppIconType, forKey: .selecteAppIconType)
  }
  
  // MARK: - CodingKeys
  
  enum CodingKeys: CodingKey {
    case selecteAppIconType
  }
  
  // MARK: - SelecteAppIconType
  
  /// Тип выбранной секции
  enum SelecteAppIconType: Codable, SelecteAppIconScreenTypeProtocol {
    
    /// Иконка цвета
    var imageName: String { "" }
    
    /// Название цвета
    var title: String { "" }
    
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
}

// MARK: - toCodable

extension SelecteAppIconScreenModelProtocol {
  func toCodable() -> SelecteAppIconScreenModel? {
    guard let selecteAppIconType = selecteAppIconType as? SelecteAppIconScreenModel.SelecteAppIconType else {
      return nil
    }
    return SelecteAppIconScreenModel(selecteAppIconType: selecteAppIconType)
  }
}
