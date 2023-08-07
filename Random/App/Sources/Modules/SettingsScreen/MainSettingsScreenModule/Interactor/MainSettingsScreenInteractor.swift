//
//  MainSettingsScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol MainSettingsScreenInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol MainSettingsScreenInteractorInput {
  
  /// Получить тоггл реферальной программы
  func getPremiumWithFriendsToggle(completion: ((Bool) -> Void)?)
}

/// Интерактор
final class MainSettingsScreenInteractor: MainSettingsScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: MainSettingsScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private let featureToggleServices: FeatureToggleServices
  private var storageService: StorageService
  private var mainScreenModel: MainScreenModel? {
    get {
      storageService.getData(from: MainScreenModel.self)
    } set {
      storageService.saveData(newValue)
    }
  }
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    featureToggleServices = services.featureToggleServices
    storageService = services.storageService
  }
  
  // MARK: - Internal func
  
  func getPremiumWithFriendsToggle(completion: ((Bool) -> Void)?) {
    let isPremiumWithFriends = featureToggleServices.isToggleFor(feature: .isPremiumWithFriends)
    let isPremium = mainScreenModel?.isPremium ?? false
    if isPremiumWithFriends, !isPremium {
      completion?(true)
    } else {
      completion?(false)
    }
  }
}

// MARK: - Appearance

private extension MainSettingsScreenInteractor {
  struct Appearance {}
}
