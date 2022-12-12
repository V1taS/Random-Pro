//
//  RockPaperScissorsScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol RockPaperScissorsScreenViewOutput: AnyObject {}

/// События которые отправляем от Presenter ко View
protocol RockPaperScissorsScreenViewInput {}

typealias RockPaperScissorsScreenViewProtocol = UIView & RockPaperScissorsScreenViewInput

final class RockPaperScissorsScreenView: RockPaperScissorsScreenViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: RockPaperScissorsScreenViewOutput?
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupDefaultSettings()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private

private extension RockPaperScissorsScreenView {
  func setupDefaultSettings() {
    backgroundColor = .yellow
  }
  
  func setupConstraints() {}
}

// MARK: - Appearance

private extension RockPaperScissorsScreenView {
  struct Appearance {}
}
