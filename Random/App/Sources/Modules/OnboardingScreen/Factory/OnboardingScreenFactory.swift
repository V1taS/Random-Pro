//
//  OnboardingScreenFactory.swift
//  Random
//
//  Created by Artem Pavlov on 17.06.2023.
//

import UIKit
import RandomUIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol OnboardingScreenFactoryOutput: AnyObject {

  /// Были получены данные
  ///  - Parameter models: Результат генерации для таблички
  func didReceive(models: [OnboardingScreenModel])
}

/// Cобытия которые отправляем от Presenter к Factory
protocol OnboardingScreenFactoryInput {
  func createListModelWith()
}

/// Фабрика
final class OnboardingScreenFactory: OnboardingScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: OnboardingScreenFactoryOutput?
  
  // MARK: - Internal func

  //метод заглушка, пока времено использую
  func createListModelWith() {
    let appearance = Appearance()

    var tableViewModels: [OnboardingScreenModel] = []

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
    self.output?.didReceive(models: tableViewModels)
  }

}

// MARK: - Appearance

private extension OnboardingScreenFactory {
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

    let rockPaperScissosTitle = RandomStrings.Localizable.sectionTsuefa
    let rockPaperScissosDescription = RandomStrings.Localizable.randomRps
    let rockPaperScissosIconJSONName = RandomAsset.premiumRockPaperScissos

    let advTitle = RandomStrings.Localizable.disableAdsTitle
    let advDescription = RandomStrings.Localizable.disableAdsDescription
    let advIconJSONName = RandomAsset.premiumAdv.name
  }
}
