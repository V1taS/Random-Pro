//
//  MainScreenCell.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

// MARK: - MainScreenModel

struct MainScreenModel: UserDefaultsCodable {
  
  /// Темная тема включена
  let isDarkMode: Bool?
  
  /// Все секции приложения
  let allSections: [Section]
  
  /// Секция
  struct Section: UserDefaultsCodable {
    
    /// Тип секции
    let type: SectionType
    
    /// Секция включена
    let isEnabled: Bool
    
    /// Название секции
    let titleSection: String
    
    /// Иконка секции
    let imageSection: Data
    
    /// Показать рекламный лайбл
    let isShowADVLabel: Bool
    
    /// Тип лайбла
    let advLabel: ADVLabel
  }
  
  // MARK: - MainScreenSection
  
  enum SectionType: CaseIterable, UserDefaultsCodable {
    
    // MARK: - Cases
    
    /// Общий список ячеек
    static var allCases: [SectionType] = [
      .teams,
      .number,
      .yesOrNo,
      .letter,
      .list,
      .coin,
      .cube,
      .dateAndTime,
      .lottery,
      .contact,
      .password,
      .colors
    ]
    
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
  }
  
  // MARK: - ADVLabel
  
  enum ADVLabel: String, CaseIterable, UserDefaultsCodable {
    
    /// Лайбл: `ХИТ`
    case hit = "Hit"
    
    /// Лайбл: `НОВОЕ`
    case new = "New"
    
    /// Лайбл: `ПРЕМИУМ`
    case premium = "Premium"
    
    /// Лайбл: `Пусто`
    case none = ""
  }
}

// MARK: - Create base model

extension MainScreenModel {
  static func createBaseModel() -> MainScreenModel {
    let appearance = Appearance()
    var allSections: [Section] = []
    
    MainScreenModel.SectionType.allCases.forEach { section in
      switch section {
      case .teams:
        allSections.append(Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardTeam,
          imageSection: appearance.imageCardTeam.pngData() ?? Data(),
          isShowADVLabel: false,
          advLabel: .none
        ))
      case .number:
        allSections.append(Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardNumber,
          imageSection: appearance.imageCardNumber.pngData() ?? Data(),
          isShowADVLabel: false,
          advLabel: .none
        ))
      case .yesOrNo:
        allSections.append(Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardYesOrNot,
          imageSection: appearance.imageCardYesOrNot.pngData() ?? Data(),
          isShowADVLabel: false,
          advLabel: .none
        ))
      case .letter:
        allSections.append(Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardCharacters,
          imageSection: appearance.imageCardCharacters.pngData() ?? Data(),
          isShowADVLabel: false,
          advLabel: .none
        ))
      case .list:
        allSections.append(Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardList,
          imageSection: appearance.imageCardList.pngData() ?? Data(),
          isShowADVLabel: false,
          advLabel: .none
        ))
      case .coin:
        allSections.append(Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardCoin,
          imageSection: appearance.imageCardCoin.pngData() ?? Data(),
          isShowADVLabel: false,
          advLabel: .none
        ))
      case .cube:
        allSections.append(Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardCube,
          imageSection: appearance.imageCardCube.pngData() ?? Data(),
          isShowADVLabel: false,
          advLabel: .none
        ))
      case .dateAndTime:
        allSections.append(Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardDateAndTime,
          imageSection: appearance.imageCardDateAndTime.pngData() ?? Data(),
          isShowADVLabel: false,
          advLabel: .none
        ))
      case .lottery:
        allSections.append(Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardLottery,
          imageSection: appearance.imageCardLottery.pngData() ?? Data(),
          isShowADVLabel: false,
          advLabel: .none
        ))
      case .contact:
        allSections.append(Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardContact,
          imageSection: appearance.imageCardContact.pngData() ?? Data(),
          isShowADVLabel: false,
          advLabel: .none
        ))
      case .password:
        allSections.append(Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardPassword,
          imageSection: appearance.imageCardPassword.pngData() ?? Data(),
          isShowADVLabel: false,
          advLabel: .none
        ))
      case .colors:
        allSections.append(Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleColors,
          imageSection: appearance.imageColors.pngData() ?? Data(),
          isShowADVLabel: false,
          advLabel: .none
        ))
      }
    }
    return MainScreenModel(isDarkMode: nil,
                           allSections: allSections)
  }
}

// MARK: - Appearance

private extension MainScreenModel {
  struct Appearance {
    let imageCardFilms = UIImage(systemName: "film") ?? UIImage()
    let titleCardFilms = NSLocalizedString("Фильмы", comment: "")
    
    let imageCardTeam = UIImage(systemName: "person.circle") ?? UIImage()
    let titleCardTeam = NSLocalizedString("Команды", comment: "")
    
    let imageCardNumber = UIImage(systemName: "number") ?? UIImage()
    let titleCardNumber = NSLocalizedString("Число", comment: "")
    
    let imageCardYesOrNot = UIImage(systemName: "questionmark.square") ?? UIImage()
    let titleCardYesOrNot = NSLocalizedString("Да или Нет", comment: "")
    
    let imageCardCharacters = UIImage(systemName: "textbox") ?? UIImage()
    let titleCardCharacters = NSLocalizedString("Буква", comment: "")
    
    let imageCardList = UIImage(systemName: "list.bullet.below.rectangle") ?? UIImage()
    let titleCardList = NSLocalizedString("Список", comment: "")
    
    let imageCardCoin = UIImage(systemName: "bitcoinsign.circle") ?? UIImage()
    let titleCardCoin = NSLocalizedString("Монета", comment: "")
    
    let imageCardCube = UIImage(systemName: "cube") ?? UIImage()
    let titleCardCube = NSLocalizedString("Кубики", comment: "")
    
    let imageCardDateAndTime = UIImage(systemName: "calendar") ?? UIImage()
    let titleCardDateAndTime = NSLocalizedString("Дата и время", comment: "")
    
    let imageCardLottery = UIImage(systemName: "tag") ?? UIImage()
    let titleCardLottery = NSLocalizedString("Лотерея", comment: "")
    
    let imageCardContact = UIImage(systemName: "phone.circle") ?? UIImage()
    let titleCardContact = NSLocalizedString("Контакт", comment: "")
    
    let imageCardPassword = UIImage(systemName: "wand.and.stars") ?? UIImage()
    let titleCardPassword = NSLocalizedString("Пароли", comment: "")
    
    let imageColors = UIImage(systemName: "photo.on.rectangle.angled") ?? UIImage()
    let titleColors = NSLocalizedString("Цвета", comment: "")
  }
}
