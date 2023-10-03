//
//  CubesStyleSelectionScreenView.swift
//  Random
//
//  Created by Сергей Юханов on 03.10.2023.
//

import UIKit

/// События которые отправляем из View в Presenter
protocol CubesStyleSelectionScreenViewOutput: AnyObject {}

/// События которые отправляем от Presenter ко View
protocol CubesStyleSelectionScreenViewInput {}

/// Псевдоним протокола UIView & CubesStyleSelectionScreenViewInput
typealias CubesStyleSelectionScreenViewProtocol = UIView & CubesStyleSelectionScreenViewInput

/// View для экрана
final class CubesStyleSelectionScreenView: CubesStyleSelectionScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: CubesStyleSelectionScreenViewOutput?
  
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

private extension CubesStyleSelectionScreenView {
  func configureLayout() {}
  
  func applyDefaultBehavior() {
    backgroundColor = .white
  }
}

// MARK: - Appearance

private extension CubesStyleSelectionScreenView {
  struct Appearance {}
}
