//
//  BottleStyleSelectionView.swift
//  Random
//
//  Created by Artem Pavlov on 16.08.2023.
//

import UIKit
import FancyUIKit

/// События которые отправляем из View в Presenter
protocol BottleStyleSelectionViewOutput: AnyObject {}

/// События которые отправляем от Presenter ко View
protocol BottleStyleSelectionViewInput {}

/// Псевдоним протокола UIView & BottleStyleSelectionViewInput
typealias BottleStyleSelectionViewProtocol = UIView & BottleStyleSelectionViewInput

/// View для экрана
final class BottleStyleSelectionView: BottleStyleSelectionViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: BottleStyleSelectionViewOutput?
  
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

private extension BottleStyleSelectionView {
  func configureLayout() {}
  
  func applyDefaultBehavior() {
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
  }
}

// MARK: - Appearance

private extension BottleStyleSelectionView {
  struct Appearance {}
}
