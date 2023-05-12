//
//  TeamsScreenAlertView.swift
//  Random
//
//  Created by Vitalii Sosin on 13.05.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol TeamsScreenAlertViewOutput: AnyObject {
  
  /// Сохранить название команды
  /// - Parameter name: имя команды
  func saveTeam(name: String?)
}

/// События которые отправляем от Presenter к Interactor
protocol TeamsScreenAlertViewInput {
  
  func setOldTeam(name: String?)
}

typealias TeamsScreenAlertViewProtocol = UIAlertAction & TeamsScreenAlertViewInput

/// View для экрана
final class TeamsScreenAlertView: TeamsScreenAlertViewProtocol {
  
  // MARK: - Public properties
  
  // MARK: - Internal properties
  
  weak var output: TeamsScreenAlertViewOutput?
  
  // MARK: - Private properties
  
  private let textField = UITextField()
  
  // MARK: - Initialization
    
  // MARK: - Public func
  
  // MARK: - Internal func
  
  func setOldTeam(name: String?) {
    textField.text = name
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    
  }
  
  private func applyDefaultBehavior() {
   
  }
}

// MARK: - Appearance

private extension TeamsScreenAlertView {
  struct Appearance {
    
  }
}
