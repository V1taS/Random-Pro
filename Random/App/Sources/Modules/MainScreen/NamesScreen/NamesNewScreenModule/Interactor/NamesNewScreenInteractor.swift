//
//  NamesNewScreenInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 8.02.2025.
//

import SwiftUI

/// События которые отправляем из Interactor в Presenter
protocol NamesNewScreenInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol NamesNewScreenInteractorInput {}

/// Интерактор
final class NamesNewScreenInteractor {
  
  // MARK: - Internal properties
  
  weak var output: NamesNewScreenInteractorOutput?
}

// MARK: - NamesNewScreenInteractorInput

extension NamesNewScreenInteractor: NamesNewScreenInteractorInput {}

// MARK: - Private

private extension NamesNewScreenInteractor {}

// MARK: - Constants

private enum Constants {}
