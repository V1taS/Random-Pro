//
//  NickNameScreenView.swift
//  Random
//
//  Created by Tatyana Sosina on 15.05.2023.
//

import UIKit

/// События которые отправляем из View в Presenter
protocol NickNameScreenViewOutput: AnyObject {}

/// События которые отправляем от Presenter ко View
protocol NickNameScreenViewInput {}

/// Псевдоним протокола UIView & NickNameScreenViewInput
typealias NickNameScreenViewProtocol = UIView & NickNameScreenViewInput

/// View для экрана
final class NickNameScreenView: NickNameScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: NickNameScreenViewOutput?
  
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

private extension NickNameScreenView {
  func configureLayout() {}
  
  func applyDefaultBehavior() {
    backgroundColor = .white
  }
}

// MARK: - Appearance

private extension NickNameScreenView {
  struct Appearance {}
}
