//
//  ListResultScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.06.2022.
//

import UIKit

/// События которые отправляем из `текущего модуля` в  `другой модуль`
protocol ListResultScreenModuleOutput: AnyObject {
  
}

/// События которые отправляем из `другого модуля` в  `текущий модуль`
protocol ListResultScreenModuleInput {
  
  /// Установить список результатов
  ///  - Parameter list: Список результатов
  func setContentsFrom(list: [String])
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
  var moduleOutput: ListResultScreenModuleOutput? { get set }
}

/// Готовый модуль `ListResultScreenModule`
typealias ListResultScreenModule = UIViewController & ListResultScreenModuleInput

/// Презентер
final class ListResultScreenViewController: ListResultScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: ListResultScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: ListResultScreenInteractorInput
  private let moduleView: ListResultScreenViewProtocol
  private let factory: ListResultScreenFactoryInput
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameters:
  ///   - interactor: интерактор
  ///   - moduleView: вью
  ///   - factory: фабрика
  init(interactor: ListResultScreenInteractorInput,
       moduleView: ListResultScreenViewProtocol,
       factory: ListResultScreenFactoryInput) {
    self.interactor = interactor
    self.moduleView = moduleView
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
    
    title = Appearance().title
    navigationItem.largeTitleDisplayMode = .never
  }
  
  // MARK: - Internal func
  
  func setContentsFrom(list: [String]) {
    moduleView.updateContentWith(list: list)
  }
}

// MARK: - ListResultScreenViewOutput

extension ListResultScreenViewController: ListResultScreenViewOutput {}

// MARK: - ListResultScreenInteractorOutput

extension ListResultScreenViewController: ListResultScreenInteractorOutput {}

// MARK: - ListResultScreenFactoryOutput

extension ListResultScreenViewController: ListResultScreenFactoryOutput {}

// MARK: - Appearance

private extension ListResultScreenViewController {
  struct Appearance {
    let title = NSLocalizedString("Список результатов", comment: "")
  }
}
