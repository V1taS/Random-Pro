//
//  MemesScreenViewController.swift
//  Random
//
//  Created by Vitalii Sosin on 08.07.2023.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol MemesScreenModuleOutput: AnyObject {}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol MemesScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: MemesScreenModuleOutput? { get set }
}

/// Готовый модуль `MemesScreenModule`
typealias MemesScreenModule = UIViewController & MemesScreenModuleInput

/// Презентер
final class MemesScreenViewController: MemesScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: MemesScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: MemesScreenInteractorInput
  private let moduleView: MemesScreenViewProtocol
  private let factory: MemesScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: MemesScreenViewProtocol,
       interactor: MemesScreenInteractorInput,
       factory: MemesScreenFactoryInput) {
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

// MARK: - MemesScreenViewOutput

extension MemesScreenViewController: MemesScreenViewOutput {}

// MARK: - MemesScreenInteractorOutput

extension MemesScreenViewController: MemesScreenInteractorOutput {}

// MARK: - MemesScreenFactoryOutput

extension MemesScreenViewController: MemesScreenFactoryOutput {}

// MARK: - Private

private extension MemesScreenViewController {}

// MARK: - Appearance

private extension MemesScreenViewController {
  struct Appearance {}
}
