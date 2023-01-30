//
//  FilmsScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.01.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol FilmsScreenInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol FilmsScreenInteractorInput {}

/// Интерактор
final class FilmsScreenInteractor: FilmsScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: FilmsScreenInteractorOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension FilmsScreenInteractor {
  struct Appearance {}
}
