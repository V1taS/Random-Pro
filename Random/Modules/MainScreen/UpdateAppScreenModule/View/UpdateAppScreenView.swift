//
//  UpdateAppScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 17.09.2022.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol UpdateAppScreenViewOutput: AnyObject {}

/// События которые отправляем от Presenter ко View
protocol UpdateAppScreenViewInput: AnyObject {}

/// Псевдоним протокола UIView & UpdateAppScreenViewInput
typealias UpdateAppScreenViewProtocol = UIView & UpdateAppScreenViewInput

/// View для экрана
final class UpdateAppScreenView: UpdateAppScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: UpdateAppScreenViewOutput?
  
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
  
  // MARK: - Private func
  
  private func configureLayout() {}
  
  private func applyDefaultBehavior() {
    backgroundColor = RandomColor.primaryWhite
  }
}

// MARK: - Appearance

private extension UpdateAppScreenView {
  struct Appearance {}
}
