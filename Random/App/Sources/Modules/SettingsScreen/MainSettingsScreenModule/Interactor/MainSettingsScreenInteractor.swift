//
//  MainSettingsScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//

import UIKit
import SKAbstractions

/// События которые отправляем из Interactor в Presenter
protocol MainSettingsScreenInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol MainSettingsScreenInteractorInput {}

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
}

// MARK: - Appearance

private extension MainSettingsScreenInteractor {
  struct Appearance {}
}
