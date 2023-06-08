//
//  TruthOrDareScreenViewController.swift
//  Random
//
//  Created by Artem Pavlov on 09.06.2023.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol TruthOrDareScreenModuleOutput: AnyObject {}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol TruthOrDareScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: TruthOrDareScreenModuleOutput? { get set }
}

/// Готовый модуль `TruthOrDareScreenModule`
typealias TruthOrDareScreenModule = UIViewController & TruthOrDareScreenModuleInput

/// Презентер
final class TruthOrDareScreenViewController: TruthOrDareScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: TruthOrDareScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: TruthOrDareScreenInteractorInput
  private let moduleView: TruthOrDareScreenViewProtocol
  private let factory: TruthOrDareScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: TruthOrDareScreenViewProtocol,
       interactor: TruthOrDareScreenInteractorInput,
       factory: TruthOrDareScreenFactoryInput) {
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

// MARK: - TruthOrDareScreenViewOutput

extension TruthOrDareScreenViewController: TruthOrDareScreenViewOutput {}

// MARK: - TruthOrDareScreenInteractorOutput

extension TruthOrDareScreenViewController: TruthOrDareScreenInteractorOutput {}

// MARK: - TruthOrDareScreenFactoryOutput

extension TruthOrDareScreenViewController: TruthOrDareScreenFactoryOutput {}

// MARK: - Private

private extension TruthOrDareScreenViewController {}

// MARK: - Appearance

private extension TruthOrDareScreenViewController {
  struct Appearance {}
}
