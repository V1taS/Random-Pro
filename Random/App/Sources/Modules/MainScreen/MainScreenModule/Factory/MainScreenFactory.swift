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
                                   isFirstVisit: model.isFirstVisit,
                                   allSections: allSections)
    output?.didReceiveNew(model: newModel)
  }
}

// MARK: - Static func

extension MainScreenFactory {
  static func createBaseModel(completion: @escaping (MainScreenModel) -> Void) {
    DispatchQueue.global(qos: .userInteractive).async {
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
        }
      }
      
      DispatchQueue.main.async {
        completion(MainScreenModel(isDarkMode: nil,
                                   isPremium: false,
                                   isFirstVisit: true,
                                   allSections: allSections))
      }
    }
  }
  
  static func updateModelWith(
    oldModel: MainScreenModel,
    featureToggleModel: SectionsIsHiddenFTModel? = nil,
    labelsModel: LabelsFeatureToggleModel? = nil,
    isPremium: Bool? = nil,
    completion: @escaping (MainScreenModel) -> Void) {
      DispatchQueue.global(qos: .userInteractive).async {
        updatesNewSectionForModel(models: oldModel.allSections) { updatesNewSections in
          var cardSections: [MainScreenModel.Section] = []
          
          updatesNewSections.forEach { model in
            switch model.type {
            case .teams:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.teams) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.teams, oldLabel: model.advLabel)
              ))
            case .number:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.number) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.number, oldLabel: model.advLabel)
              ))
            case .yesOrNo:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.yesOrNo) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.yesOrNo, oldLabel: model.advLabel)
              ))
            case .letter:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.letter) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.letter, oldLabel: model.advLabel)
              ))
            case .list:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.list) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.list, oldLabel: model.advLabel)
              ))
            case .coin:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.coin) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.coin, oldLabel: model.advLabel)
              ))
            case .cube:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.cube) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.cube, oldLabel: model.advLabel)
              ))
            case .dateAndTime:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.dateAndTime) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.dateAndTime, oldLabel: model.advLabel)
              ))
            case .lottery:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.lottery) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.lottery, oldLabel: model.advLabel)
              ))
            case .contact:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.contact) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.contact, oldLabel: model.advLabel)
              ))
            case .password:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.password) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.password, oldLabel: model.advLabel)
              ))
            case .colors:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.colors) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.colors, oldLabel: model.advLabel)
              ))
            case .bottle:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.bottle) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.bottle, oldLabel: model.advLabel)
              ))
            case .rockPaperScissors:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.rockPaperScissors) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.rockPaperScissors, oldLabel: model.advLabel)
              ))
            case .imageFilters:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.imageFilters) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.imageFilters, oldLabel: model.advLabel)
              ))
            case .films:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.films) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.films, oldLabel: model.advLabel)
              ))
            case .nickName:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.nickName) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.nickName, oldLabel: model.advLabel)
              ))
            case .names:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.names) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.names, oldLabel: model.advLabel)
              ))
            case .congratulations:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.congratulations) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.congratulations, oldLabel: model.advLabel)
              ))
            case .goodDeeds:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.goodDeeds) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.goodDeeds, oldLabel: model.advLabel)
              ))
            case .riddles:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.riddles) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.riddles, oldLabel: model.advLabel)
              ))
            case .joke:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.joke) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.joke, oldLabel: model.advLabel)
              ))
            case .gifts:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.gifts) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.gifts, oldLabel: model.advLabel)
              ))
            case .slogans:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.slogans) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.slogans, oldLabel: model.advLabel)
              ))
            case .quotes:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.quotes) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.quotes, oldLabel: model.advLabel)
              ))
            case .fortuneWheel:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.fortuneWheel) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.fortuneWheel, oldLabel: model.advLabel)
              ))
            case .truthOrDare:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.truthOrDare) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.truthOrDare, oldLabel: model.advLabel)
              ))
            case .memes:
              cardSections.append(MainScreenModel.Section(
                type: model.type,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.memes) ?? model.isHidden,
                isPremium: model.isPremium,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.memes, oldLabel: model.advLabel)
              ))
            }
          }
          DispatchQueue.main.async {
            completion(MainScreenModel(isDarkMode: oldModel.isDarkMode,
                                       isPremium: isPremium ?? oldModel.isPremium,
                                       isFirstVisit: oldModel.isFirstVisit,
                                       allSections: cardSections))
          }
        }
      }
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
  
  static func setLabelFrom(featureToggleRawValue: String?, oldLabel: MainScreenModel.ADVLabel) -> MainScreenModel.ADVLabel {
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
  static func updatesNewSectionForModel(
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
