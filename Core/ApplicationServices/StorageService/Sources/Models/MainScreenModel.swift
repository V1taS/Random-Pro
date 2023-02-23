//
//  MainScreenModel.swift
//  StorageService
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

// MARK: - MainScreenModelProtocol

struct MainScreenModel: Codable, MainScreenModelProtocol {
  var isDarkMode: Bool?
  var isPremium: Bool
  var allSections: [MainScreenSectionProtocol]
  
  // MARK: - Initialization
  
  init(isDarkMode: Bool?, isPremium: Bool, allSections: [MainScreenSectionModel]) {
    self.isDarkMode = isDarkMode
    self.isPremium = isPremium
    self.allSections = allSections
  }
  
  // MARK: - Initialization `Decode`
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    isDarkMode = try container.decode(Bool.self, forKey: .isDarkMode)
    isPremium = try container.decode(Bool.self, forKey: .isPremium)
    allSections = try container.decode([MainScreenSectionModel].self, forKey: .allSections)
  }
  
  // MARK: - Func `Encode`
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(isDarkMode, forKey: .isDarkMode)
    try container.encode(isPremium, forKey: .isPremium)
    let allSections = allSections.compactMap { $0 as? MainScreenSectionModel }
    try container.encode(allSections, forKey: .allSections)
  }
  
  // MARK: - CodingKeys
  
  enum CodingKeys: CodingKey {
    case isDarkMode
    case isPremium
    case allSections
  }
  
  // MARK: - MainScreenSectionModel
  
  struct MainScreenSectionModel: Codable, MainScreenSectionProtocol {
    var type: MainScreenSectionTypeProtocol
    var imageSectionSystemName: String
    var titleSection: String
    var isEnabled: Bool
    var isHidden: Bool
    var advLabel: MainScreenADVLabelProtocol
    
    // MARK: - Initialization
    
    init(type: MainScreenSectionType,
         imageSectionSystemName: String,
         titleSection: String,
         isEnabled: Bool,
         isHidden: Bool,
         advLabel: MainScreenADVLabelModel) {
      self.type = type
      self.imageSectionSystemName = imageSectionSystemName
      self.titleSection = titleSection
      self.isEnabled = isEnabled
      self.isHidden = isHidden
      self.advLabel = advLabel
    }
    
    // MARK: - Initialization `Decode`
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      type = try container.decode(MainScreenSectionType.self, forKey: .type)
      imageSectionSystemName = try container.decode(String.self, forKey: .imageSectionSystemName)
      titleSection = try container.decode(String.self, forKey: .titleSection)
      isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
      isHidden = try container.decode(Bool.self, forKey: .isHidden)
      advLabel = try container.decode(MainScreenADVLabelModel.self, forKey: .advLabel)
    }
    
    // MARK: - Func `Encode`
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(type as? MainScreenSectionType, forKey: .type)
      try container.encode(imageSectionSystemName, forKey: .imageSectionSystemName)
      try container.encode(titleSection, forKey: .titleSection)
      try container.encode(isEnabled, forKey: .isEnabled)
      try container.encode(isHidden, forKey: .isHidden)
      try container.encode(advLabel as? MainScreenADVLabelModel, forKey: .advLabel)
    }
    
    // MARK: - CodingKeys
    
    enum CodingKeys: CodingKey {
      case type
      case imageSectionSystemName
      case titleSection
      case isEnabled
      case isHidden
      case advLabel
    }
  }
  
  // MARK: - MainScreenADVLabelModel
  
  enum MainScreenADVLabelModel: Codable, MainScreenADVLabelProtocol {
    
    /// Название секции
    var title: String { "" }
    
    /// Лайбл: `ХИТ`
    case hit
    
    /// Лайбл: `НОВОЕ`
    case new
    
    /// Лайбл: `ПРЕМИУМ`
    case premium
    
    /// Лайбл: `Пусто`
    case none
  }
  
  // MARK: - MainScreenSectionModel
  
  enum MainScreenSectionType: Codable, MainScreenSectionTypeProtocol {
    
    /// Название секции
    var titleSection: String { "" }
    
    /// Иконка секции
    var imageSectionSystemName: String { "" }
    
    /// Описание когда нет премиум доступа
    var descriptionForNoPremiumAccess: String { "" }
    
    // MARK: - Cases
    
    /// Раздел: `Команды`
    case teams
    
    /// Раздел: `Число`
    case number
    
    /// Раздел: `Да или Нет`
    case yesOrNo
    
    /// Раздел: `Буква`
    case letter
    
    /// Раздел: `Список`
    case list
    
    /// Раздел: `Монета`
    case coin
    
    /// Раздел: `Кубики`
    case cube
    
    /// Раздел: `Дата и Время`
    case dateAndTime
    
    /// Раздел: `Лотерея`
    case lottery
    
    /// Раздел: `Контакты`
    case contact
    
    /// Раздел: `Пароли`
    case password
    
    /// Раздел: `Цвета`
    case colors
    
    /// Раздел: `Бутылочка`
    case bottle
    
    /// Раздел `Камень, ножницы, бумага`
    case rockPaperScissors
    
    /// Раздел `Фильтры изображений`
    case imageFilters
    
    /// Раздел `Фильмы`
    case films
  }
}


// MARK: - toCodable

extension MainScreenModelProtocol {
  func toCodable() -> MainScreenModel? {
    let newAllSections: [MainScreenModel.MainScreenSectionModel] = allSections.map { section in
      MainScreenModel.MainScreenSectionModel(type: (section.type as? MainScreenModel.MainScreenSectionType) ?? .bottle,
                                             imageSectionSystemName: section.imageSectionSystemName,
                                             titleSection: section.titleSection,
                                             isEnabled: section.isEnabled,
                                             isHidden: section.isHidden,
                                             advLabel: (section.advLabel as? MainScreenModel.MainScreenADVLabelModel) ?? .none)
    }
    return MainScreenModel(isDarkMode: isDarkMode,
                           isPremium: isPremium,
                           allSections: newAllSections)
  }
}
