//
//  PremiumWithFriendsView.swift
//  Random
//
//  Created by Vitalii Sosin on 24.07.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol PremiumWithFriendsViewOutput: AnyObject {}

/// События которые отправляем от Presenter ко View
protocol PremiumWithFriendsViewInput {}

/// Псевдоним протокола UIView & PremiumWithFriendsViewInput
typealias PremiumWithFriendsViewProtocol = UIView & PremiumWithFriendsViewInput

/// View для экрана
final class PremiumWithFriendsView: PremiumWithFriendsViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: PremiumWithFriendsViewOutput?
  
  // MARK: - Private properties
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
}

// MARK: - Private

private extension PremiumWithFriendsView {
  func configureLayout() {}
  
  func applyDefaultBehavior() {
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
  }
}

// MARK: - Appearance

private extension PremiumWithFriendsView {
  struct Appearance {}
}
