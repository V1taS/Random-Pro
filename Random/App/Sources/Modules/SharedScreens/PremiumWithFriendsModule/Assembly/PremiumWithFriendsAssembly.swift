//
//  PremiumWithFriendsAssembly.swift
//  Random
//
//  Created by Vitalii Sosin on 24.07.2023.
//

import UIKit

/// Сборщик `PremiumWithFriends`
final class PremiumWithFriendsAssembly {
  
  /// Собирает модуль `PremiumWithFriends`
  /// - Returns: Cобранный модуль `PremiumWithFriends`
  func createModule(services: ApplicationServices) -> PremiumWithFriendsModule {
    let interactor = PremiumWithFriendsInteractor(services: services)
    let view = PremiumWithFriendsView()
    let factory = PremiumWithFriendsFactory()
    let presenter = PremiumWithFriendsViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
