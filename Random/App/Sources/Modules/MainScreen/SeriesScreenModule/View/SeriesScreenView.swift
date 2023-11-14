//
//  SeriesScreenView.swift
//  Random
//
//  Created by Artem Pavlov on 13.11.2023.
//

import UIKit
import FancyStyle

/// События которые отправляем из View в Presenter
protocol SeriesScreenViewOutput: AnyObject {}

/// События которые отправляем от Presenter ко View
protocol SeriesScreenViewInput {}

/// Псевдоним протокола UIView & SeriesScreenViewInput
typealias SeriesScreenViewProtocol = UIView & SeriesScreenViewInput

/// View для экрана
final class SeriesScreenView: SeriesScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: SeriesScreenViewOutput?
  
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

private extension SeriesScreenView {
  func configureLayout() {}
  
  func applyDefaultBehavior() {
    backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
  }
}

// MARK: - Appearance

private extension SeriesScreenView {
  struct Appearance {}
}
