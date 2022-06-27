//
//  ListResultScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.06.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol ListResultScreenFactoryOutput: AnyObject {
  
  /// Был получен массив моделек
  ///  - Parameter models: Массив моделек
  func didRecive(models: [Any])
  
  /// Был получен заголовок экрана
  ///  - Parameter title: Заголовок экрана
  func didRecive(title: String)
}

/// Cобытия которые отправляем от Presenter к Factory
protocol ListResultScreenFactoryInput {
  
  /// Получить массив моделей
  ///  - Parameter typeObject: Тип отображаемого контента
  func getContent(from typeObject: ListResultScreenType)
}

/// Фабрика
final class ListResultScreenFactory: ListResultScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: ListResultScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func getContent(from typeObject: ListResultScreenType) {
    let appearance = Appearance()
    var models: [Any] = []
    
    switch typeObject {
    case .films: break
    case .teams: break
    case .number(list: let list):
      models = list
      output?.didRecive(title: appearance.numberTitle)
    case .yesOrNo:
      output?.didRecive(title: appearance.numberTitle)
    case .character: break
    case .list: break
    case .coin: break
    case .cube: break
    case .dateAndTime: break
    case .lottery: break
    case .contact: break
    case .password: break
    case .russianLotto: break
    }
    output?.didRecive(models: models)
  }
}

// MARK: - Appearance

private extension ListResultScreenFactory {
  struct Appearance {
    let numberTitle = NSLocalizedString("Список результатов", comment: "")
  }
}
