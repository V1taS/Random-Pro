//
//  QuotesScreenInteractor.swift
//  Random
//
//  Created by Mikhail Kolkov on 6/8/23.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol QuotesScreenInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol QuotesScreenInteractorInput {}

/// Интерактор
final class QuotesScreenInteractor: QuotesScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: QuotesScreenInteractorOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension QuotesScreenInteractor {
  struct Appearance {}
}
