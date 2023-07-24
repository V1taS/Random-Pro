//
//  PremiumWithFriendsFactory.swift
//  Random
//
//  Created by Vitalii Sosin on 24.07.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol PremiumWithFriendsFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol PremiumWithFriendsFactoryInput {}

/// Фабрика
final class PremiumWithFriendsFactory: PremiumWithFriendsFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: PremiumWithFriendsFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension PremiumWithFriendsFactory {
  struct Appearance {}
}
