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
import SKAbstractions

// MARK: - SectionType

extension MainScreenModel.SectionType {
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
        case .de:
          return appearance.titleTruthOrDareDe
        default:
          return appearance.titleTruthOrDareOther
        }
      }
      return appearance.titleTruthOrDareOther
    case .memes:
      return appearance.titleMemes
    case .adv1:
      return ""
    case .adv2:
      return ""
    case .adv3:
      return ""
    case .adv4:
      return ""
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
    case .adv1:
      return ""
    case .adv2:
      return ""
    case .adv3:
      return ""
    case .adv4:
      return ""
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
    case .adv1:
      return ""
    case .adv2:
      return ""
    case .adv3:
      return ""
    case .adv4:
      return ""
    }
  }
}

// MARK: - ADVLabel

extension MainScreenModel.ADVLabel {
  var title: String {
    let appearance = Appearance()
    switch self {
    case .hit:
      return appearance.hit
    case .new:
      return appearance.new
    case .none:
      return ""
    case let .custom(text):
      return text
    case .adv:
      return appearance.adv
    case .ai:
      return appearance.ai
    }
  }
}

private struct Appearance {
  let hit = RandomStrings.Localizable.hit
  let new = RandomStrings.Localizable.new
  let premium = RandomStrings.Localizable.premium
  let adv = RandomStrings.Localizable.adv
  let ai = RandomStrings.Localizable.ai

  let teamsDescriptionForNoPremiumAccess = RandomStrings.Localizable.generateRandomTeamList
  let numberDescriptionForNoPremiumAccess = RandomStrings.Localizable.generateRandomNumbers
  let yesOrNoDescriptionForNoPremiumAccess = RandomStrings.Localizable.generateRandomAnswer
  let letterDescriptionForNoPremiumAccess = RandomStrings.Localizable.generateRandomLetters
  let listDescriptionForNoPremiumAccess = RandomStrings.Localizable.generateRandomTaskList
  let coinDescriptionForNoPremiumAccess = RandomStrings.Localizable.flipCoinAnytime
  let cubeDescriptionForNoPremiumAccess = RandomStrings.Localizable.rollDiceForBoardGames
  let dateAndTimeDescriptionForNoPremiumAccess = RandomStrings.Localizable.generateRandomDateTime
  let lotteryDescriptionForNoPremiumAccess = RandomStrings.Localizable.canGenerateRandomLotteryTicket
  let contactDescriptionForNoPremiumAccess = RandomStrings.Localizable.canGenerateRandomContact
  let passwordDescriptionForNoPremiumAccess = RandomStrings.Localizable.canGenerateRandomPassword
  let colorsDescriptionForNoPremiumAccess = RandomStrings.Localizable.canGenerateRandomBackgroundColors
  let bottleDescriptionForNoPremiumAccess = RandomStrings.Localizable.canSpinVirtualBottle
  let rockPaperScissorsDescriptionForNoPremiumAccess = RandomStrings.Localizable.canPlayRockPaperScissors
  let imageFiltersDescriptionForNoPremiumAccess = RandomStrings.Localizable.canGenerateRandomPhotoFilter
  let filmsDescriptionForNoPremiumAccess = RandomStrings.Localizable.canGenerateRandomMovie
  let nickNameDescriptionForNoPremiumAccess = RandomStrings.Localizable.generateRandomNickname

  let imageCardTeam = "person.circle"
  let titleCardTeam = RandomStrings.Localizable.teams

  let imageCardNumber = "number"
  let titleCardNumber = RandomStrings.Localizable.number

  let imageCardYesOrNot = "y.square"
  let titleCardYesOrNot = RandomStrings.Localizable.yesOrNo

  let imageCardCharacters = "textbox"
  let titleCardCharacters = RandomStrings.Localizable.letter

  let imageCardList = "list.bullet.below.rectangle"
  let titleCardList = RandomStrings.Localizable.list

  let imageCardCoin = "bitcoinsign.circle"
  let titleCardCoin = RandomStrings.Localizable.coin

  let imageCardCube = "cube"
  let titleCardCube = RandomStrings.Localizable.cubes

