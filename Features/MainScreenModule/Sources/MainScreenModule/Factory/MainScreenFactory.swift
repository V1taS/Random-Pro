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
    let modelAllSections = (model.allSections as? [MainScreenModel.Section]) ?? []
    let allSections: [MainScreenModel.Section] = modelAllSections.filter { $0.isEnabled && !$0.isHidden }
    let newModel = MainScreenModel(isDarkMode: model.isDarkMode,
                                   isPremium: model.isPremium,
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
            imageSectionSystemName: section.imageSectionSystemName,
            titleSection: section.titleSection,
            isEnabled: true,
            isHidden: false,
            advLabel: .none
          ))
        case .number:
          allSections.append(MainScreenModel.Section(
            type: section,
            imageSectionSystemName: section.imageSectionSystemName,
            titleSection: section.titleSection,
            isEnabled: true,
            isHidden: false,
            advLabel: .none
          ))
        case .yesOrNo:
          allSections.append(MainScreenModel.Section(
            type: section,
            imageSectionSystemName: section.imageSectionSystemName,
            titleSection: section.titleSection,
            isEnabled: true,
            isHidden: false,
            advLabel: .none
          ))
        case .letter:
          allSections.append(MainScreenModel.Section(
            type: section,
            imageSectionSystemName: section.imageSectionSystemName,
            titleSection: section.titleSection,
            isEnabled: true,
            isHidden: false,
            advLabel: .none
          ))
        case .list:
          allSections.append(MainScreenModel.Section(
            type: section,
            imageSectionSystemName: section.imageSectionSystemName,
            titleSection: section.titleSection,
            isEnabled: true,
            isHidden: false,
            advLabel: .none
          ))
        case .coin:
          allSections.append(MainScreenModel.Section(
            type: section,
            imageSectionSystemName: section.imageSectionSystemName,
            titleSection: section.titleSection,
            isEnabled: true,
            isHidden: false,
            advLabel: .none
          ))
        case .cube:
          allSections.append(MainScreenModel.Section(
            type: section,
            imageSectionSystemName: section.imageSectionSystemName,
            titleSection: section.titleSection,
            isEnabled: true,
            isHidden: false,
            advLabel: .none
          ))
        case .dateAndTime:
          allSections.append(MainScreenModel.Section(
            type: section,
            imageSectionSystemName: section.imageSectionSystemName,
            titleSection: section.titleSection,
            isEnabled: true,
            isHidden: false,
            advLabel: .none
          ))
        case .lottery:
          allSections.append(MainScreenModel.Section(
            type: section,
            imageSectionSystemName: section.imageSectionSystemName,
            titleSection: section.titleSection,
            isEnabled: true,
            isHidden: false,
            advLabel: .none
          ))
        case .contact:
          allSections.append(MainScreenModel.Section(
            type: section,
            imageSectionSystemName: section.imageSectionSystemName,
            titleSection: section.titleSection,
            isEnabled: true,
            isHidden: false,
            advLabel: .none
          ))
        case .password:
          allSections.append(MainScreenModel.Section(
            type: section,
            imageSectionSystemName: section.imageSectionSystemName,
            titleSection: section.titleSection,
            isEnabled: true,
            isHidden: false,
            advLabel: .none
          ))
        case .colors:
          allSections.append(MainScreenModel.Section(
            type: section,
            imageSectionSystemName: section.imageSectionSystemName,
            titleSection: section.titleSection,
            isEnabled: true,
            isHidden: false,
            advLabel: .none
          ))
        case .bottle:
          allSections.append(MainScreenModel.Section(
            type: section,
            imageSectionSystemName: section.imageSectionSystemName,
            titleSection: section.titleSection,
            isEnabled: true,
            isHidden: false,
            advLabel: .new
          ))
        case .rockPaperScissors:
          allSections.append(MainScreenModel.Section(
            type: section,
            imageSectionSystemName: section.imageSectionSystemName,
            titleSection: section.titleSection,
            isEnabled: true,
            isHidden: false,
            advLabel: .premium
          ))
        case .imageFilters:
          allSections.append(MainScreenModel.Section(
            type: section,
            imageSectionSystemName: section.imageSectionSystemName,
            titleSection: section.titleSection,
            isEnabled: true,
            isHidden: false,
            advLabel: .premium
          ))
        case .films:
          allSections.append(MainScreenModel.Section(
            type: section,
            imageSectionSystemName: section.imageSectionSystemName,
            titleSection: section.titleSection,
            isEnabled: true,
            isHidden: false,
            advLabel: .premium
          ))
        }
      }
      
      DispatchQueue.main.async {
        completion(MainScreenModel(isDarkMode: nil,
                                   isPremium: false,
                                   allSections: allSections))
      }
    }
  }
  
  static func updateModelWith(
    oldModel: MainScreenModel,
    featureToggleModel: SectionsIsHiddenFTModelProtocol? = nil,
    labelsModel: LabelsFeatureToggleModelProtocol? = nil,
    isPremium: Bool? = nil,
    completion: @escaping (MainScreenModel) -> Void) {
      DispatchQueue.global(qos: .userInteractive).async {
        let oldModelAllSections: [MainScreenModel.Section] = (oldModel.allSections as? [MainScreenModel.Section]) ?? []
        updatesNewSectionForModel(models: oldModelAllSections) { updatesNewSections in
          var cardSections: [MainScreenModel.Section] = []
          
          updatesNewSections.forEach { model in
            let sectionType = (model.type as? MainScreenModel.SectionType) ?? .bottle
            let advLabel = (model.advLabel as? MainScreenModel.ADVLabel) ?? .none
            switch sectionType {
            case .teams:
              cardSections.append(MainScreenModel.Section(
                type: sectionType,
                imageSectionSystemName: model.imageSectionSystemName,
                titleSection: model.type.titleSection,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.teams) ?? model.isHidden,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.teams ?? advLabel.rawValue)
              ))
            case .number:
              cardSections.append(MainScreenModel.Section(
                type: sectionType,
                imageSectionSystemName: model.imageSectionSystemName,
                titleSection: model.type.titleSection,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.number) ?? model.isHidden,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.number ?? advLabel.rawValue)
              ))
            case .yesOrNo:
              cardSections.append(MainScreenModel.Section(
                type: sectionType,
                imageSectionSystemName: model.imageSectionSystemName,
                titleSection: model.type.titleSection,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.yesOrNo) ?? model.isHidden,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.yesOrNo ?? advLabel.rawValue)
              ))
            case .letter:
              cardSections.append(MainScreenModel.Section(
                type: sectionType,
                imageSectionSystemName: model.imageSectionSystemName,
                titleSection: model.type.titleSection,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.letter) ?? model.isHidden,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.letter ?? advLabel.rawValue)
              ))
            case .list:
              cardSections.append(MainScreenModel.Section(
                type: sectionType,
                imageSectionSystemName: model.imageSectionSystemName,
                titleSection: model.type.titleSection,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.list) ?? model.isHidden,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.list ?? advLabel.rawValue)
              ))
            case .coin:
              cardSections.append(MainScreenModel.Section(
                type: sectionType,
                imageSectionSystemName: model.imageSectionSystemName,
                titleSection: model.type.titleSection,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.coin) ?? model.isHidden,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.coin ?? advLabel.rawValue)
              ))
            case .cube:
              cardSections.append(MainScreenModel.Section(
                type: sectionType,
                imageSectionSystemName: model.imageSectionSystemName,
                titleSection: model.type.titleSection,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.cube) ?? model.isHidden,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.cube ?? advLabel.rawValue)
              ))
            case .dateAndTime:
              cardSections.append(MainScreenModel.Section(
                type: sectionType,
                imageSectionSystemName: model.imageSectionSystemName,
                titleSection: model.type.titleSection,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.dateAndTime) ?? model.isHidden,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.dateAndTime ?? advLabel.rawValue)
              ))
            case .lottery:
              cardSections.append(MainScreenModel.Section(
                type: sectionType,
                imageSectionSystemName: model.imageSectionSystemName,
                titleSection: model.type.titleSection,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.lottery) ?? model.isHidden,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.lottery ?? advLabel.rawValue)
              ))
            case .contact:
              cardSections.append(MainScreenModel.Section(
                type: sectionType,
                imageSectionSystemName: model.imageSectionSystemName,
                titleSection: model.type.titleSection,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.contact) ?? model.isHidden,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.contact ?? advLabel.rawValue)
              ))
            case .password:
              cardSections.append(MainScreenModel.Section(
                type: sectionType,
                imageSectionSystemName: model.imageSectionSystemName,
                titleSection: model.type.titleSection,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.password) ?? model.isHidden,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.password ?? advLabel.rawValue)
              ))
            case .colors:
              cardSections.append(MainScreenModel.Section(
                type: sectionType,
                imageSectionSystemName: model.imageSectionSystemName,
                titleSection: model.type.titleSection,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.colors) ?? model.isHidden,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.colors ?? advLabel.rawValue)
              ))
            case .bottle:
              cardSections.append(MainScreenModel.Section(
                type: sectionType,
                imageSectionSystemName: model.imageSectionSystemName,
                titleSection: model.type.titleSection,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.bottle) ?? model.isHidden,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.bottle ?? advLabel.rawValue)
              ))
            case .rockPaperScissors:
              cardSections.append(MainScreenModel.Section(
                type: sectionType,
                imageSectionSystemName: model.imageSectionSystemName,
                titleSection: model.type.titleSection,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.rockPaperScissors) ?? model.isHidden,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.rockPaperScissors ?? advLabel.rawValue,
                                       oldADVLabel: .premium)
              ))
            case .imageFilters:
              cardSections.append(MainScreenModel.Section(
                type: sectionType,
                imageSectionSystemName: model.imageSectionSystemName,
                titleSection: model.type.titleSection,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.imageFilters) ?? model.isHidden,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.imageFilters ?? advLabel.rawValue,
                                       oldADVLabel: .premium)
              ))
            case .films:
              cardSections.append(MainScreenModel.Section(
                type: sectionType,
                imageSectionSystemName: model.imageSectionSystemName,
                titleSection: model.type.titleSection,
                isEnabled: model.isEnabled,
                isHidden: ifDebugFeatureSectionIsHidden(featureToggleModel?.films) ?? model.isHidden,
                advLabel: setLabelFrom(featureToggleRawValue: labelsModel?.films ?? advLabel.rawValue,
                                       oldADVLabel: .premium)
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
                           oldADVLabel: MainScreenModel.ADVLabel = .none) -> MainScreenModel.ADVLabel {
    let featureToggleLabelType = MainScreenModel.ADVLabel(rawValue: featureToggleRawValue ?? "")
    switch oldADVLabel {
    case .premium:
      return .premium
    default:
      return featureToggleLabelType ?? oldADVLabel
    }
  }
}

// MARK: - Private func

private extension MainScreenFactory {
  static func updatesNewSectionForModel(
    models: [MainScreenModel.Section],
    completion: @escaping ([MainScreenModel.Section]) -> Void
  ) {
    createBaseModel { baseModel in
      let allSections = (baseModel.allSections as? [MainScreenModel.Section]) ?? []
      var newModel = models
      
      for section in allSections { 
        let oldSections = models.filter {
          $0.type as? MainScreenModel.SectionType == section.type as? MainScreenModel.SectionType
        }
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