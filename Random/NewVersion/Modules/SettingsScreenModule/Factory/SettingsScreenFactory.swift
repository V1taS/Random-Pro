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
    let appearance = Appearance()
    var models: [Any] = []
    
    switch typeObject {
    case .number(let result):
      SettingsScreenType.NumberCaseIterable.allCases.forEach { caseIterable in
        switch caseIterable {
        case .withoutRepetition:
          let model = WithoutRepetitionSettingsModel(title: appearance.withoutRepetitionTitle,
                                                     isEnabled: result.isEnabledWithoutRepetition)
          models.append(model)
        case .numbersGenerated:
          let model = CountGeneratedSettingsModel(title: appearance.countGeneratedTitle,
                                                  countGeneratedText: result.numbersGenerated)
          models.append(model)
        case .lastNumber:
          let model = LastObjectSettingsModel(title: appearance.lastObjectTitle,
                                              lastObjectText: result.lastNumber)
          models.append(model)
        case .listOfNumbers:
          let model = ListOfObjectsSettingsModel(title: appearance.listOfNumbersTitle,
                                                 asideImage: appearance.listOfNumbersIcon)
          models.append(model)
        case .cleanButton:
          let model = CleanButtonSettingsModel(title: appearance.cleanButtonTitle)
          models.append(model)
        }
      }
    }
    output?.didRecive(models: models)
  }
}

// MARK: - Appearance

private extension SettingsScreenFactory {
  struct Appearance {
    let withoutRepetitionTitle = NSLocalizedString("Без повторений",
                                                   comment: "")
    let countGeneratedTitle = NSLocalizedString("Чисел сгенерировано",
                                                comment: "")
    let lastObjectTitle = NSLocalizedString("Последнее число",
                                            comment: "")
    let cleanButtonTitle = NSLocalizedString("Очистить",
                                             comment: "")
    let listOfNumbersIcon = UIImage(systemName: "chevron.compact.right")
    
    let listOfNumbersTitle = NSLocalizedString("Список чисел",
                                               comment: "")
  }
}
