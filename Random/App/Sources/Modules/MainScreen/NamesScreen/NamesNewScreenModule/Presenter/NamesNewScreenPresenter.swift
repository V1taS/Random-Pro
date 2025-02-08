//
//  NamesNewScreenPresenter.swift
//  Random
//
//  Created by Vitalii Sosin on 8.02.2025.
//

import SwiftUI
import SKUIKit

final class NamesNewScreenPresenter: ObservableObject {
  
  // MARK: - View state
  
  @Published var stateButtonTitle = "Продолжить"
  
  // MARK: - Internal properties
  
  weak var moduleOutput: NamesNewScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: NamesNewScreenInteractorInput
  private let factory: NamesNewScreenFactoryInput

  // MARK: - Initialization
  
  /// - Parameters:
  ///   - interactor: Интерактор
  ///   - factory: Фабрика
  init(interactor: NamesNewScreenInteractorInput,
       factory: NamesNewScreenFactoryInput) {
    defer { setupInitialState() }
    self.interactor = interactor
    self.factory = factory
  }

  // MARK: - Life cycle

  var viewDidLoad: (() -> Void)? = {

  }

  // MARK: - Internal func
}

// MARK: - NamesNewScreenModuleInput

extension NamesNewScreenPresenter: NamesNewScreenModuleInput {}

// MARK: - NamesNewScreenInteractorOutput

extension NamesNewScreenPresenter: NamesNewScreenInteractorOutput {}

// MARK: - NamesNewScreenFactoryOutput

extension NamesNewScreenPresenter: NamesNewScreenFactoryOutput {}

// MARK: - SceneViewModel

extension NamesNewScreenPresenter: SceneViewModel {}

// MARK: - Private

private extension NamesNewScreenPresenter {
  func setupInitialState() {}
}

// MARK: - Constants

private enum Constants {}
