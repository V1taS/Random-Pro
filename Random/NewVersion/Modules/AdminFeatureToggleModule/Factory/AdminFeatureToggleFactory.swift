//
//  AdminFeatureToggleFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.07.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol AdminFeatureToggleFactoryOutput: AnyObject {
  
  /// Получены модели для ячейки
  ///  - Parameter models: Список моделей
  func didRecive(models: [AdminFeatureToggleModel])
}

/// Cобытия которые отправляем от Presenter к Factory
protocol AdminFeatureToggleFactoryInput {
  
  /// Создать список моделей для ячеек
  ///  - Parameter featureToggles: Список фича тоглов
  func createModelsFrom(featureToggles: [MainScreenCellModel.MainScreenCell])
}

/// Фабрика
final class AdminFeatureToggleFactory: AdminFeatureToggleFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: AdminFeatureToggleFactoryOutput?
  
  // MARK: - Internal func
  
  func createModelsFrom(featureToggles: [MainScreenCellModel.MainScreenCell]) {
    var models: [AdminFeatureToggleModel] = []
    
    featureToggles.forEach { featureToggle in
      switch featureToggle {
      case .films(advLabel: let advLabel, isEnabled: let isEnabled):
        models.append(configureModel(
          sectionName: "Films",
          advLabel: advLabel,
          isEnabled: isEnabled)
        )
      case .teams(advLabel: let advLabel, isEnabled: let isEnabled):
        models.append(configureModel(
          sectionName: "Teams",
          advLabel: advLabel,
          isEnabled: isEnabled)
        )
      case .number(advLabel: let advLabel, isEnabled: let isEnabled):
        models.append(configureModel(
          sectionName: "Number",
          advLabel: advLabel,
          isEnabled: isEnabled)
        )
      case .yesOrNo(advLabel: let advLabel, isEnabled: let isEnabled):
        models.append(configureModel(
          sectionName: "Yer or No",
          advLabel: advLabel,
          isEnabled: isEnabled)
        )
      case .letter(advLabel: let advLabel, isEnabled: let isEnabled):
        models.append(configureModel(
          sectionName: "Letter",
          advLabel: advLabel,
          isEnabled: isEnabled)
        )
      case .list(advLabel: let advLabel, isEnabled: let isEnabled):
        models.append(configureModel(
          sectionName: "List",
          advLabel: advLabel,
          isEnabled: isEnabled)
        )
      case .coin(advLabel: let advLabel, isEnabled: let isEnabled):
        models.append(configureModel(
          sectionName: "Coin",
          advLabel: advLabel,
          isEnabled: isEnabled)
        )
      case .cube(advLabel: let advLabel, isEnabled: let isEnabled):
        models.append(configureModel(
          sectionName: "Cube",
          advLabel: advLabel,
          isEnabled: isEnabled)
        )
      case .dateAndTime(advLabel: let advLabel, isEnabled: let isEnabled):
        models.append(configureModel(
          sectionName: "Date and Time",
          advLabel: advLabel,
          isEnabled: isEnabled)
        )
      case .lottery(advLabel: let advLabel, isEnabled: let isEnabled):
        models.append(configureModel(
          sectionName: "Lottery",
          advLabel: advLabel,
          isEnabled: isEnabled)
        )
      case .contact(advLabel: let advLabel, isEnabled: let isEnabled):
        models.append(configureModel(
          sectionName: "Contact",
          advLabel: advLabel,
          isEnabled: isEnabled)
        )
      case .password(advLabel: let advLabel, isEnabled: let isEnabled):
        models.append(configureModel(
          sectionName: "Password",
          advLabel: advLabel,
          isEnabled: isEnabled)
        )
      }
    }
    output?.didRecive(models: models)
  }
}

// MARK: - Private

private extension AdminFeatureToggleFactory {
  func configureModel(sectionName: String,
                      advLabel: MainScreenCellModel.MainScreenCell.ADVLabel,
                      isEnabled: Bool) -> AdminFeatureToggleModel {
    
    let advLabels = MainScreenCellModel.MainScreenCell.ADVLabel.allCases
    let currentIndexADVLabels = advLabels.firstIndex(of: advLabel) ?? .zero
    let model = AdminFeatureToggleModel(
      sectionName: sectionName,
      advLabels: advLabels,
      currentIndexADVLabels: currentIndexADVLabels,
      isFeatureToggle: isEnabled
    )
    return model
  }
}

// MARK: - Appearance

private extension AdminFeatureToggleFactory {
  struct Appearance {
    
  }
}
