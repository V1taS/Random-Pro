//
//  QuotesScreenView.swift
//  Random
//
//  Created by Mikhail Kolkov on 6/8/23.
//

import UIKit

/// События которые отправляем из View в Presenter
protocol QuotesScreenViewOutput: AnyObject {}

/// События которые отправляем от Presenter ко View
protocol QuotesScreenViewInput {}

/// Псевдоним протокола UIView & QuotesScreenViewInput
typealias QuotesScreenViewProtocol = UIView & QuotesScreenViewInput

/// View для экрана
final class QuotesScreenView: QuotesScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: QuotesScreenViewOutput?
  
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

private extension QuotesScreenView {
  func configureLayout() {}
  
  func applyDefaultBehavior() {
    backgroundColor = .white
  }
}

// MARK: - Appearance

private extension QuotesScreenView {
  struct Appearance {}
}
