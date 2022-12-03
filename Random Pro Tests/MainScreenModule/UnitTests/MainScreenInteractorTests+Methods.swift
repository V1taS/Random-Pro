//
//  MainScreenInteractorTests+Methods.swift
//  Random Pro Tests
//
//  Created by Vitalii Sosin on 27.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
@testable import Random_Pro

// MARK: - func

extension MainScreenInteractorTests {
  func createBaseModelEngLang() -> MainScreenModel {
    let appearance = Appearance()
    var allSections: [MainScreenModel.Section] = []
    
    MainScreenModel.SectionType.allCases.forEach { section in
      switch section {
      case .teams:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardTeamEng,
          imageSection: appearance.imageCardTeam.pngData() ?? Data(),
          advLabel: .none
        ))
      case .number:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardNumberEng,
          imageSection: appearance.imageCardNumber.pngData() ?? Data(),
          advLabel: .none
        ))
      case .yesOrNo:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardYesOrNotEng,
          imageSection: appearance.imageCardYesOrNot.pngData() ?? Data(),
          advLabel: .none
        ))
      case .letter:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardCharactersEng,
          imageSection: appearance.imageCardCharacters.pngData() ?? Data(),
          advLabel: .none
        ))
      case .list:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardListEng,
          imageSection: appearance.imageCardList.pngData() ?? Data(),
          advLabel: .none
        ))
      case .coin:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardCoinEng,
          imageSection: appearance.imageCardCoin.pngData() ?? Data(),
          advLabel: .none
        ))
      case .cube:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardCubeEng,
          imageSection: appearance.imageCardCube.pngData() ?? Data(),
          advLabel: .none
        ))
      case .dateAndTime:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardDateAndTimeEng,
          imageSection: appearance.imageCardDateAndTime.pngData() ?? Data(),
          advLabel: .none
        ))
      case .lottery:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardLotteryEng,
          imageSection: appearance.imageCardLottery.pngData() ?? Data(),
          advLabel: .none
        ))
      case .contact:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardContactEng,
          imageSection: appearance.imageCardContact.pngData() ?? Data(),
          advLabel: .none
        ))
      case .password:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardPasswordEng,
          imageSection: appearance.imageCardPassword.pngData() ?? Data(),
          advLabel: .none
        ))
      case .colors:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleColorsEng,
          imageSection: appearance.imageColors.pngData() ?? Data(),
          advLabel: .none
        ))
      }
    }
    return MainScreenModel(isDarkMode: nil,
                           allSections: allSections)
  }
  
  func createBaseModelRusLang() -> MainScreenModel {
    let appearance = Appearance()
    var allSections: [MainScreenModel.Section] = []
    
    MainScreenModel.SectionType.allCases.forEach { section in
      switch section {
      case .teams:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardTeam,
          imageSection: appearance.imageCardTeam.pngData() ?? Data(),
          advLabel: .none
        ))
      case .number:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardNumber,
          imageSection: appearance.imageCardNumber.pngData() ?? Data(),
          advLabel: .none
        ))
      case .yesOrNo:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardYesOrNot,
          imageSection: appearance.imageCardYesOrNot.pngData() ?? Data(),
          advLabel: .none
        ))
      case .letter:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardCharacters,
          imageSection: appearance.imageCardCharacters.pngData() ?? Data(),
          advLabel: .none
        ))
      case .list:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardList,
          imageSection: appearance.imageCardList.pngData() ?? Data(),
          advLabel: .none
        ))
      case .coin:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardCoin,
          imageSection: appearance.imageCardCoin.pngData() ?? Data(),
          advLabel: .none
        ))
      case .cube:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardCube,
          imageSection: appearance.imageCardCube.pngData() ?? Data(),
          advLabel: .none
        ))
      case .dateAndTime:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardDateAndTime,
          imageSection: appearance.imageCardDateAndTime.pngData() ?? Data(),
          advLabel: .none
        ))
      case .lottery:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardLottery,
          imageSection: appearance.imageCardLottery.pngData() ?? Data(),
          advLabel: .none
        ))
      case .contact:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardContact,
          imageSection: appearance.imageCardContact.pngData() ?? Data(),
          advLabel: .none
        ))
      case .password:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardPassword,
          imageSection: appearance.imageCardPassword.pngData() ?? Data(),
          advLabel: .none
        ))
      case .colors:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleColors,
          imageSection: appearance.imageColors.pngData() ?? Data(),
          advLabel: .none
        ))
      }
    }
    return MainScreenModel(isDarkMode: nil,
                           allSections: allSections)
  }
}

// MARK: - Appearance

extension MainScreenInteractorTests {
  struct Appearance {
    let keyUserDefaults = "main_screen_user_defaults_key"
    
    let imageCardFilms = UIImage(systemName: "film") ?? UIImage()
    let titleCardFilms = "Фильмы"
    let titleCardFilmsEng = "Movies"
    
    let imageCardTeam = UIImage(systemName: "person.circle") ?? UIImage()
    let titleCardTeam = "Команды"
    let titleCardTeamEng = "Teams"
    
    let imageCardNumber = UIImage(systemName: "number") ?? UIImage()
    let titleCardNumber = "Число"
    let titleCardNumberEng = "Number"
    
    let imageCardYesOrNot = UIImage(systemName: "questionmark.square") ?? UIImage()
    let titleCardYesOrNot = "Да или Нет"
    let titleCardYesOrNotEng = "Yes or no"
    
    let imageCardCharacters = UIImage(systemName: "textbox") ?? UIImage()
    let titleCardCharacters = "Буква"
    let titleCardCharactersEng = "Letter"
    
    let imageCardList = UIImage(systemName: "list.bullet.below.rectangle") ?? UIImage()
    let titleCardList = "Список"
    let titleCardListEng = "List"
    
    let imageCardCoin = UIImage(systemName: "bitcoinsign.circle") ?? UIImage()
    let titleCardCoin = "Монета"
    let titleCardCoinEng = "Coin"
    
    let imageCardCube = UIImage(systemName: "cube") ?? UIImage()
    let titleCardCube = "Кубики"
    let titleCardCubeEng = "Cubes"
    
    let imageCardDateAndTime = UIImage(systemName: "calendar") ?? UIImage()
    let titleCardDateAndTime = "Дата и время"
    let titleCardDateAndTimeEng = "Date and time"
    
    let imageCardLottery = UIImage(systemName: "tag") ?? UIImage()
    let titleCardLottery = "Лотерея"
    let titleCardLotteryEng = "Lottery"
    
    let imageCardContact = UIImage(systemName: "phone.circle") ?? UIImage()
    let titleCardContact = "Контакт"
    let titleCardContactEng = "Contact"
    
    let imageCardPassword = UIImage(systemName: "wand.and.stars") ?? UIImage()
    let titleCardPassword = "Пароли"
    let titleCardPasswordEng = "Passwords"
    
    let imageColors = UIImage(systemName: "photo.on.rectangle.angled") ?? UIImage()
    let titleColors = "Цвета"
    let titleColorsEng = "Colors"
  }
}
