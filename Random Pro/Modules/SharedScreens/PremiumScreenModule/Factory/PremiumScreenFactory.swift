//
//  PremiumScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import UIKit
import RandomUIKit
import StoreKit

/// Cобытия которые отправляем из Factory в Presenter
protocol PremiumScreenFactoryOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter models: Результат генерации для таблички
  func didReceive(models: [PremiumScreenSectionType])
  
  /// Был получен созданный заголовок для главной кнопки
  ///  - Parameter title: Заголовок для главной кнопки
  func didReceiveMainButton(title: String?)
}

/// Cобытия которые отправляем от Presenter к Factory
protocol PremiumScreenFactoryInput {
  
  /// Создаем модельку для таблички
  /// - Parameter models: Список продуктов
  func createListModelWith(models: [SKProduct])
  
  /// Создать заголовок для основной кнопки
  /// - Parameters:
  ///  - purchaseType: Тип платной услуги
  ///  - amount: Стоимость услуги
  func createMainButtonTitleFrom(_ purchaseType: PremiumScreenPurchaseType,
                                 amount: String?)
}

/// Фабрика
final class PremiumScreenFactory: PremiumScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: PremiumScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func createMainButtonTitleFrom(_ purchaseType: PremiumScreenPurchaseType,
                                 amount: String?) {
    let appearance = Appearance()
    let buttontitle = purchaseType == .lifetime ? appearance.purchaseTitle : appearance.subscribeTitle
    output?.didReceiveMainButton(title: "\(buttontitle) \(appearance.forTitle) \(amount ?? "")")
  }
  
  func createListModelWith(models: [SKProduct]) {
    let appearance = Appearance()
    let monthlyProduct = models.filter { $0.productIdentifier == PremiumScreenPurchaseType.monthly.productIdentifiers }.first
    let yearlyProduct = models.filter { $0.productIdentifier == PremiumScreenPurchaseType.yearly.productIdentifiers }.first
    let lifetimeProduct = models.filter { $0.productIdentifier == PremiumScreenPurchaseType.lifetime.productIdentifiers }.first
    
    var tableViewModels: [PremiumScreenSectionType] = []
    
    tableViewModels.append(.onboardingPage([
      // TODO: - Добавить массив премиум
      OnboardingViewModel.PageModel(title: "Search History",
                                    description: "Transfer obfuscate traffic via encrypted tunnel",
                                    lottieAnimationJSONName: "133506-yoga"),
      OnboardingViewModel.PageModel(title: "Search History",
                                    description: "Transfer obfuscate traffic via encrypted tunnel",
                                    lottieAnimationJSONName: "133506-yoga"),
      OnboardingViewModel.PageModel(title: "Search History",
                                    description: "Transfer obfuscate traffic via encrypted tunnel",
                                    lottieAnimationJSONName: "133506-yoga"),
    ]))
    
    tableViewModels.append(.padding(appearance.maxInset))
    tableViewModels.append(.purchasesCards(yearlyProduct?.localizedPrice,
                                           monthlyProduct?.localizedPrice,
                                           lifetimeProduct?.localizedPrice))
    
    self.output?.didReceive(models: tableViewModels)
  }
}

// MARK: - SKProduct

private extension SKProduct {
  var localizedPrice: String? {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = priceLocale
    numberFormatter.numberStyle = .currency
    return numberFormatter.string(from: price)
  }
}

// MARK: - Appearance

private extension PremiumScreenFactory {
  struct Appearance {
    let purchaseTitle = NSLocalizedString("Купить", comment: "")
    let forTitle = NSLocalizedString("за", comment: "")
    let subscribeTitle = NSLocalizedString("Подписаться", comment: "")
    let maxInset: CGFloat = 20
  }
}
