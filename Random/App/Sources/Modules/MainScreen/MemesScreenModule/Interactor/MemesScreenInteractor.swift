//
//  MemesScreenInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 08.07.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol MemesScreenInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol MemesScreenInteractorInput {}

/// Интерактор
final class MemesScreenInteractor: MemesScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: MemesScreenInteractorOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension MemesScreenInteractor {
  struct Appearance {}
}
