//
//  MainScreenModel+SectionType.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 25.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import FancyUIKit
import FancyStyle

extension MainScreenModel {
  
  // MARK: - MainScreenSection
  
  enum SectionType: String, CaseIterable, UserDefaultsCodable, Hashable {
        
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
      case .nickName:
        return appearance.titleNickName
      case .names:
        return appearance.titleNames
      case .congratulations:
        return appearance.titleCongratulations
      case .goodDeeds:
        return appearance.titleGoodDeeds
      case .riddles:
        return appearance.titleRiddles
      case .joke:
        return appearance.titleJoke
      case .gifts:
        return appearance.titleGifts
      case .slogans:
        return appearance.titleSlogans
      case .quotes:
        return appearance.titleQuotes
      case .fortuneWheel:
        return appearance.titleFortuneWheel
      case .truthOrDare:
        if let languageType = LanguageType.getCurrentLanguageType() {
          switch languageType {
          case .ru:
            return appearance.titleTruthOrDareRu
          default:
            return appearance.titleTruthOrDareOther
          }
        }
        return appearance.titleTruthOrDareOther
      case .memes:
        return appearance.titleMemes
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
      case .nickName:
        return appearance.imageNickName
      case .names:
        return appearance.imageNames
      case .congratulations:
        return appearance.imageCongratulations
      case .goodDeeds:
        return appearance.imageGoodDeeds
      case .riddles:
        return appearance.imageRiddles
      case .joke:
        return appearance.imageJoke
      case .gifts:
        return appearance.imageGifts
      case .slogans:
        return appearance.imageSlogans
      case .quotes:
        return appearance.imageQuotes
      case .fortuneWheel:
        return appearance.imageFortuneWheel
      case .truthOrDare:
        return appearance.imageTruthOrDare
      case .memes:
        return appearance.imageMemes
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
      case .nickName:
        return appearance.nickNameDescriptionForNoPremiumAccess
      case .names:
        return appearance.namesDescriptionForNoPremiumAccess
      case .congratulations:
        return appearance.congratulationsDescriptionForNoPremiumAccess
      case .goodDeeds:
        return appearance.goodDeedsDescriptionForNoPremiumAccess
      case .riddles:
        return appearance.riddlesDescriptionForNoPremiumAccess
      case .joke:
        return appearance.jokeDescriptionForNoPremiumAccess
      case .gifts:
        return appearance.giftsDescriptionForNoPremiumAccess
      case .slogans:
        return appearance.slogansDescriptionForNoPremiumAccess
      case .truthOrDare:
        return appearance.truthOrDareDescriptionForNoPremiumAccess
      case .quotes:
        return appearance.quotesDescriptionForNoPremiumAccess
      case .fortuneWheel:
        return appearance.fortuneWheelDescriptionForNoPremiumAccess
      case .memes:
        return appearance.memesDescriptionForNoPremiumAccess
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
    
    /// Раздел `Никнейм`
    case nickName
    
    /// Раздел генерации имен
    case names
    
    /// Раздел поздравлений
    case congratulations
    
    /// Раздел "Хорошие дела"
    case goodDeeds
    
    /// Раздел "Загадки"
    case riddles
    
    /// Раздел "Анекдоты"
    case joke

    /// Раздел "Подарки"
    case gifts

    /// Раздел "Слоганы"
    case slogans

    /// Раздел "Правда или действие"
    case truthOrDare
    
    /// Раздел "Цитаты"
    case quotes
    
    /// Раздел "Колесо Фортуны"
    case fortuneWheel
    
    /// Раздел "Мемы"
    case memes
  }
}
