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
          premiumAccessAllowed: false,
          isHidden: false,
          titleSection: appearance.titleCardTeam,
          imageSection: appearance.imageCardTeam.pngData() ?? Data(),
          advLabel: .none
        ))
      case .number:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          premiumAccessAllowed: false,
          isHidden: false,
          titleSection: appearance.titleCardNumber,
          imageSection: appearance.imageCardNumber.pngData() ?? Data(),
          advLabel: .none
        ))
      case .yesOrNo:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          premiumAccessAllowed: false,
          isHidden: false,
          titleSection: appearance.titleCardYesOrNot,
          imageSection: appearance.imageCardYesOrNot.pngData() ?? Data(),
          advLabel: .none
        ))
      case .letter:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          premiumAccessAllowed: false,
          isHidden: false,
          titleSection: appearance.titleCardCharacters,
          imageSection: appearance.imageCardCharacters.pngData() ?? Data(),
          advLabel: .none
        ))
      case .list:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          premiumAccessAllowed: false,
          isHidden: false,
          titleSection: appearance.titleCardList,
          imageSection: appearance.imageCardList.pngData() ?? Data(),
          advLabel: .none
        ))
      case .coin:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          premiumAccessAllowed: false,
          isHidden: false,
          titleSection: appearance.titleCardCoin,
          imageSection: appearance.imageCardCoin.pngData() ?? Data(),
          advLabel: .none
        ))
      case .cube:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          premiumAccessAllowed: false,
          isHidden: false,
          titleSection: appearance.titleCardCube,
          imageSection: appearance.imageCardCube.pngData() ?? Data(),
          advLabel: .none
        ))
      case .dateAndTime:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          premiumAccessAllowed: false,
          isHidden: false,
          titleSection: appearance.titleCardDateAndTime,
          imageSection: appearance.imageCardDateAndTime.pngData() ?? Data(),
          advLabel: .none
        ))
      case .lottery:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          premiumAccessAllowed: false,
          isHidden: false,
          titleSection: appearance.titleCardLottery,
          imageSection: appearance.imageCardLottery.pngData() ?? Data(),
          advLabel: .none
        ))
      case .contact:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          premiumAccessAllowed: false,
          isHidden: false,
          titleSection: appearance.titleCardContact,
          imageSection: appearance.imageCardContact.pngData() ?? Data(),
          advLabel: .none
        ))
      case .password:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          premiumAccessAllowed: false,
          isHidden: false,
          titleSection: appearance.titleCardPassword,
          imageSection: appearance.imageCardPassword.pngData() ?? Data(),
          advLabel: .none
        ))
      case .colors:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          premiumAccessAllowed: false,
          isHidden: false,
          titleSection: appearance.titleColors,
          imageSection: appearance.imageColors.pngData() ?? Data(),
          advLabel: .none
        ))
      case .bottle:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          premiumAccessAllowed: false,
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
            premiumAccessAllowed: false,
            isHidden: false,
            titleSection: appearance.titleRockPaperScissors,
            imageSection: appearance.imageRockPaperScissorsScreenView.pngData() ?? Data(),
            advLabel: .new
          ))
        }
      case .imageFilters:
        ifDebugFeatureSection {
          allSections.append(MainScreenModel.Section(
            type: section,
            isEnabled: true,
            premiumAccessAllowed: false,
            isHidden: false,
            titleSection: appearance.titleImageFilters,
            imageSection: appearance.imageImageFilters.pngData() ?? Data(),
            advLabel: .premium
          ))
        }
      }
    }
    return MainScreenModel(isDarkMode: nil,
                           allSections: allSections)
  }
  
  static func updatesSectionForModel(
    models: [MainScreenModel.Section],
    featureToggleModel: SectionsIsHiddenFTModel? = nil,
    labelsModel: LabelsFeatureToggleModel? = nil,
    isPremium: Bool? = nil
  ) -> [MainScreenModel.Section] {
    let appearance = Appearance()
    var newModel: [MainScreenModel.Section] = []
    
    updatesNewSectionForModel(models: models).forEach { model in
      switch model.type {
      case .teams:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          premiumAccessAllowed: isPremium ?? model.premiumAccessAllowed,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.teams) ?? model.isHidden,
          titleSection: appearance.titleCardTeam,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.teams,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .number:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          premiumAccessAllowed: isPremium ?? model.premiumAccessAllowed,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.number) ?? model.isHidden,
          titleSection: appearance.titleCardNumber,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.number,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .yesOrNo:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          premiumAccessAllowed: isPremium ?? model.premiumAccessAllowed,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.yesOrNo) ?? model.isHidden,
          titleSection: appearance.titleCardYesOrNot,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.yesOrNo,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .letter:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          premiumAccessAllowed: isPremium ?? model.premiumAccessAllowed,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.letter) ?? model.isHidden,
          titleSection: appearance.titleCardCharacters,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.letter,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .list:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          premiumAccessAllowed: isPremium ?? model.premiumAccessAllowed,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.list) ?? model.isHidden,
          titleSection: appearance.titleCardList,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.list,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .coin:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          premiumAccessAllowed: isPremium ?? model.premiumAccessAllowed,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.coin) ?? model.isHidden,
          titleSection: appearance.titleCardCoin,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.coin,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .cube:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          premiumAccessAllowed: isPremium ?? model.premiumAccessAllowed,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.cube) ?? model.isHidden,
          titleSection: appearance.titleCardCube,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.cube,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .dateAndTime:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          premiumAccessAllowed: isPremium ?? model.premiumAccessAllowed,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.dateAndTime) ?? model.isHidden,
          titleSection: appearance.titleCardDateAndTime,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.dateAndTime,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .lottery:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          premiumAccessAllowed: isPremium ?? model.premiumAccessAllowed,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.lottery) ?? model.isHidden,
          titleSection: appearance.titleCardLottery,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.lottery,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .contact:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          premiumAccessAllowed: isPremium ?? model.premiumAccessAllowed,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.contact) ?? model.isHidden,
          titleSection: appearance.titleCardContact,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.contact,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .password:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          premiumAccessAllowed: isPremium ?? model.premiumAccessAllowed,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.password) ?? model.isHidden,
          titleSection: appearance.titleCardPassword,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.password,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .colors:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          premiumAccessAllowed: isPremium ?? model.premiumAccessAllowed,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.colors) ?? model.isHidden,
          titleSection: appearance.titleColors,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.colors,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .bottle:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          premiumAccessAllowed: isPremium ?? model.premiumAccessAllowed,
          isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.bottle) ?? model.isHidden,
          titleSection: appearance.titleBottle,
          imageSection: model.imageSection,
          advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.bottle,
                                 oldRawValue: model.advLabel.rawValue)
        ))
      case .rockPaperScissors:
        ifDebugFeatureSection {
          newModel.append(MainScreenModel.Section(
            type: model.type,
            isEnabled: model.isEnabled,
            premiumAccessAllowed: isPremium ?? model.premiumAccessAllowed,
            isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.rockPaperScissors) ?? model.isHidden,
            titleSection: appearance.titleRockPaperScissors,
            imageSection: model.imageSection,
            advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.rockPaperScissors,
                                   oldRawValue: model.advLabel.rawValue)
          ))
        }
      case .imageFilters:
        ifDebugFeatureSection {
          newModel.append(MainScreenModel.Section(
            type: model.type,
            isEnabled: model.isEnabled,
            premiumAccessAllowed: isPremium ?? model.premiumAccessAllowed,
            isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.imageFilters) ?? model.isHidden,
            titleSection: appearance.titleImageFilters,
            imageSection: model.imageSection,
            advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.imageFilters,
                                   oldRawValue: model.advLabel.rawValue)
          ))
        }
      }
    }
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

  static func setLabelFrom(featureToggleRawValue: String?, oldRawValue: String) -> MainScreenModel.ADVLabel {
    let featureToggleLabelType = MainScreenModel.ADVLabel(rawValue: featureToggleRawValue ?? oldRawValue) ?? .none
    let oldLabelType = MainScreenModel.ADVLabel(rawValue: oldRawValue) ?? .none
    return oldLabelType == .new ? oldLabelType : featureToggleLabelType
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
