//
//  CustomMainScreenSectionModel.swift
//  CustomMainSectionsModule
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - MainScreenSectionModel

struct CustomMainScreenSectionModel: Codable, MainScreenSectionProtocol, Equatable {
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
  
  // MARK: - MainScreenSectionModel
  
  enum MainScreenSectionType: CaseIterable, Equatable, Codable, MainScreenSectionTypeProtocol {
    
    /// Название секции
    var titleSection: String {
      let appearance = Appearance()
      switch self {
      case .teams:
        return appearance.titleCardTeam
      case .number:
        return appearance.titleCardNumber
      case .yesOrNo:
        return appearance.titleCardYesOrNot
      case .letter:
        return appearance.titleCardCharacters
      case .list:
        return appearance.titleCardList
      case .coin:
        return appearance.titleCardCoin
      case .cube:
        return appearance.titleCardCube
      case .dateAndTime:
        return appearance.titleCardDateAndTime
      case .lottery:
        return appearance.titleCardLottery
      case .contact:
        return appearance.titleCardContact
      case .password:
        return appearance.titleCardPassword
      case .colors:
        return appearance.titleColors
      case .bottle:
        return appearance.titleBottle
      case .rockPaperScissors:
        return appearance.titleRockPaperScissors
      case .imageFilters:
        return appearance.titleImageFilters
      case .films:
        return appearance.titleFilms
      }
    }
    
    /// Иконка секции
    var imageSectionSystemName: String {
      let appearance = Appearance()
      switch self {
      case .teams:
        return appearance.imageCardTeam
      case .number:
        return appearance.imageCardNumber
      case .yesOrNo:
        return appearance.imageCardYesOrNot
      case .letter:
        return appearance.imageCardCharacters
      case .list:
        return appearance.imageCardList
      case .coin:
        return appearance.imageCardCoin
      case .cube:
        return appearance.imageCardCube
      case .dateAndTime:
        return appearance.imageCardDateAndTime
      case .lottery:
        return appearance.imageCardLottery
      case .contact:
        return appearance.imageCardContact
      case .password:
        return appearance.imageCardPassword
      case .colors:
        return appearance.imageColors
      case .bottle:
        return appearance.bottleCardImage
      case .rockPaperScissors:
        return appearance.imageRockPaperScissorsScreenView
      case .imageFilters:
        return appearance.imageImageFilters
      case .films:
        return appearance.imageFilms
      }
    }
    
    /// Описание когда нет премиум доступа
    var descriptionForNoPremiumAccess: String {
      let appearance = Appearance()
      switch self {
      case .teams:
        return appearance.teamsDescriptionForNoPremiumAccess
      case .number:
        return appearance.numberDescriptionForNoPremiumAccess
      case .yesOrNo:
        return appearance.yesOrNoDescriptionForNoPremiumAccess
      case .letter:
        return appearance.letterDescriptionForNoPremiumAccess
      case .list:
        return appearance.listDescriptionForNoPremiumAccess
      case .coin:
        return appearance.coinDescriptionForNoPremiumAccess
      case .cube:
        return appearance.cubeDescriptionForNoPremiumAccess
      case .dateAndTime:
        return appearance.dateAndTimeDescriptionForNoPremiumAccess
      case .lottery:
        return appearance.lotteryDescriptionForNoPremiumAccess
      case .contact:
        return appearance.contactDescriptionForNoPremiumAccess
      case .password:
        return appearance.passwordDescriptionForNoPremiumAccess
      case .colors:
        return appearance.colorsDescriptionForNoPremiumAccess
      case .bottle:
        return appearance.bottleDescriptionForNoPremiumAccess
      case .rockPaperScissors:
        return appearance.rockPaperScissorsDescriptionForNoPremiumAccess
      case .imageFilters:
        return appearance.imageFiltersDescriptionForNoPremiumAccess
      case .films:
        return appearance.filmsDescriptionForNoPremiumAccess
      }
    }
    
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
  
  // MARK: - MainScreenADVLabelModel
  
  enum MainScreenADVLabelModel: String, Equatable, CaseIterable, Codable, MainScreenADVLabelProtocol {
    
    /// Название секции
    var title: String {
      let appearance = Appearance()
      switch self {
      case .hit:
        return appearance.hit
      case .new:
        return appearance.new
      case .premium:
        return appearance.premium
      case .none:
        return ""
      }
    }
    
    /// Лайбл: `ХИТ`
    case hit
    
    /// Лайбл: `НОВОЕ`
    case new
    
    /// Лайбл: `ПРЕМИУМ`
    case premium
    
    /// Лайбл: `Пусто`
    case none
  }
  