  let imageCardDateAndTime = "calendar"
  let titleCardDateAndTime = RandomStrings.Localizable.dateAndTime

  let imageCardLottery = "tag"
  let titleCardLottery = RandomStrings.Localizable.lottery

  let imageCardContact = "phone.circle"
  let titleCardContact = RandomStrings.Localizable.contact

  let imageCardPassword = "wand.and.stars"
  let titleCardPassword = RandomStrings.Localizable.passwords

  let imageColors = "pencil.and.outline"
  let titleColors = RandomStrings.Localizable.colors

  let bottleCardImage = "escape"
  let titleBottle = RandomStrings.Localizable.bottle

  let imageRockPaperScissorsScreenView = "hurricane.circle"
  let titleRockPaperScissors = RandomStrings.Localizable.tsuEFa

  let imageImageFilters = "timelapse"
  let titleImageFilters = RandomStrings.Localizable.photoFilters

  let imageFilms = "film"
  let titleFilms = RandomStrings.Localizable.movies

  let imageNickName = "square.and.pencil"
  let titleNickName = RandomStrings.Localizable.nickname

  let imageNames = "textformat"
  let titleNames = RandomStrings.Localizable.names
  let namesDescriptionForNoPremiumAccess = RandomStrings.Localizable.generateRandomNames

  let imageCongratulations = "quote.bubble"
  let titleCongratulations = RandomStrings.Localizable.congratulations
  let congratulationsDescriptionForNoPremiumAccess = RandomStrings.Localizable.generateRandomCongratulations

  let imageGoodDeeds = "hand.thumbsup"
  let titleGoodDeeds = RandomStrings.Localizable.goodDeeds
  let goodDeedsDescriptionForNoPremiumAccess = RandomStrings.Localizable.generateRandomNamesGoodDeeds

  let imageRiddles = "lightbulb"
  let titleRiddles = RandomStrings.Localizable.riddles
  let riddlesDescriptionForNoPremiumAccess = RandomStrings.Localizable.generateRandomNamesRiddles

  let imageJoke = "flame"
  let titleJoke = RandomStrings.Localizable.joke
  let jokeDescriptionForNoPremiumAccess = RandomStrings.Localizable.generateRandomJoke

  let imageGifts = "gift"
  let titleGifts = RandomStrings.Localizable.gifts
  let giftsDescriptionForNoPremiumAccess = RandomStrings.Localizable.generateRandomGifts

  let imageSlogans = "character.bubble"
  let titleSlogans = RandomStrings.Localizable.slogans
  let slogansDescriptionForNoPremiumAccess = RandomStrings.Localizable.generateRandomSlogans

  let imageTruthOrDare = "arrow.left.and.right.righttriangle.left.righttriangle.right"
  static let titleTruth = RandomStrings.Localizable.truth
  static let titleOr = RandomStrings.Localizable.or
  static let titleDareLowercased = RandomStrings.Localizable.dare.lowercased()
  let titleTruthOrDareRu = "\(titleTruth) \(titleOr)\n\(titleDareLowercased)"
  let titleTruthOrDareDe = "\(titleTruth)\n\(titleOr) \(titleDareLowercased)"
  let titleTruthOrDareOther = "\(titleTruth) \(titleOr) \(titleDareLowercased)"
  let truthOrDareDescriptionForNoPremiumAccess = RandomStrings.Localizable.generateRandomTruthOrDare

  let imageQuotes = "text.quote"
  let titleQuotes = RandomStrings.Localizable.quotes
  let quotesDescriptionForNoPremiumAccess = RandomStrings.Localizable.generateRandomQoute

  let imageFortuneWheel = "arrow.triangle.2.circlepath"
  let titleFortuneWheel = RandomStrings.Localizable.fortuneWheel
  let fortuneWheelDescriptionForNoPremiumAccess = RandomStrings.Localizable.generateFortuneWheel

  let imageMemes = "photo"
  let titleMemes = RandomStrings.Localizable.memes
  let memesDescriptionForNoPremiumAccess = RandomStrings.Localizable.generateRandomMemes
}
