//
//  OnboardingScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 17.09.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol OnboardingScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol OnboardingScreenFactoryInput {
  
  /// Создать модель для онбоардинга
  static func createOnboardingModels() -> [OnboardingScreenModel]
}

/// Фабрика
final class OnboardingScreenFactory: OnboardingScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: OnboardingScreenFactoryOutput?
  
  // MARK: - Internal func
  
  static func createOnboardingModels() -> [OnboardingScreenModel] {
    var pages: [OnboardingScreenModel] = []
    let appearance = Appearance()
    
    OnboardingScreenModel.Page.allCases.forEach { page in
      switch page {
      case .darkTheme:
        pages.append(OnboardingScreenModel(
          title: appearance.darkThemeTitle + " 🥳",
          description: appearance.darkThemeDescription,
          image: appearance.darkThemeImage,
          page: page,
          isViewed: false
        ))
      case .customSections:
        pages.append(OnboardingScreenModel(
          title: appearance.customSectionsTitle,
          description: appearance.customSectionsDescription,
          image: appearance.customSectionsImage,
          page: page,
          isViewed: false
        ))
      }
    }
    return pages
  }
}

// MARK: - Appearance

private extension OnboardingScreenFactory {
  struct Appearance {
    let darkThemeTitle = NSLocalizedString("Добавили темную тему", comment: "")
    let darkThemeDescription = NSLocalizedString("Подключить: \n Главный экран -> Настройки -> Темная тема",
                                                 comment: "")
    let darkThemeImage = UIImage(named: "onboarding_darkTheme")?.pngData()
    
    let customSectionsTitle = NSLocalizedString("Добавили настройку секций", comment: "")
    let customSectionsDescription = NSLocalizedString("Главный экран -> Настройки -> Настройка секций",
                                                      comment: "")
    let customSectionsImage = UIImage(named: "onboarding_customSections")?.pngData()
  }
}
