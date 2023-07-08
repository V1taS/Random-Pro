//
//  MemesScreenView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.07.2023.
//

import UIKit

/// События которые отправляем из View в Presenter
protocol MemesScreenViewOutput: AnyObject {}

/// События которые отправляем от Presenter ко View
protocol MemesScreenViewInput {}

/// Псевдоним протокола UIView & MemesScreenViewInput
typealias MemesScreenViewProtocol = UIView & MemesScreenViewInput

/// View для экрана
final class MemesScreenView: MemesScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: MemesScreenViewOutput?
  
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

private extension MemesScreenView {
  func configureLayout() {}
  
  func applyDefaultBehavior() {
    backgroundColor = .white
  }
}

// MARK: - Appearance

private extension MemesScreenView {
  struct Appearance {}
}
