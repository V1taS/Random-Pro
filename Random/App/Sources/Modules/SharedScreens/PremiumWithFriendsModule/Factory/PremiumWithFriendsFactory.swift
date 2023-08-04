//
//  PremiumWithFriendsFactory.swift
//  Random
//
//  Created by Vitalii Sosin on 24.07.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol PremiumWithFriendsFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol PremiumWithFriendsFactoryInput {
  
  /// Создать список моделек для таблички
  func configureModels(isModalPresentation: Bool,
                       referals: [String],
                       link: String) -> [PremiumWithFriendsTableViewModel]
}

/// Фабрика
final class PremiumWithFriendsFactory: PremiumWithFriendsFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: PremiumWithFriendsFactoryOutput?
  
  // MARK: - Internal func
  
  func configureModels(isModalPresentation: Bool, referals: [String], link: String) -> [PremiumWithFriendsTableViewModel] {
    let appearance = Appearance()
    var models: [PremiumWithFriendsTableViewModel] = []
    
    models.append(
      .referal(
        appearance.lottieAnimationJSONName,
        title: "\(RandomStrings.Localizable.howItWorks)?",
        firstStepTitle: "1. \(RandomStrings.Localizable.yourUniqueLinkWithFriends)",
        link: link,
        secondStepTitle: "2. \(RandomStrings.Localizable.freeAccessToRandomPremium)",
        circleStepsTitle: "\(RandomStrings.Localizable.remainingInstallations):",
        currentStep: referals.count,
        maxSteps: appearance.maxSteps
      )
    )
    
    models.append(
      .text(
        RandomStrings.Localizable.premiumAccessIsExclusiveToTheDevice
      )
    )
    
    if isModalPresentation {
      models.append(.smallButton(RandomStrings.Localizable.donNotShowAgain))
    }
    return models
  }
}

// MARK: - Appearance

private extension PremiumWithFriendsFactory {
  struct Appearance {
    let lottieAnimationJSONName = RandomAsset.giftReferralProgram.name
    let maxSteps = 5
  }
}
