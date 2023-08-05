//
//  AppUnavailableInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 05.08.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol AppUnavailableInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol AppUnavailableInteractorInput {}

/// Интерактор
final class AppUnavailableInteractor: AppUnavailableInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: AppUnavailableInteractorOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension AppUnavailableInteractor {
  struct Appearance {}
}
