//
//  MainSettingsScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//

import UIKit
import RandomUIKit

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
    
    tableViewModels.append(.squircleImageAndLabelWithSwitch(squircleBGColors: [RandomColor.only.primaryBlue,
                                                                               RandomColor.only.primaryBlue],
                                                            leftSideImage: appearance.darkThemeImage,
                                                            title: appearance.darkThemeTitle,
                                                            isEnabled: isDarkMode))
    tableViewModels.append(.divider)
    tableViewModels.append(.squircleImageAndLabelWithChevronCell(squircleBGColors: [RandomColor.only.primaryOrange,
                                                                                    RandomColor.only.primaryOrange],
                                                                 leftSideImage: appearance.customMainSectionsImage,
                                                                 title: appearance.customMainSectionsTitle,
                                                                 type: .customMainSections))
    tableViewModels.append(.divider)
    tableViewModels.append(.squircleImageAndLabelWithChevronCell(squircleBGColors: [RandomColor.only.primaryGreen,
                                                                                    RandomColor.only.primaryGreen],
                                                                 leftSideImage: appearance.applicationIconnImage,
                                                                 title: appearance.applicationIconTitle,
                                                                 type: .applicationIconSections))
    
    tableViewModels.append(.divider)
    tableViewModels.append(.squircleImageAndLabelWithChevronCell(squircleBGColors: [RandomColor.only.primaryPurple,
                                                                                    RandomColor.only.tertiaryBlue],
                                                                 leftSideImage: appearance.premiumImage,
                                                                 title: appearance.premiumTitle,
                                                                 type: .premiumSections))
    output?.didReceive(models: tableViewModels)
  }
}

// MARK: - Appearance

private extension MainSettingsScreenFactory {
  struct Appearance {
    let darkThemeImage = UIImage(systemName: "switch.2")?.pngData() ?? Data()
    let darkThemeTitle = NSLocalizedString("Тёмная тема", comment: "")
    
    let customMainSectionsImage = UIImage(systemName: "rectangle.grid.2x2")?.pngData() ?? Data()
    let customMainSectionsTitle = NSLocalizedString("Настройка секций", comment: "")
    
    let applicationIconnImage = UIImage(systemName: "rectangle.dashed")?.pngData() ?? Data()
    let applicationIconTitle = NSLocalizedString("Иконка приложения", comment: "")
    
    let premiumImage = UIImage(systemName: "star.fill")?.pngData() ?? Data()
    let premiumTitle = NSLocalizedString("Премиум", comment: "")
  }
}
