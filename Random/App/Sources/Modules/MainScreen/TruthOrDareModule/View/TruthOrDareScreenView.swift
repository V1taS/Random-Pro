//
//  TruthOrDareScreenView.swift
//  Random
//
//  Created by Artem Pavlov on 09.06.2023.
//

import UIKit

/// События которые отправляем из View в Presenter
protocol TruthOrDareScreenViewOutput: AnyObject {}

/// События которые отправляем от Presenter ко View
protocol TruthOrDareScreenViewInput {}

/// Псевдоним протокола UIView & TruthOrDareScreenViewInput
typealias TruthOrDareScreenViewProtocol = UIView & TruthOrDareScreenViewInput

/// View для экрана
final class TruthOrDareScreenView: TruthOrDareScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: TruthOrDareScreenViewOutput?
  
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

private extension TruthOrDareScreenView {
  func configureLayout() {}
  
  func applyDefaultBehavior() {
    backgroundColor = .white
  }
}

// MARK: - Appearance

private extension TruthOrDareScreenView {
  struct Appearance {}
}
