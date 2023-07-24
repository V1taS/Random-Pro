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
  
  let featureToggleServices: FeatureToggleServices
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    featureToggleServices = services.featureToggleServices
  }
  
  // MARK: - Internal func
  
  func getPremiumWithFriendsToggle(completion: ((Bool) -> Void)?) {
    featureToggleServices.getSectionsIsHiddenFT { isHiddenFT in
      DispatchQueue.main.async {
        completion?(!(isHiddenFT?.premiumWithFriends ?? true))
      }
    }
  }
}

// MARK: - Appearance

private extension MainSettingsScreenInteractor {
  struct Appearance {}
}
