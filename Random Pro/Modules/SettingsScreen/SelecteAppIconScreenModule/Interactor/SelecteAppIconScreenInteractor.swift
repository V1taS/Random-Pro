//
//  SelecteAppIconScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 25.01.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol SelecteAppIconScreenInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol SelecteAppIconScreenInteractorInput {}

/// Интерактор
final class SelecteAppIconScreenInteractor: SelecteAppIconScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: SelecteAppIconScreenInteractorOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension SelecteAppIconScreenInteractor {
  struct Appearance {}
}
