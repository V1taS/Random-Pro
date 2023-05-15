//
//  NickNameScreenInteractor.swift
//  Random
//
//  Created by Tatyana Sosina on 15.05.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol NickNameScreenInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol NickNameScreenInteractorInput {}

/// Интерактор
final class NickNameScreenInteractor: NickNameScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: NickNameScreenInteractorOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension NickNameScreenInteractor {
  struct Appearance {}
}
