//
//  TeamsScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//

import UIKit

/// События которые отправляем из View в Presenter
protocol TeamsScreenViewOutput: AnyObject {
  
}

/// События которые отправляем от Presenter ко View
protocol TeamsScreenViewInput: AnyObject {
  
}

/// Псевдоним протокола UIView & TeamsScreenViewInput
typealias TeamsScreenViewProtocol = UIView & TeamsScreenViewInput

/// View для экрана
final class TeamsScreenView: TeamsScreenViewProtocol {
  
  // MARK: - Public properties
  
  // MARK: - Internal properties
  
  weak var output: TeamsScreenViewOutput?
  
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
  
  // MARK: - Public func
  
  // MARK: - Internal func
  
  // MARK: - Private func
  
  private func configureLayout() {
    
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .white
  }
}

// MARK: - Appearance

private extension TeamsScreenView {
  struct Appearance {
    
  }
}
