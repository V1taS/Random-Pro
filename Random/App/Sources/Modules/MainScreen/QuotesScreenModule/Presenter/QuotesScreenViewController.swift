//
//  QuotesScreenViewController.swift
//  Random
//
//  Created by Mikhail Kolkov on 6/8/23.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol QuotesScreenModuleOutput: AnyObject {}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol QuotesScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: QuotesScreenModuleOutput? { get set }
}

/// Готовый модуль `QuotesScreenModule`
typealias QuotesScreenModule = UIViewController & QuotesScreenModuleInput

/// Презентер
final class QuotesScreenViewController: QuotesScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: QuotesScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: QuotesScreenInteractorInput
  private let moduleView: QuotesScreenViewProtocol
  private let factory: QuotesScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: QuotesScreenViewProtocol,
       interactor: QuotesScreenInteractorInput,
       factory: QuotesScreenFactoryInput) {
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

// MARK: - QuotesScreenViewOutput

extension QuotesScreenViewController: QuotesScreenViewOutput {}

// MARK: - QuotesScreenInteractorOutput

extension QuotesScreenViewController: QuotesScreenInteractorOutput {}

// MARK: - QuotesScreenFactoryOutput

extension QuotesScreenViewController: QuotesScreenFactoryOutput {}

// MARK: - Private

private extension QuotesScreenViewController {}

// MARK: - Appearance

private extension QuotesScreenViewController {
  struct Appearance {}
}
