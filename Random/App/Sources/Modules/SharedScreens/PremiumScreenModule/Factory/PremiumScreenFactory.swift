//
//  PremiumScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import UIKit
import FancyUIKit
import FancyStyle
import StoreKit
import SKAbstractions

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
  /// - Parameters:
  ///  - models: Список продуктов
  ///  - isLifetimeSale: Режим распродажи
  func createListModelWith(models: [SKProduct], isLifetimeSale: Bool)
  
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
  
  func createListModelWith(models: [SKProduct], isLifetimeSale: Bool) {
    let appearance = Appearance()
    let monthlyProduct = models.filter {
      $0.productIdentifier == PremiumScreenPurchaseType.monthly.productIdentifiers
    }.first
    let yearlyProduct = models.filter {
      $0.productIdentifier == PremiumScreenPurchaseType.yearly.productIdentifiers
    }.first
    let lifetimeProduct = models.filter {
      $0.productIdentifier == PremiumScreenPurchaseType.lifetime.productIdentifiers
    }.first
    let lifetimeSaleProduct = models.filter {
      $0.productIdentifier == PremiumScreenPurchaseType.lifetimeSale.productIdentifiers
    }.first
    
    var tableViewModels: [PremiumScreenSectionType] = []
    
    tableViewModels.append(.onboardingPage([
      OnboardingViewModel.PageModel(title: appearance.chooseIconTitle,
                                    description: appearance.chooseIconDescription,
                                    lottieAnimationJSONName: appearance.chooseIconJSONName),
      OnboardingViewModel.PageModel(title: appearance.syncTitle,
                                    description: appearance.syncDescription,
                                    lottieAnimationJSONName: appearance.syncIconJSONName),
      OnboardingViewModel.PageModel(title: appearance.filmsTitle,
                                    description: appearance.filmsDescription,
                                    lottieAnimationJSONName: appearance.filmsIconJSONName),
      OnboardingViewModel.PageModel(title: appearance.filtersTitle,
                                    description: appearance.filtersDescription,
                                    lottieAnimationJSONName: appearance.filtersIconJSONName),
      OnboardingViewModel.PageModel(title: appearance.playerCardSelectionTitle,
                                    description: appearance.playerCardSelectionDescription,
                                    lottieAnimationJSONName: appearance.playerCardSelectionIconJSONName),
      OnboardingViewModel.PageModel(title: appearance.advTitle,
                                    description: appearance.advDescription,
                                    lottieAnimationJSONName: appearance.advIconJSONName),
      OnboardingViewModel.PageModel(title: appearance.donateTitle,
                                    description: appearance.donateDescription,
                                    lottieAnimationJSONName: appearance.donateIconJSONName)
    ]))
    tableViewModels.append(.padding(appearance.maxInset))
    
    if isLifetimeSale {
      tableViewModels.append(.lifetimeSale(
        title: "\(appearance.sale)\n(\(RandomStrings.Localizable.oneTimePurchase))",
        oldPrice: lifetimeProduct?.localizedPrice,
        newPrice: lifetimeSaleProduct?.localizedPrice)
      )
    } else {
      tableViewModels.append(.purchasesCards(
        yearlyProduct?.localizedPrice,
        monthlyProduct?.localizedPrice,
        lifetimeProduct?.localizedPrice
      ))
    }
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
    let purchaseTitle = RandomStrings.Localizable.buy
    let forTitle = RandomStrings.Localizable.for
    let subscribeTitle = RandomStrings.Localizable.subscribe
    let maxInset: CGFloat = 20
    
    let chooseIconTitle = RandomStrings.Localizable.selectIcon
    let chooseIconDescription = RandomStrings.Localizable.customizeAppAppearance
    let chooseIconJSONName = RandomAsset.premiumIcon.name
    
    let filmsTitle = RandomStrings.Localizable.moviesSection
    let filmsDescription = RandomStrings.Localizable.accessToMovies
    let filmsIconJSONName = RandomAsset.premiumFilms.name
    
    let filtersTitle = RandomStrings.Localizable.photoFilters
    let filtersDescription = RandomStrings.Localizable.improvePhotos
    let filtersIconJSONName = RandomAsset.premiumFilters.name
    
    let donateTitle = RandomStrings.Localizable.supportProject
    let donateDescription = RandomStrings.Localizable.joinCommunity
    let donateIconJSONName = RandomAsset.premiumDonate.name
    
    let syncTitle = RandomStrings.Localizable.sync
    let syncDescription = RandomStrings.Localizable.accessData
    let syncIconJSONName = RandomAsset.premiumSync.name
    
    let playerCardSelectionTitle = RandomStrings.Localizable.teamSection
    let playerCardSelectionDescription = RandomStrings.Localizable.uniqueCardStyle
    let playerCardSelectionIconJSONName = RandomAsset.premiumPlayerCardSelection.name
    
    // TODO: - Не понятно что с этим разделом делать, аппл не пропустили
    let rockPaperScissosTitle = RandomStrings.Localizable.sectionTsuefa
    let rockPaperScissosDescription = RandomStrings.Localizable.randomRps
    let rockPaperScissosIconJSONName = RandomAsset.premiumRockPaperScissos
    
    let advTitle = RandomStrings.Localizable.disableAdsTitle
    let advDescription = RandomStrings.Localizable.disableAdsDescription
    let advIconJSONName = RandomAsset.premiumAdv.name
    
    let sale = RandomStrings.Localizable.sale
  }
}
