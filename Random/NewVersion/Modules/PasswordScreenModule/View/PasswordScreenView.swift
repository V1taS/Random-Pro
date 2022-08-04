//
//  PasswordScreenView.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 04.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

protocol PasswordScreenViewOutput: AnyObject {
  
}

protocol PasswordScreenViewInput: AnyObject {
  
}

typealias PasswordScreenViewProtocol = UIView & PasswordScreenViewInput

final class PasswordScreenView: PasswordScreenViewProtocol {
  
  weak var output: PasswordScreenViewOutput?
  
  private let passwordSegmentedControl = UISegmentedControl()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupDefaultSettings()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupDefaultSettings() {
    backgroundColor = RandomColor.secondaryWhite
  }
  
}
