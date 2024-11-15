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
  
  /// Создать базовую модель
  func createBaseModel(completion: @escaping (MainScreenModel) -> Void)
  
  /// Обновить базавую модель
  func updateModelWith(oldModel: MainScreenModel,
                       isPremium: Bool?,
                       completion: @escaping (MainScreenModel) -> Void)
}

/// Фабрика
final class MainScreenFactory: MainScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenFactoryOutput?
  
  // MARK: - Private properties
  
  private let featureToggleServices: FeatureToggleServices
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    featureToggleServices = services.featureToggleServices
  }
  
  // MARK: - Internal func
  
  func createCellsFrom(model: MainScreenModel) {
    let allSections: [MainScreenModel.Section] = model.allSections.filter { $0.isEnabled && !$0.isHidden }
    let newModel = MainScreenModel(isDarkMode: model.isDarkMode,
                                   isPremium: model.isPremium,
                                   allSections: allSections)
    output?.didReceiveNew(model: newModel)
  }
}

extension MainScreenFactory {
  func createBaseModel(completion: @escaping (MainScreenModel) -> Void) {
    var allSections: [MainScreenModel.Section] = []
    
    MainScreenModel.SectionType.allCases.forEach { section in
      switch section {
      case .teams:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: false,
          advLabel: .none
        ))
      case .number:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: false,
          advLabel: .none
        ))
      case .yesOrNo:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: false,
          advLabel: .none
        ))
      case .letter:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: false,
          advLabel: .none
        ))
      case .list:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: false,
          advLabel: .none
        ))
      case .coin:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: false,
          advLabel: .none
        ))
      case .cube:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: false,
          advLabel: .none
        ))
      case .dateAndTime:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: false,
          advLabel: .none
        ))
      case .lottery:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: false,
          advLabel: .none
        ))
      case .contact:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: false,
          advLabel: .none
        ))
      case .password:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: false,
          advLabel: .none
        ))
      case .colors:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: false,
          advLabel: .none
        ))
      case .bottle:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: false,
          advLabel: .new
        ))
      case .rockPaperScissors:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: true,
          advLabel: .none
        ))
      case .imageFilters:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: true,
          advLabel: .none
        ))
      case .films:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: true,
          advLabel: .none
        ))
      case .nickName:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: true,
          advLabel: .none
        ))
      case .names:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: true,
          advLabel: .none
        ))
      case .congratulations:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: true,
          advLabel: .none
        ))
      case .goodDeeds:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: true,
          advLabel: .none
        ))
      case .riddles:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: true,
          advLabel: .none
        ))
      case .joke:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: true,
          advLabel: .none
        ))
      case .gifts:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: true,
          advLabel: .none
        ))
      case .slogans:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: true,
          advLabel: .none
        ))
      case .quotes:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: true,
          advLabel: .none
        ))
      case .fortuneWheel:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: true,
          advLabel: .none
        ))
      case .truthOrDare:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: true,
          advLabel: .none
        ))
      case .memes:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: false,
          isPremium: true,
          advLabel: .none
        ))
      case .adv1:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: true,
          isPremium: false,
          advLabel: .adv
        ))
      case .adv2:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: true,
          isPremium: false,
          advLabel: .adv
        ))
      case .adv3:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: true,
          isPremium: false,
          advLabel: .adv
        ))
      case .adv4:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          isHidden: true,
          isPremium: false,
          advLabel: .adv
        ))
      }
    }
    
    DispatchQueue.main.async {
      completion(MainScreenModel(isDarkMode: nil,
                                 isPremium: false,
                                 allSections: allSections))
    }
  }
  
  func updateModelWith(
    oldModel: MainScreenModel,
    isPremium: Bool? = nil,
    completion: @escaping (MainScreenModel) -> Void) {
      updatesNewSectionForModel(models: oldModel.allSections) { [weak self] updatesNewSections in
        guard let self else {
          return
        }
        var cardSections: [MainScreenModel.Section] = []
        
        updatesNewSections.forEach { model in
          let isHidenSection = self.featureToggleServices.isHiddenToggleFor(section: model.type)
          let labelString = self.featureToggleServices.getLabelsFor(section: model.type)
          
          switch model.type {
          case .teams:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .number:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .yesOrNo:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .letter:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .list:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .coin:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .cube:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .dateAndTime:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .lottery:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .contact:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .password:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .colors:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .bottle:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .rockPaperScissors:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .imageFilters:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .films:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .nickName:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .names:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .congratulations:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .goodDeeds:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .riddles:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .joke:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .gifts:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .slogans:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .quotes:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .fortuneWheel:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .truthOrDare:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .memes:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: self.ifDebugFeatureSectionIsHidden(isHidenSection),
              isPremium: model.isPremium,
              advLabel: self.setLabelFrom(featureToggleRawValue: labelString, oldLabel: model.advLabel)
            ))
          case .adv1:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: !SecretsAPI.advFeatureCategoriesIsShow.adv1,
              isPremium: model.isPremium,
              advLabel: .adv,
              advDescription: model.advDescription,
              advStringURL: model.advStringURL
            ))
          case .adv2:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: !SecretsAPI.advFeatureCategoriesIsShow.adv2,
              isPremium: model.isPremium,
              advLabel: .adv,
              advDescription: model.advDescription,
              advStringURL: model.advStringURL
            ))
          case .adv3:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: !SecretsAPI.advFeatureCategoriesIsShow.adv3,
              isPremium: model.isPremium,
              advLabel: .adv,
              advDescription: model.advDescription,
              advStringURL: model.advStringURL
            ))
          case .adv4:
            cardSections.append(MainScreenModel.Section(
              type: model.type,
              isEnabled: model.isEnabled,
              isHidden: !SecretsAPI.advFeatureCategoriesIsShow.adv4,
              isPremium: model.isPremium,
              advLabel: .adv,
              advDescription: model.advDescription,
              advStringURL: model.advStringURL
            ))
          }
        }
        DispatchQueue.main.async {
          completion(MainScreenModel(isDarkMode: oldModel.isDarkMode,
                                     isPremium: isPremium ?? oldModel.isPremium,
                                     allSections: cardSections))
        }
      }
    }
  
  func ifDebugFeatureSectionIsHidden(_ isHidden: Bool) -> Bool {
#if DEBUG
    return false
#else
    return isHidden
#endif
  }
  
  func setLabelFrom(featureToggleRawValue: String?, oldLabel: MainScreenModel.ADVLabel) -> MainScreenModel.ADVLabel {
    guard let featureToggleRawValue else {
      return oldLabel
    }
    
    let featureToggleLabelType: MainScreenModel.ADVLabel
    switch featureToggleRawValue {
    case "hit":
      featureToggleLabelType = .hit
    case "new":
      featureToggleLabelType = .new
    case "":
      featureToggleLabelType = .none
    default:
      featureToggleLabelType = .custom(text: featureToggleRawValue)
    }
    return featureToggleLabelType
  }
}

// MARK: - Private func

private extension MainScreenFactory {
  func updatesNewSectionForModel(
    models: [MainScreenModel.Section],
    completion: @escaping ([MainScreenModel.Section]) -> Void
  ) {
    createBaseModel { baseModel in
      let allSections = baseModel.allSections
      var newModel = models
      
      for section in allSections {
        let oldSections = models.filter { $0.type == section.type }
        if oldSections.isEmpty {
          newModel.append(section)
        }
      }
      completion(newModel)
    }
  }
}

// MARK: - Appearance

private extension MainScreenFactory {
  struct Appearance {
    let keyUserDefaults = "main_screen_user_defaults_key"
  }
}
