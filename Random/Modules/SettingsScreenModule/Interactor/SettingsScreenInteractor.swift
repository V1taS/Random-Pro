//
//  SettingsScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 23.05.2022.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol SettingsScreenInteractorOutput: AnyObject {
  
}

/// События которые отправляем от Presenter к Interactor
protocol SettingsScreenInteractorInput {
  
}

/// Интерактор
final class SettingsScreenInteractor: SettingsScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: SettingsScreenInteractorOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension SettingsScreenInteractor {
  struct Appearance {
    
  }
}
