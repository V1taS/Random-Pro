//
//  PremiumScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol PremiumScreenViewOutput: AnyObject {}

/// События которые отправляем от Presenter ко View
protocol PremiumScreenViewInput {
  
  /// Выбрать способ показа экрана
  /// - Parameter type: Тип показа
  func selectPresentType(_ type: PremiumScreenPresentType)
}

/// Псевдоним протокола UIView & PremiumScreenViewInput
typealias PremiumScreenViewProtocol = UIView & PremiumScreenViewInput

/// View для экрана
final class PremiumScreenView: PremiumScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: PremiumScreenViewOutput?
  
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
  
  func selectPresentType(_ type: PremiumScreenPresentType) {
    // TODO: -
  }
}

// MARK: - Private

private extension PremiumScreenView {
  func configureLayout() {}
  
  func applyDefaultBehavior() {
    backgroundColor = RandomColor.primaryWhite
  }
}

// MARK: - Appearance

private extension PremiumScreenView {
  struct Appearance {}
}