  static func == (lhs: CustomMainScreenSectionModel, rhs: CustomMainScreenSectionModel) -> Bool {
    return lhs.type as? MainScreenSectionType == rhs.type as? MainScreenSectionType &&
    lhs.imageSectionSystemName == rhs.imageSectionSystemName &&
    lhs.titleSection == rhs.titleSection &&
    lhs.isEnabled == rhs.isEnabled &&
    lhs.isHidden == rhs.isHidden &&
    lhs.advLabel as? MainScreenADVLabelModel == rhs.advLabel as? MainScreenADVLabelModel
  }
}

// MARK: - toCodable

extension [MainScreenSectionProtocol] {
  func toCodable() -> [CustomMainScreenSectionModel] {
    guard let sections = self as? [CustomMainScreenSectionModel] else {
      return []
    }
    return sections
  }
}

extension CustomMainScreenSectionModel {
  struct Appearance {
    let hit = NSLocalizedString("Хит", comment: "")
    let new = NSLocalizedString("Новое", comment: "")
    let premium = NSLocalizedString("Премиум", comment: "")
    
    let teamsDescriptionForNoPremiumAccess = NSLocalizedString("Можно генерировать рандомный список команд для игры",
                                                               comment: "")
    let numberDescriptionForNoPremiumAccess = NSLocalizedString("Можно генерировать рандомные числа",
                                                                comment: "")
    let yesOrNoDescriptionForNoPremiumAccess = NSLocalizedString("Можно генерировать рандомный ответ",
                                                                 comment: "")
    let letterDescriptionForNoPremiumAccess = NSLocalizedString("Можно генерировать рандомные буквы",
                                                                comment: "")
    let listDescriptionForNoPremiumAccess = NSLocalizedString("Можно генерировать рандомный список собственных задач",
                                                              comment: "")
    let coinDescriptionForNoPremiumAccess = NSLocalizedString("Можно подбрасывать монетку в любое время",
                                                              comment: "")
    let cubeDescriptionForNoPremiumAccess = NSLocalizedString("Можно подбрасывать кубики играя в настольную игру",
                                                              comment: "")
    let dateAndTimeDescriptionForNoPremiumAccess = NSLocalizedString("Можно генерировать рандомную дату и время",
                                                                     comment: "")
    let lotteryDescriptionForNoPremiumAccess = NSLocalizedString("Можно генерировать рандомный лот для участия в лотереи",
                                                                 comment: "")
    let contactDescriptionForNoPremiumAccess = NSLocalizedString("Можно генерировать рандомный контакт из списка",
                                                                 comment: "")
    let passwordDescriptionForNoPremiumAccess = NSLocalizedString("Можно генерировать рандомный пароль для регистрации",
                                                                  comment: "")
    let colorsDescriptionForNoPremiumAccess = NSLocalizedString("Можно генерировать рандомные цвета фона",
                                                                comment: "")
    let bottleDescriptionForNoPremiumAccess = NSLocalizedString("Можно крутить виртуальную бутылочку",
                                                                comment: "")
    let rockPaperScissorsDescriptionForNoPremiumAccess = NSLocalizedString("Можно играть в игру Камень, ножницы, бумага с другом",
                                                                           comment: "")
    let imageFiltersDescriptionForNoPremiumAccess = NSLocalizedString("Можно генерировать рандомный фильтр для фото",
                                                                      comment: "")
    let filmsDescriptionForNoPremiumAccess = NSLocalizedString("Можно генерировать рандомный фильм",
                                                               comment: "")
    
    let imageCardTeam = "person.circle"
    let titleCardTeam = NSLocalizedString("Команды", comment: "")
    
    let imageCardNumber = "number"
    let titleCardNumber = NSLocalizedString("Число", comment: "")
    
    let imageCardYesOrNot = "questionmark.square"
    let titleCardYesOrNot = NSLocalizedString("Да или Нет", comment: "")
    
    let imageCardCharacters = "textbox"
    let titleCardCharacters = NSLocalizedString("Буква", comment: "")
    
    let imageCardList = "list.bullet.below.rectangle"
    let titleCardList = NSLocalizedString("Список", comment: "")
    
    let imageCardCoin = "bitcoinsign.circle"
    let titleCardCoin = NSLocalizedString("Монета", comment: "")
    
    let imageCardCube = "cube"
    let titleCardCube = NSLocalizedString("Кубики", comment: "")
    
    let imageCardDateAndTime = "calendar"
    let titleCardDateAndTime = NSLocalizedString("Дата и время", comment: "")
    
    let imageCardLottery = "tag"
    let titleCardLottery = NSLocalizedString("Лотерея", comment: "")
    
    let imageCardContact = "phone.circle"
    let titleCardContact = NSLocalizedString("Контакт", comment: "")
    
    let imageCardPassword = "wand.and.stars"
    let titleCardPassword = NSLocalizedString("Пароли", comment: "")
    
    let imageColors = "photo.on.rectangle.angled"
    let titleColors = NSLocalizedString("Цвета", comment: "")
    
    let bottleCardImage = "arrow.triangle.2.circlepath"
    let titleBottle = NSLocalizedString("Бутылочка", comment: "")
    
    let imageRockPaperScissorsScreenView = "hurricane.circle"
    let titleRockPaperScissors = NSLocalizedString("Цу-е-фа", comment: "")
    
    let imageImageFilters = "timelapse"
    let titleImageFilters = NSLocalizedString("Фильтры", comment: "")
    
    let imageFilms = "film"
    let titleFilms = NSLocalizedString("Фильмы", comment: "")
  }
}
