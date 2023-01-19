//
//  PremiumScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol PremiumScreenFactoryOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter models: результат генерации для таблички
  func didReceive(models: [PremiumScreenSectionType])
}

/// Cобытия которые отправляем от Presenter к Factory
protocol PremiumScreenFactoryInput {
  
  /// Создаем модельку для таблички
  func createListModelWith()
}

/// Фабрика
final class PremiumScreenFactory: PremiumScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: PremiumScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func createListModelWith() {
//    let appearance = Appearance()
    var tableViewModels: [PremiumScreenSectionType] = []
    
    tableViewModels.append(.onboardingPage(
      PremiumScreenOnboardingViewModel(pageModels: [
        PremiumScreenOnboardingPageViewModel(title: "Search History",
                                             description: "Transfer obfuscate traffic via encrypted tunnel",
                                             lottieAnimationJSONName: "133506-yoga"),
        PremiumScreenOnboardingPageViewModel(title: "Search History",
                                             description: "Transfer obfuscate traffic via encrypted tunnel",
                                             lottieAnimationJSONName: "133506-yoga"),
        PremiumScreenOnboardingPageViewModel(title: "Search History",
                                             description: "Transfer obfuscate traffic via encrypted tunnel",
                                             lottieAnimationJSONName: "133506-yoga")
      ]))
    )
    
    tableViewModels.append(.padding(24))
    tableViewModels.append(.purchasesCards([
      PurchasesCardsCellModel(header: "Buy",
                              title: "1",
                              description: "Monthly",
                              amount: "$ 0.50",
                              action: nil),
      PurchasesCardsCellModel(header: "MOST POPULAR",
                              title: "12",
                              description: "Yearly",
                              amount: "$ 2.55",
                              action: nil),
      PurchasesCardsCellModel(header: "sub",
                              title: "8",
                              description: "Liftime",
                              amount: "$ 50.0",
                              action: nil)
    ]))
    output?.didReceive(models: tableViewModels)
  }
}

// MARK: - Appearance

private extension PremiumScreenFactory {
  struct Appearance {}
}
