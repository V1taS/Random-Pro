//
//  PremiumWithFriendsInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 24.07.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol PremiumWithFriendsInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol PremiumWithFriendsInteractorInput {
  
  /// Не показывать этот экран снова
  func doNotShowScreenAgain()
}

/// Интерактор
final class PremiumWithFriendsInteractor: PremiumWithFriendsInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: PremiumWithFriendsInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageService
  private var premiumWithFriendsModel: PremiumWithFriendsModel? {
    get {
      storageService.getData(from: PremiumWithFriendsModel.self)
    } set {
      storageService.saveData(newValue)
    }
  }
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
  }
  
  // MARK: - Internal func
  
  func doNotShowScreenAgain() {
//    premiumWithFriendsModel?.isAutoShowModalPresentationAgain = false
  }
}

// MARK: - Appearance

private extension PremiumWithFriendsInteractor {
  struct Appearance {}
}
