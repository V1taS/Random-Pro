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
    
    /// Диплинки на открытие экрана
    var deepLinkEndPoint: String {
      switch self {
      case .teams:
        return "teams_screen"
      case .number:
        return "number_screen"
      case .yesOrNo:
        return "number_screen"
      case .letter:
        return "character_screen"
      case .list:
        return "list_screen"
      case .coin:
        return "coin_screen"
      case .cube:
        return "cube_screen"
      case .dateAndTime:
        return "date_and_time_screen"
      case .lottery:
        return "lottery_screen"
      case .contact:
        return "contact_screen"
      case .password:
        return "password_screen"
      case .colors:
        return "colors_screen"
      case .bottle:
        return "bottle_screen"
      case .rockPaperScissors:
        return "rock_paper_scissors_screen"
      case .imageFilters:
        return "image_filters"
      case .films:
        return "films_screen"
      case .nickName:
        return "nick_name"
      case .names:
        return "names"
      case .congratulations:
        return "congratulations"
      case .goodDeeds:
        return "good_deeds"
      case .riddles:
        return "riddles"
      case .joke:
        return "joke"
      case .gifts:
        return "gifts"
      }
    }
    
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
  }
}
