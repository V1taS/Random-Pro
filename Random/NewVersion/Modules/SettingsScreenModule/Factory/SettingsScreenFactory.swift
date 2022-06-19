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
    let appearance = Appearance()
    var models: [Any] = []
    
    switch typeObject {
    case .number(let result):
      output?.didRecive(listResult: result.listResult)
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
          if !result.listResult.isEmpty {
            let model = ListOfObjectsSettingsModel(title: appearance.listOfNumbersTitle,
                                                   asideImage: appearance.listOfNumbersIcon)
            models.append(model)
          }
        case .cleanButton:
          let model = CleanButtonSettingsModel(title: appearance.cleanButtonTitle)
          models.append(model)
        }
      }
    case .films(_): break
    case .teams(_): break
    case .yesOrNo(_): break
    case .character(_): break
    case .list(_): break
    case .coin(_): break
    case .cube(_): break
    case .dateAndTime(_): break
    case .lottery(_): break
    case .contact(_): break
    case .password(_): break
    case .russianLotto(_): break
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
