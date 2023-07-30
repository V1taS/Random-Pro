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
  func configureModels(isModalPresentation: Bool) -> [PremiumWithFriendsTableViewModel]
}

/// Фабрика
final class PremiumWithFriendsFactory: PremiumWithFriendsFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: PremiumWithFriendsFactoryOutput?
  
  // MARK: - Internal func
  
  func configureModels(isModalPresentation: Bool) -> [PremiumWithFriendsTableViewModel] {
    let appearance = Appearance()
    var models: [PremiumWithFriendsTableViewModel] = []
    
    models.append(
      .referal(
        appearance.lottieAnimationJSONName,
        title: "Как это работает?",
        firstStepTitle: "1. Поделитесь вашей уникальной ссылкой с друзьями, знакомыми или коллегами",
        link: "https://SosinVitalii.com/eaigsengkjnsdakg/alekgmnlakeg/",
        secondStepTitle: "2. Получите бесплатный доступ к Random Premium, как только пять человек скачают приложение по вашей ссылке",
        circleStepsTitle: "Осталось установок:",
        currentStep: 2,
        maxSteps: appearance.maxSteps
      )
    )
    
    models.append(
      .text(
        // swiftlint:disable:next line_length
        "*Премиум-доступ предоставляется исключительно для устройства, с которого была скопирована реферальная ссылка. В случае переустановки или удаления приложения, премиум-доступ пропадает и потребуется приглашение друзей заново. Даже если у вас один аккаунт App Store на разных устройствах, премиум будет активен только на том устройстве, с которого была скопирована ссылка."
      )
    )
    
    if isModalPresentation {
      models.append(.smallButton("Больше не показывать"))
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
