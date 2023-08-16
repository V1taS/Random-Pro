//
//  BottleStyleSelectionInteractor.swift
//  Random
//
//  Created by Artem Pavlov on 16.08.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol BottleStyleSelectionInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol BottleStyleSelectionInteractorInput {}

/// Интерактор
final class BottleStyleSelectionInteractor: BottleStyleSelectionInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: BottleStyleSelectionInteractorOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension BottleStyleSelectionInteractor {
  struct Appearance {}
}
