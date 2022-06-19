//
//  ListResultScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.06.2022.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol ListResultScreenInteractorOutput: AnyObject {
  
}

/// События которые отправляем от Presenter к Interactor
protocol ListResultScreenInteractorInput {
  
}

/// Интерактор
final class ListResultScreenInteractor: ListResultScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: ListResultScreenInteractorOutput?
  
  // MARK: - Private properties
  
}

// MARK: - Appearance

private extension ListResultScreenInteractor {
  struct Appearance {
    
  }
}
