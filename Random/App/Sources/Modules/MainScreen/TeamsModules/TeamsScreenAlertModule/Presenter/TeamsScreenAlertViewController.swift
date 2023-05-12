//
//  TeamsScreenAlertViewController.swift
//  Random
//
//  Created by Vitalii Sosin on 13.05.2023.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol TeamsScreenAlertModuleOutput: AnyObject {
  
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol TeamsScreenAlertModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: TeamsScreenAlertModuleOutput? { get set }
}

/// Готовый модуль `TeamsScreenAlertModule`
typealias TeamsScreenAlertModule = UIAlertController & TeamsScreenAlertModuleInput

/// Презентер
final class TeamsScreenAlertViewController: TeamsScreenAlertModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: TeamsScreenAlertModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: TeamsScreenAlertInteractorInput
  private let moduleView: TeamsScreenAlertViewProtocol
  private let factory: TeamsScreenAlertFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: TeamsScreenAlertViewProtocol,
       interactor: TeamsScreenAlertInteractorInput,
       factory: TeamsScreenAlertFactoryInput) {
    self.moduleView = moduleView
    self.interactor = interactor
    self.factory = factory
    super.init(nibName: nil, bundle: nil)
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    addAction(moduleView)
    addAction(cancelAction)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life cycle
}

// MARK: - TeamsScreenAlertViewOutput

extension TeamsScreenAlertViewController: TeamsScreenAlertViewOutput {}

// MARK: - TeamsScreenAlertInteractorOutput

extension TeamsScreenAlertViewController: TeamsScreenAlertInteractorOutput {}

// MARK: - TeamsScreenAlertFactoryOutput

extension TeamsScreenAlertViewController: TeamsScreenAlertFactoryOutput {}

// MARK: - Private

private extension TeamsScreenAlertViewController {}

// MARK: - Appearance

private extension TeamsScreenAlertViewController {
  struct Appearance {}
}
