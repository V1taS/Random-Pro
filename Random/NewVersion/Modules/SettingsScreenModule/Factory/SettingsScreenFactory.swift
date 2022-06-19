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
  func didRecive(models: [SettingsScreenCell])
}

/// Cобытия которые отправляем от Presenter к Factory
protocol SettingsScreenFactoryInput {
  
  /// Получить массив моделей
  ///  - Parameter model: Модель данных
  func getContentFrom(model: SettingsScreenModel)
}

/// Фабрика
final class SettingsScreenFactory: SettingsScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: SettingsScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func getContentFrom(model: SettingsScreenModel) {
    var models: [SettingsScreenCell] = []
    
    SettingsScreenCell.allCases.forEach { cell in
      switch cell {
      case .withoutRepetition:
        let model = SettingsScreenCell.withoutRepetition(
          SettingsScreenCell.WithoutRepetitionModel(title: "Без повторений",
                                                    isOn: model.isNoRepetition)
        )
        models.append(model)
      case .numbersGenerated:
        let model = SettingsScreenCell.numbersGenerated(
          SettingsScreenCell.NumbersGeneratedModel(primaryText: "Чисел сгенерировано",
                                                   secondaryText: "\(model.listResult.count)")
        )
        models.append(model)
      case .lastNumber:
        let model = SettingsScreenCell.lastNumber(
          SettingsScreenCell.LastNumberModel(primaryText: "Последнее число",
                                             secondaryText: model.result)
        )
        models.append(model)
      case .listOfNumbers:
        let model = SettingsScreenCell.listOfNumbers(
          SettingsScreenCell.ListOfNumbersModel(title: "Список чисел",
                                                asideImage: nil)
        )
        models.append(model)
      case .cleanButton:
        let model = SettingsScreenCell.cleanButton("Очистить")
        models.append(model)
      case .padding:
        let model = SettingsScreenCell.padding(8)
        models.append(model)
      }
    }
    output?.didRecive(models: models)
  }
}

// MARK: - Appearance

private extension SettingsScreenFactory {
  struct Appearance {
    
  }
}
