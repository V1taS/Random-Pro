//
//  NickNameScreenViewController.swift
//  Random
//
//  Created by Tatyana Sosina on 15.05.2023.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol NickNameScreenModuleOutput: AnyObject {}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol NickNameScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: NickNameScreenModuleOutput? { get set }
}

/// Готовый модуль `NickNameScreenModule`
typealias NickNameScreenModule = UIViewController & NickNameScreenModuleInput

/// Презентер
final class NickNameScreenViewController: NickNameScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: NickNameScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: NickNameScreenInteractorInput
  private let moduleView: NickNameScreenViewProtocol
  private let factory: NickNameScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: NickNameScreenViewProtocol,
       interactor: NickNameScreenInteractorInput,
       factory: NickNameScreenFactoryInput) {
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

// MARK: - NickNameScreenViewOutput

extension NickNameScreenViewController: NickNameScreenViewOutput {}

// MARK: - NickNameScreenInteractorOutput

extension NickNameScreenViewController: NickNameScreenInteractorOutput {}

// MARK: - NickNameScreenFactoryOutput

extension NickNameScreenViewController: NickNameScreenFactoryOutput {}

// MARK: - Private

private extension NickNameScreenViewController {}

// MARK: - Appearance

private extension NickNameScreenViewController {
  struct Appearance {}
}
