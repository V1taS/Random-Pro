//
//  PremiumWithFriendsInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 24.07.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol PremiumWithFriendsInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter referals: Список рефералов
  ///  - Parameter link: Ссылка для реферала
  func didReceive(referals: [String], link: String)
}

/// События которые отправляем от Presenter к Interactor
protocol PremiumWithFriendsInteractorInput {
  
  /// Не показывать этот экран снова
  func doNotShowScreenAgain()
  
  /// Получить контент
  func getContent()
}

/// Интерактор
final class PremiumWithFriendsInteractor: PremiumWithFriendsInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: PremiumWithFriendsInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageService
  private let services: ApplicationServices
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
    self.services = services
    storageService = services.storageService
  }
  
  // MARK: - Internal func
  
  func getContent() {
    services.referalService.getSelfInfo { [weak self] result in
      DispatchQueue.main.async {
        var referals: [String] = []
        if let listReferals = result?.referals {
          referals = listReferals
        }
        let link = self?.services.referalService.createDynamicLink()
        self?.output?.didReceive(referals: referals, link: link ?? "❌")
      }
    }
  }
  
  func doNotShowScreenAgain() {
    premiumWithFriendsModel?.isAutoShowModalPresentationAgain = false
  }
}

// MARK: - Appearance

private extension PremiumWithFriendsInteractor {
  struct Appearance {}
}
