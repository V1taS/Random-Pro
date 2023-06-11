//
//  FortuneWheelView.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol FortuneWheelViewOutput: AnyObject {}

/// События которые отправляем от Presenter ко View
protocol FortuneWheelViewInput {}

/// Псевдоним протокола UIView & FortuneWheelViewInput
typealias FortuneWheelViewProtocol = UIView & FortuneWheelViewInput

/// View для экрана
final class FortuneWheelView: FortuneWheelViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: FortuneWheelViewOutput?
  
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

private extension FortuneWheelView {
  func configureLayout() {}
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
  }
}

// MARK: - Appearance

private extension FortuneWheelView {
  struct Appearance {}
}
