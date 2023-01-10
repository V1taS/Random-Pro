//
//  RaffleScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.01.2023.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol RaffleScreenModuleOutput: AnyObject {
  
  /// Ошибка в авторизации
  func authorizationError()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol RaffleScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: RaffleScreenModuleOutput? { get set }
}

/// Готовый модуль `RaffleScreenModule`
typealias RaffleScreenModule = UIViewController & RaffleScreenModuleInput

/// Презентер
final class RaffleScreenViewController: RaffleScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: RaffleScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: RaffleScreenInteractorInput
  private let moduleView: RaffleScreenViewProtocol
  private let factory: RaffleScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: RaffleScreenViewProtocol,
       interactor: RaffleScreenInteractorInput,
       factory: RaffleScreenFactoryInput) {
    self.moduleView = moduleView
    self.interactor = interactor
    self.factory = factory
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life cycle
  
  override func loadView() {
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}

// MARK: - RaffleScreenViewOutput

extension RaffleScreenViewController: RaffleScreenViewOutput {
  func actionOnSignInWithApple() {
    interactor.actionOnSignInWithApple()
  }
}

// MARK: - RaffleScreenInteractorOutput

extension RaffleScreenViewController: RaffleScreenInteractorOutput {
  func authorizationSuccess() {
    
  }
  
  func authorizationError() {
    moduleOutput?.authorizationError()
  }
}

// MARK: - RaffleScreenFactoryOutput

extension RaffleScreenViewController: RaffleScreenFactoryOutput {}

// MARK: - Private

private extension RaffleScreenViewController {}

// MARK: - Appearance

private extension RaffleScreenViewController {
  struct Appearance {}
}
