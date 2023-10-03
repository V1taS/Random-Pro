//
//  CubesStyleSelectionScreenViewController.swift
//  Random
//
//  Created by Сергей Юханов on 03.10.2023.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol CubesStyleSelectionScreenModuleOutput: AnyObject {}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol CubesStyleSelectionScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: CubesStyleSelectionScreenModuleOutput? { get set }
}

/// Готовый модуль `CubesStyleSelectionScreenModule`
typealias CubesStyleSelectionScreenModule = UIViewController & CubesStyleSelectionScreenModuleInput

/// Презентер
final class CubesStyleSelectionScreenViewController: CubesStyleSelectionScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: CubesStyleSelectionScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: CubesStyleSelectionScreenInteractorInput
  private let moduleView: CubesStyleSelectionScreenViewProtocol
  private let factory: CubesStyleSelectionScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: CubesStyleSelectionScreenViewProtocol,
       interactor: CubesStyleSelectionScreenInteractorInput,
       factory: CubesStyleSelectionScreenFactoryInput) {
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

// MARK: - CubesStyleSelectionScreenViewOutput

extension CubesStyleSelectionScreenViewController: CubesStyleSelectionScreenViewOutput {}

// MARK: - CubesStyleSelectionScreenInteractorOutput

extension CubesStyleSelectionScreenViewController: CubesStyleSelectionScreenInteractorOutput {}

// MARK: - CubesStyleSelectionScreenFactoryOutput

extension CubesStyleSelectionScreenViewController: CubesStyleSelectionScreenFactoryOutput {}

// MARK: - Private

private extension CubesStyleSelectionScreenViewController {}

// MARK: - Appearance

private extension CubesStyleSelectionScreenViewController {
  struct Appearance {}
}
