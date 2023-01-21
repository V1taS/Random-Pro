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
  ///  - Parameter model: Моделька с даными
  func didReceiveNew(model: MainScreenModel)
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
    let allSections: [MainScreenModel.Section] = model.allSections.filter { $0.isEnabled && !$0.isHidden }
    let newModel = MainScreenModel(isDarkMode: model.isDarkMode,
                                   isPremium: model.isPremium,
                                   allSections: allSections)
    output?.didReceiveNew(model: newModel)
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
        ifDebugFeatureSection {
          allSections.append(MainScreenModel.Section(
            type: section,
            isEnabled: true,
            isHidden: false,
            titleSection: appearance.titleRockPaperScissors,
            imageSection: appearance.imageRockPaperScissorsScreenView.pngData() ?? Data(),
            advLabel: .premium
          ))
        }
      case .imageFilters:
        ifDebugFeatureSection {
          allSections.append(MainScreenModel.Section(
            type: section,
            isEnabled: true,
            isHidden: false,
            titleSection: appearance.titleImageFilters,
            imageSection: appearance.imageImageFilters.pngData() ?? Data(),
            advLabel: .premium
          ))
        }
      case .raffle:
        ifDebugFeatureSection {
          allSections.append(MainScreenModel.Section(
            type: section,
            isEnabled: true,
            isHidden: false,
            titleSection: appearance.titleRaffle,
            imageSection: appearance.imageRaffle.pngData() ?? Data(),
            advLabel: .premium
          ))
        }
      }
    }
    return MainScreenModel(isDarkMode: nil,
                           isPremium: false,
                           allSections: allSections)
  }
  
  static func updateModelWith(
    oldModel: MainScreenModel,
    featureToggleModel: SectionsIsHiddenFTModel? = nil,
    labelsModel: LabelsFeatureToggleModel? = nil,
    isPremium: Bool? = nil
  ) -> MainScreenModel {
    let appearance = Appearance()
    var cardSections: [MainScreenModel.Section] = []
    
    updatesNewSectionForModel(models: oldModel.allSections).forEach { model in
      switch model.type {
      case .teams:
        cardSections.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.teams) ?? model.isHidden,
          titleSection: appearance.titleCardTeam,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.teams,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .number:
        cardSections.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.number) ?? model.isHidden,
          titleSection: appearance.titleCardNumber,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.number,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .yesOrNo:
        cardSections.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.yesOrNo) ?? model.isHidden,
          titleSection: appearance.titleCardYesOrNot,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.yesOrNo,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .letter:
        cardSections.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.letter) ?? model.isHidden,
          titleSection: appearance.titleCardCharacters,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.letter,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .list:
        cardSections.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.list) ?? model.isHidden,
          titleSection: appearance.titleCardList,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.list,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .coin:
        cardSections.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.coin) ?? model.isHidden,
          titleSection: appearance.titleCardCoin,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.coin,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .cube:
        cardSections.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.cube) ?? model.isHidden,
          titleSection: appearance.titleCardCube,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.cube,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .dateAndTime:
        cardSections.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.dateAndTime) ?? model.isHidden,
          titleSection: appearance.titleCardDateAndTime,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.dateAndTime,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .lottery:
        cardSections.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.lottery) ?? model.isHidden,
          titleSection: appearance.titleCardLottery,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.lottery,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .contact:
        cardSections.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.contact) ?? model.isHidden,
          titleSection: appearance.titleCardContact,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.contact,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .password:
        cardSections.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.password) ?? model.isHidden,
          titleSection: appearance.titleCardPassword,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.password,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .colors:
        cardSections.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.colors) ?? model.isHidden,
          titleSection: appearance.titleColors,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.colors,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .bottle:
        cardSections.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.bottle) ?? model.isHidden,
          titleSection: appearance.titleBottle,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.bottle,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .rockPaperScissors:
        ifDebugFeatureSection {
          cardSections.append(MainScreenModel.Section(
            type: model.type,
            isEnabled: model.isEnabled,
            isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.rockPaperScissors) ?? model.isHidden,
            titleSection: appearance.titleRockPaperScissors,
            imageSection: model.imageSection,
            advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.rockPaperScissors,
                                   oldRawValue: model.advLabel.rawValue)
          ))
        }
      case .imageFilters:
        ifDebugFeatureSection {
          cardSections.append(MainScreenModel.Section(
            type: model.type,
            isEnabled: model.isEnabled,
            isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.imageFilters) ?? model.isHidden,
            titleSection: appearance.titleImageFilters,
            imageSection: model.imageSection,
            advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.imageFilters,
                                   oldRawValue: model.advLabel.rawValue)
          ))
        }
      case .raffle:
        ifDebugFeatureSection {
          cardSections.append(MainScreenModel.Section(
            type: model.type,
            isEnabled: model.isEnabled,
            isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.raffle) ?? model.isHidden,
            titleSection: appearance.titleRaffle,
            imageSection: model.imageSection,
            advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.raffle,
                                   oldRawValue: model.advLabel.rawValue)
          ))
        }
      }
    }
    let newModel = MainScreenModel(isDarkMode: oldModel.isDarkMode,
                                   isPremium: isPremium ?? oldModel.isPremium,
                                   allSections: cardSections)
    return newModel
  }
  
  static func ifDebugFeatureSection(completion: () -> Void) {
#if DEBUG
    completion()
#endif
  }
  
  static func ifDebugFeatureSectionIsHidden(_ isHidden: Bool?) -> Bool? {
#if DEBUG
    return false
#else
    return isHidden
#endif
  }
  
  static func setLabelFrom(featureToggleRawValue: String?,
                           oldRawValue: String) -> MainScreenModel.ADVLabel {
    let currentLabelType = MainScreenModel.ADVLabel(rawValue: oldRawValue) ?? .none
    let featureToggleLabelType = MainScreenModel.ADVLabel(rawValue: featureToggleRawValue ?? oldRawValue)
    
    switch currentLabelType {
    case .premium:
      return featureToggleLabelType ?? .premium
    default:
      return featureToggleLabelType ?? currentLabelType
    }
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
    
    let imageRaffle = UIImage(systemName: "gift") ?? UIImage()
    let titleRaffle = NSLocalizedString("Розыгрыш", comment: "")
  }
}
