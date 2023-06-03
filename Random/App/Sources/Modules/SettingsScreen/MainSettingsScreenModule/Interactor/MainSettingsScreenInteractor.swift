//
//  MainSettingsScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol MainSettingsScreenInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol MainSettingsScreenInteractorInput {}

/// Интерактор
final class MainSettingsScreenInteractor: MainSettingsScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: MainSettingsScreenInteractorOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension MainSettingsScreenInteractor {
  struct Appearance {}
}