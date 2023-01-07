//
//  MainScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol MainScreenFactoryOutput: AnyObject {
  
  /// Были получены модельки
  ///  - Parameter models: Модельки для главного экрана
  func didReceive(models: [MainScreenModel.Section])
}

/// Cобытия которые отправляем от Presenter к Factory
protocol MainScreenFactoryInput {
  
  /// Создать массив ячеек из модельки
  /// - Parameter model: Массив ячеек
  func createCellsFrom(model: MainScreenModel)
}

/// Фабрика
final class MainScreenFactory: MainScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func createCellsFrom(model: MainScreenModel) {
    let models: [MainScreenModel.Section] = model.allSections.filter { $0.isEnabled && !$0.isHidden }
    output?.didReceive(models: models)
  }
}

// MARK: - Static func

extension MainScreenFactory {
  static func createBaseModel() -> MainScreenModel {
    let appearance = Appearance()
    var allSections: [MainScreenModel.Section] = []
    
    MainScreenModel.SectionType.allCases.forEach { section in
      switch section {
      case .teams:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          titleSection: appearance.titleCardTeam,
          imageSection: appearance.imageCardTeam.pngData() ?? Data(),
          advLabel: .none
        ))
      case .number:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          titleSection: appearance.titleCardNumber,
          imageSection: appearance.imageCardNumber.pngData() ?? Data(),
          advLabel: .none
        ))
      case .yesOrNo:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          titleSection: appearance.titleCardYesOrNot,
          imageSection: appearance.imageCardYesOrNot.pngData() ?? Data(),
          advLabel: .none
        ))
      case .letter:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          titleSection: appearance.titleCardCharacters,
          imageSection: appearance.imageCardCharacters.pngData() ?? Data(),
          advLabel: .none
        ))
      case .list:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          titleSection: appearance.titleCardList,
          imageSection: appearance.imageCardList.pngData() ?? Data(),
          advLabel: .none
        ))
      case .coin:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          titleSection: appearance.titleCardCoin,
          imageSection: appearance.imageCardCoin.pngData() ?? Data(),
          advLabel: .none
        ))
      case .cube:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          titleSection: appearance.titleCardCube,
          imageSection: appearance.imageCardCube.pngData() ?? Data(),
          advLabel: .none
        ))
      case .dateAndTime:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          titleSection: appearance.titleCardDateAndTime,
          imageSection: appearance.imageCardDateAndTime.pngData() ?? Data(),
          advLabel: .none
        ))
      case .lottery:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          titleSection: appearance.titleCardLottery,
          imageSection: appearance.imageCardLottery.pngData() ?? Data(),
          advLabel: .none
        ))
      case .contact:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          titleSection: appearance.titleCardContact,
          imageSection: appearance.imageCardContact.pngData() ?? Data(),
          advLabel: .none
        ))
      case .password:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          titleSection: appearance.titleCardPassword,
          imageSection: appearance.imageCardPassword.pngData() ?? Data(),
          advLabel: .none
        ))
      case .colors:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          titleSection: appearance.titleColors,
          imageSection: appearance.imageColors.pngData() ?? Data(),
          advLabel: .none
        ))
      case .bottle:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          titleSection: appearance.titleBottle,
          imageSection: appearance.bottleCardImage.pngData() ?? Data(),
          advLabel: .new
        ))
      case .rockPaperScissors:
        featureSection {
          allSections.append(MainScreenModel.Section(
            type: section,
            isEnabled: true,
            isHidden: false,
            titleSection: appearance.titleRockPaperScissors,
            imageSection: appearance.imageRockPaperScissorsScreenView.pngData() ?? Data(),
            advLabel: .new
          ))
        }
      case .imageFilters:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          titleSection: appearance.titleImageFilters,
          imageSection: appearance.imageImageFilters.pngData() ?? Data(),
          advLabel: .new
        ))
      }
    }
    return MainScreenModel(isDarkMode: nil,
                           allSections: allSections)
  }
  
  static func updatesLocalizationTitleSectionForModel(
    models: [MainScreenModel.Section]
  ) -> [MainScreenModel.Section] {
    let appearance = Appearance()
    var newModel: [MainScreenModel.Section] = []
    
    updatesNewSectionForModel(models: models).forEach { model in
      switch model.type {
      case .teams:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: appearance.titleCardTeam,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .number:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: appearance.titleCardNumber,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .yesOrNo:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: appearance.titleCardYesOrNot,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .letter:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: appearance.titleCardCharacters,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .list:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: appearance.titleCardList,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .coin:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: appearance.titleCardCoin,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .cube:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: appearance.titleCardCube,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .dateAndTime:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: appearance.titleCardDateAndTime,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .lottery:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: appearance.titleCardLottery,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .contact:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: appearance.titleCardContact,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .password:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: appearance.titleCardPassword,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .colors:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: appearance.titleColors,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .bottle:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: appearance.titleBottle,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .rockPaperScissors:
        featureSection {
          newModel.append(MainScreenModel.Section(
            type: model.type,
            isEnabled: model.isEnabled,
            isHidden: model.isHidden,
            titleSection: appearance.titleRockPaperScissors,
            imageSection: model.imageSection,
            advLabel: model.advLabel
          ))
        }
      case .imageFilters:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: appearance.titleImageFilters,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      }
    }
    return newModel
  }
  
  static func updatesSectionsIsHiddenFTForModel(
    models: [MainScreenModel.Section],
    featureToggleModel: SectionsIsHiddenFTModel
  ) -> [MainScreenModel.Section] {
    var newModel: [MainScreenModel.Section] = []
    
    updatesNewSectionForModel(models: models).forEach { model in
      switch model.type {
      case .teams:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: featureToggleModel.teams,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .number:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: featureToggleModel.number,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .yesOrNo:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: featureToggleModel.yesOrNo,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .letter:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: featureToggleModel.letter,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .list:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: featureToggleModel.list,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .coin:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: featureToggleModel.coin,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .cube:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: featureToggleModel.cube,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .dateAndTime:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: featureToggleModel.dateAndTime,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .lottery:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: featureToggleModel.lottery,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .contact:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: featureToggleModel.contact,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .password:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: featureToggleModel.password,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .colors:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: featureToggleModel.colors,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .bottle:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: featureToggleModel.bottle,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .rockPaperScissors:
        featureSection {
          newModel.append(MainScreenModel.Section(
            type: model.type,
            isEnabled: model.isEnabled,
            isHidden: featureToggleModel.rockPaperScissors,
            titleSection: model.titleSection,
            imageSection: model.imageSection,
            advLabel: model.advLabel
          ))
        }
      case .imageFilters:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: featureToggleModel.imageFilters,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      }
    }
    return newModel
  }
  
  static func updatesLabelsModel(
    models: [MainScreenModel.Section],
    labelsModel: LabelsFeatureToggleModel
  ) -> [MainScreenModel.Section] {
    var newModel: [MainScreenModel.Section] = []
    
    models.forEach { model in
      if model.advLabel == .new {
        newModel.append(model)
        return
      }
      
      switch model.type {
      case .teams:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: MainScreenModel.ADVLabel(rawValue: labelsModel.teams) ?? .none
        ))
      case .number:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: MainScreenModel.ADVLabel(rawValue: labelsModel.number) ?? .none
        ))
      case .yesOrNo:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: MainScreenModel.ADVLabel(rawValue: labelsModel.yesOrNo) ?? .none
        ))
      case .letter:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: MainScreenModel.ADVLabel(rawValue: labelsModel.letter) ?? .none
        ))
      case .list:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: MainScreenModel.ADVLabel(rawValue: labelsModel.list) ?? .none
        ))
      case .coin:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: MainScreenModel.ADVLabel(rawValue: labelsModel.coin) ?? .none
        ))
      case .cube:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: MainScreenModel.ADVLabel(rawValue: labelsModel.cube) ?? .none
        ))
      case .dateAndTime:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: MainScreenModel.ADVLabel(rawValue: labelsModel.dateAndTime) ?? .none
        ))
      case .lottery:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: MainScreenModel.ADVLabel(rawValue: labelsModel.lottery) ?? .none
        ))
      case .contact:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: MainScreenModel.ADVLabel(rawValue: labelsModel.contact) ?? .none
        ))
      case .password:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: MainScreenModel.ADVLabel(rawValue: labelsModel.password) ?? .none
        ))
      case .colors:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: MainScreenModel.ADVLabel(rawValue: labelsModel.colors) ?? .none
        ))
      case .bottle:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: MainScreenModel.ADVLabel(rawValue: labelsModel.bottle) ?? .none
        ))
      case .rockPaperScissors:
        featureSection {
          newModel.append(MainScreenModel.Section(
            type: model.type,
            isEnabled: model.isEnabled,
            isHidden: model.isHidden,
            titleSection: model.titleSection,
            imageSection: model.imageSection,
            advLabel: MainScreenModel.ADVLabel(rawValue: labelsModel.rockPaperScissors) ?? .none
          ))
        }
      case .imageFilters:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: model.isHidden,
          titleSection: model.titleSection,
          imageSection: model.imageSection,
          advLabel: MainScreenModel.ADVLabel(rawValue: labelsModel.imageFilters) ?? .none
        ))
      }
    }
    return newModel
  }
  
  static func featureSection(completion: () -> Void) {
#if DEBUG
    completion()
#endif
  }
}

// MARK: - Private func

private extension MainScreenFactory {
  static func updatesNewSectionForModel(
    models: [MainScreenModel.Section]
  ) -> [MainScreenModel.Section] {
    let allSections = createBaseModel().allSections
    var newModel = models
    
    for section in allSections {
      let oldSections = models.filter { $0.type == section.type }
      if oldSections.isEmpty {
        newModel.append(section)
      }
    }
    return newModel
  }
}

// MARK: - Appearance

private extension MainScreenFactory {
  struct Appearance {
    let keyUserDefaults = "main_screen_user_defaults_key"
    
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
    
    let bottleCardImage = UIImage(systemName: "arrow.triangle.2.circlepath") ?? UIImage()
    let titleBottle = NSLocalizedString("Бутылочка", comment: "")
    
    let imageRockPaperScissorsScreenView = UIImage(systemName: "hurricane.circle") ?? UIImage()
    let titleRockPaperScissors = NSLocalizedString("Цу-е-фа", comment: "")
    
    let imageImageFilters = UIImage(systemName: "timelapse") ?? UIImage()
    let titleImageFilters = NSLocalizedString("Фильтры", comment: "")
  }
}
