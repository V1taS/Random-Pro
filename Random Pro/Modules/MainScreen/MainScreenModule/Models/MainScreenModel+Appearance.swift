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
    let raffleFiltersDescriptionForNoPremiumAccess = NSLocalizedString("Можно участвовать в еженедельном розыгрыше призов",
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
    
    let imageRaffle = "gift"
    let titleRaffle = NSLocalizedString("Розыгрыш", comment: "")
    
    let imageFilms = "film"
    let titleFilms = NSLocalizedString("Фильмы", comment: "")
  }
}
