//
//  MainScreenModel+Appearance.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 25.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

extension MainScreenModel {
  struct Appearance {
    let hit = RandomStrings.Localizable.hit
    let new = RandomStrings.Localizable.new
    let premium = RandomStrings.Localizable.premium
    let adv = RandomStrings.Localizable.adv
    
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
}
