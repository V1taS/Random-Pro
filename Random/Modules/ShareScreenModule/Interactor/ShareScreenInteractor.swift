//
//  ShareScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.08.2022.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol ShareScreenInteractorOutput: AnyObject {
  
}

/// События которые отправляем от Presenter к Interactor
protocol ShareScreenInteractorInput {
  
}

/// Интерактор
final class ShareScreenInteractor: ShareScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: ShareScreenInteractorOutput?
  
  // MARK: - Internal func
  
}

// MARK: - Appearance

private extension ShareScreenInteractor {
  struct Appearance {
    
  }
}
