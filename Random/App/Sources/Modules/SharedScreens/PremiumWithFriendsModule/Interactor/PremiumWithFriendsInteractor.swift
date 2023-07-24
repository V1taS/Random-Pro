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
protocol PremiumWithFriendsInteractorInput {}

/// Интерактор
final class PremiumWithFriendsInteractor: PremiumWithFriendsInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: PremiumWithFriendsInteractorOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension PremiumWithFriendsInteractor {
  struct Appearance {}
}
