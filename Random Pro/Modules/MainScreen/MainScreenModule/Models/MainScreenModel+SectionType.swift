//
//  MainScreenModel+SectionType.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 25.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

extension MainScreenModel {
  
  // MARK: - MainScreenSection
  
  enum SectionType: CaseIterable, UserDefaultsCodable {
    
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
      case .raffle:
        return appearance.titleRaffle
      }
    }
    
    /// Иконка секции
    var imageSection: Data {
      let appearance = Appearance()
      switch self {
      case .teams:
        return appearance.imageCardTeam?.pngData() ?? Data()
      case .number:
        return appearance.imageCardNumber?.pngData() ?? Data()
      case .yesOrNo:
        return appearance.imageCardYesOrNot?.pngData() ?? Data()
      case .letter:
        return appearance.imageCardCharacters?.pngData() ?? Data()
      case .list:
        return appearance.imageCardList?.pngData() ?? Data()
      case .coin:
        return appearance.imageCardCoin?.pngData() ?? Data()
      case .cube:
        return appearance.imageCardCube?.pngData() ?? Data()
      case .dateAndTime:
        return appearance.imageCardDateAndTime?.pngData() ?? Data()
      case .lottery:
        return appearance.imageCardLottery?.pngData() ?? Data()
      case .contact:
        return appearance.imageCardContact?.pngData() ?? Data()
      case .password:
        return appearance.imageCardPassword?.pngData() ?? Data()
      case .colors:
        return appearance.imageColors?.pngData() ?? Data()
      case .bottle:
        return appearance.bottleCardImage?.pngData() ?? Data()
      case .rockPaperScissors:
        return appearance.imageRockPaperScissorsScreenView?.pngData() ?? Data()
      case .imageFilters:
        return appearance.imageImageFilters?.pngData() ?? Data()
      case .raffle:
        return appearance.imageRaffle?.pngData() ?? Data()
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
      case .raffle:
        return appearance.raffleFiltersDescriptionForNoPremiumAccess
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
    
    /// Раздел `Розыгрыш`
    case raffle
  }
}
