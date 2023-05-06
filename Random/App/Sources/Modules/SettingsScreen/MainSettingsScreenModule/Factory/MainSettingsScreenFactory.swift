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
    DispatchQueue.global(qos: .userInitiated).async {
      let appearance = Appearance()
      var tableViewModels: [MainSettingsScreenType] = []
      
      tableViewModels.append(.squircleImageAndLabelWithSwitch(squircleBGColors: [RandomColor.only.primaryBlue,
                                                                                 RandomColor.only.primaryBlue],
                                                              leftSideImageSystemName: appearance.darkThemeImageSystemName,
                                                              title: appearance.darkThemeTitle,
                                                              isEnabled: isDarkMode))
      tableViewModels.append(.divider)
      tableViewModels.append(.squircleImageAndLabelWithChevronCell(squircleBGColors: [RandomColor.only.primaryOrange,
                                                                                      RandomColor.only.primaryOrange],
                                                                   leftSideImageSystemName: appearance.customMainSectionsImageSystemName,
                                                                   title: appearance.customMainSectionsTitle,
                                                                   type: .customMainSections))
      tableViewModels.append(.divider)
      tableViewModels.append(.squircleImageAndLabelWithChevronCell(squircleBGColors: [RandomColor.only.primaryGreen,
                                                                                      RandomColor.only.primaryGreen],
                                                                   leftSideImageSystemName: appearance.applicationIconnImageSystemName,
                                                                   title: appearance.applicationIconTitle,
                                                                   type: .applicationIconSections))
      
      tableViewModels.append(.divider)
      tableViewModels.append(.squircleImageAndLabelWithChevronCell(squircleBGColors: [RandomColor.only.primaryPurple,
                                                                                      RandomColor.only.tertiaryBlue],
                                                                   leftSideImageSystemName: appearance.premiumImageSystemName,
                                                                   title: appearance.premiumTitle,
                                                                   type: .premiumSections))
      DispatchQueue.main.async { [weak self] in
        self?.output?.didReceive(models: tableViewModels)
      }
    }
  }
}

// MARK: - Appearance

private extension MainSettingsScreenFactory {
  struct Appearance {
    let darkThemeImageSystemName = "switch.2"
    let darkThemeTitle = RandomStrings.Localizable.darkTheme
    
    let customMainSectionsImageSystemName = "rectangle.grid.2x2"
    let customMainSectionsTitle = RandomStrings.Localizable.sectionSettings
    
    let applicationIconnImageSystemName = "rectangle.dashed"
    let applicationIconTitle = RandomStrings.Localizable.appIcon
    
    let premiumImageSystemName = "star.fill"
    let premiumTitle = RandomStrings.Localizable.premium
  }
}
