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
  ///  - Parameters:
  ///   - model: Модель данных
  ///   - isPremiumWithFriends: Реферальная программа
  func createListModelWith(model: MainSettingsScreenModel, isPremiumWithFriends: Bool)
}

/// Фабрика
final class MainSettingsScreenFactory: MainSettingsScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: MainSettingsScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func createListModelWith(model: MainSettingsScreenModel,
                           isPremiumWithFriends: Bool) {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      guard let self else {
        return
      }
      
      let appearance = Appearance()
      var tableViewModels: [MainSettingsScreenType] = []
      
      var startSegmentIndex: Int {
        guard let isDarkMode = model.isDarkMode else {
          return 0
        }
        return isDarkMode ? 1 : 2
      }
      
#if DEBUG
      tableViewModels.append(.squircleImageAndLabelWithSwitchControl(
        squircleBGColors: [RandomColor.only.primaryRed,
                           RandomColor.only.primaryPink],
        leftSideImage: appearance.primiumDEBUGImage,
        leftSideImageColor: RandomColor.only.primaryWhite,
        titleText: appearance.primiumDEBUGTitle,
        isResultSwitch: model.isPremium
      ))
#endif
      
      tableViewModels.append(.squircleImageAndLabelWithSegmentedControl(
        squircleBGColors: [RandomColor.only.primaryBlue,
                           RandomColor.only.primaryBlue],
        leftSideImageSystemName: appearance.darkThemeImageSystemName,
        title: appearance.darkThemeTitle,
        startSelectedSegmentIndex: startSegmentIndex
      ))
      tableViewModels.append(.divider)
      
      tableViewModels.append(.squircleImageAndLabelWithChevronCell(
        squircleBGColors: [RandomColor.only.primaryOrange,
                           RandomColor.only.primaryOrange],
        leftSideImageSystemName: appearance.customMainSectionsImageSystemName,
        title: appearance.customMainSectionsTitle,
        type: .customMainSections
      ))
      tableViewModels.append(.divider)
      
      tableViewModels.append(.squircleImageAndLabelWithChevronCell(
        squircleBGColors: [RandomColor.only.primaryGreen,
                           RandomColor.only.primaryGreen],
        leftSideImageSystemName: appearance.applicationIconnImageSystemName,
        title: appearance.applicationIconTitle,
        type: .applicationIconSections
      ))
      tableViewModels.append(.divider)
      
      tableViewModels.append(.squircleImageAndLabelWithChevronCell(
        squircleBGColors: [RandomColor.only.primaryPurple,
                           RandomColor.only.tertiaryBlue],
        leftSideImageSystemName: appearance.premiumImageSystemName,
        title: appearance.premiumTitle,
        type: .premiumSections
      ))
      tableViewModels.append(.divider)
      
      if isPremiumWithFriends || self.isDebug() {
        tableViewModels.append(.squircleImageAndLabelWithChevronCell(
          squircleBGColors: [RandomColor.only.primaryRed,
                             RandomColor.only.primaryPink],
          leftSideImageSystemName: appearance.premiumWithFriendsImageSystemName,
          title: appearance.premiumWithFriendsTitle,
          type: .premiumWithFriends
        ))
        tableViewModels.append(.divider)
      }
      
      tableViewModels.append(.squircleImageAndLabelWithChevronCell(
        squircleBGColors: [RandomColor.only.secondaryGray,
                           RandomColor.only.secondaryGray],
        leftSideImageSystemName: appearance.shareImageSystemName,
        title: appearance.shareTitle,
        type: .shareSections
      ))
      
      DispatchQueue.main.async { [weak self] in
        self?.output?.didReceive(models: tableViewModels)
      }
    }
  }
}

// MARK: - Appearance

private extension MainSettingsScreenFactory {
  func isDebug() -> Bool {
#if DEBUG
    return true
#else
    return false
#endif
  }
}

// MARK: - Appearance

private extension MainSettingsScreenFactory {
  struct Appearance {
    let darkThemeImageSystemName = "paintbrush.fill"
    let darkThemeTitle = RandomStrings.Localizable.theme
    
    let customMainSectionsImageSystemName = "rectangle.grid.2x2"
    let customMainSectionsTitle = RandomStrings.Localizable.sectionSettings
    
    let applicationIconnImageSystemName = "rectangle.dashed"
    let applicationIconTitle = RandomStrings.Localizable.appIcon
    
    let premiumImageSystemName = "star.fill"
    let premiumTitle = RandomStrings.Localizable.premium
    
    let primiumDEBUGImage = UIImage(systemName: "p.square")
    let primiumDEBUGTitle = RandomStrings.Localizable.premium
    
    let shareImageSystemName = "square.and.arrow.up"
    let shareTitle = RandomStrings.Localizable.share
    
    let premiumWithFriendsImageSystemName = "link"
    let premiumWithFriendsTitle = RandomStrings.Localizable.premiumWithFriends
  }
}
