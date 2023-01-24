//
//  MainSettingsScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol MainSettingsScreenFactoryOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter models: результат генерации для таблички
  func didReceive(models: [MainSettingsScreenType])
}

/// Cобытия которые отправляем от Presenter к Factory
protocol MainSettingsScreenFactoryInput {
  
  /// Создаем модельку для таблички
  ///  - Parameter isDarkMode: Текущей цвет темы
  func createListModelWith(isDarkMode: Bool)
}

/// Фабрика
final class MainSettingsScreenFactory: MainSettingsScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: MainSettingsScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func createListModelWith(isDarkMode: Bool) {
    let appearance = Appearance()
    var tableViewModels: [MainSettingsScreenType] = []
    
    tableViewModels.append(.titleAndSwitcher(title: appearance.darkThemeTitle,
                                             isEnabled: isDarkMode))
    tableViewModels.append(.divider)
    tableViewModels.append(.titleAndChevron(title: appearance.customMainSectionsTitle,
                                            type: .customMainSections))
    tableViewModels.append(.divider)
    tableViewModels.append(.titleAndChevron(title: appearance.premiumTitle,
                                            type: .premiumSections))
    output?.didReceive(models: tableViewModels)
  }
}

// MARK: - Appearance

private extension MainSettingsScreenFactory {
  struct Appearance {
    let darkThemeTitle = NSLocalizedString("Тёмная тема",
                                           comment: "")
    let customMainSectionsTitle = NSLocalizedString("Настройка секций",
                                                    comment: "")
    let premiumTitle = NSLocalizedString("Премиум",
                                         comment: "")
  }
}
