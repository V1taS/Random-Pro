//
//  SettingsScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 23.05.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol SettingsScreenFactoryOutput: AnyObject {
  
  /// Был получен массив моделек
  ///  - Parameter models: Массив моделек
  func didRecive(models: [Any])
  
  /// Был получен массив результатов
  ///  - Parameter listResult: Список результатов
  func didRecive(listResult: [String])
}

/// Cобытия которые отправляем от Presenter к Factory
protocol SettingsScreenFactoryInput {
  
  /// Получить массив моделей
  ///  - Parameter typeObject: Тип отображаемого контента
  func getContent(from typeObject: SettingsScreenType)
}

/// Фабрика
final class SettingsScreenFactory: SettingsScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: SettingsScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func getContent(from typeObject: SettingsScreenType) {
    var models: [Any] = []
    let screenModel = getScreenModel(from: typeObject)
    
    output?.didRecive(listResult: screenModel.listResult)
    models = configure(model: screenModel, typeObject: typeObject)
    output?.didRecive(models: models)
  }
}

// MARK: - Private

private extension SettingsScreenFactory {
  func getScreenModel(from typeObject: SettingsScreenType) -> SettingsScreenModel {
    switch typeObject {
    case .number(let result): return result
    case .films(let result): return result
    case .teams(let result): return result
    case .yesOrNo(let result): return result
    case .letter(let result): return result
    case .list(let result): return result
    case .coin(let result): return result
    case .cube(let result): return result
    case .dateAndTime(let result): return result
    case .lottery(let result): return result
    case .contact(let result): return result
    case .password(let result): return result
    case .russianLotto(let result): return result
    }
  }
  
  func configure(model: SettingsScreenModel, typeObject: SettingsScreenType) -> [Any] {
    let appearance = Appearance()
    var models: [Any] = []
    
    typeObject.allCasesIterable.forEach { caseIterable in
      switch caseIterable {
      case .withoutRepetition:
        let model = SettingsScreenType.WithoutRepetitionSettingsModel(
          title: appearance.withoutRepetitionTitle,
          isEnabled: model.isEnabledWithoutRepetition
        )
        models.append(model)
      case .itemsGenerated:
        let model = SettingsScreenType.CountGeneratedSettingsModel(
          title: appearance.countGeneratedTitle,
          countGeneratedText: "\(model.listResult.count)"
        )
        models.append(model)
      case .lastItem:
        let model = SettingsScreenType.LastObjectSettingsModel(
          title: appearance.latestGeneration,
          lastObjectText: model.result
        )
        models.append(model)
      case .listOfItems:
        if !model.listResult.isEmpty {
          let model = SettingsScreenType.ListOfObjectsSettingsModel(
            title: appearance.numberOfGenerations,
            asideImage: appearance.listOfNumbersIcon
          )
          models.append(model)
        }
      case .cleanButton:
        let model = SettingsScreenType.CleanButtonSettingsModel(
          title: appearance.cleanButtonTitle
        )
        models.append(model)
      }
    }
    return models
  }
}

// MARK: - Appearance

private extension SettingsScreenFactory {
  struct Appearance {
    let withoutRepetitionTitle = NSLocalizedString("Без повторений",
                                                   comment: "")
    let countGeneratedTitle = NSLocalizedString("Cгенерировано",
                                                comment: "")
    let latestGeneration = NSLocalizedString("Последняя генерация",
                                             comment: "")
    let cleanButtonTitle = NSLocalizedString("Очистить",
                                             comment: "")
    let listOfNumbersIcon = UIImage(systemName: "chevron.compact.right")
    
    let numberOfGenerations = NSLocalizedString("Список результатов",
                                                comment: "")
  }
}
