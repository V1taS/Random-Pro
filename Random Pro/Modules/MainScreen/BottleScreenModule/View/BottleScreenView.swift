//
//  BottleScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 29.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

protocol BottleScreenViewOutput: AnyObject {
  
}

protocol BottleScreenViewInput {
  
}

typealias BottleScreenViewProtocol = UIView & BottleScreenViewInput

final class BottleScreenView: BottleScreenViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: BottleScreenViewOutput?
  
  // MARK: - Internal func
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupDefaultSettings()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private func
  
  private func setupDefaultSettings() {
    backgroundColor = .yellow
  }
  
  private func setupConstraints() {
    
  }
}

// MARK: - Appearance

private extension BottleScreenView {
  struct Appearance {
    
  }
}
