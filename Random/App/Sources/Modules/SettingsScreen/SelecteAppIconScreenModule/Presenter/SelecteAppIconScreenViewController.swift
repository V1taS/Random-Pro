//
//  SelecteAppIconScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 25.01.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol SelecteAppIconScreenModuleOutput: AnyObject {
  
  /// Нет премиум доступа
  func noPremiumAccessAction()
  
  /// Икнока успешно выбрана
  func iconSelectedSuccessfully()
  
  /// Что-то пошло не так
  func somethingWentWrong()
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol SelecteAppIconScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: SelecteAppIconScreenModuleOutput? { get set }
}

/// Готовый модуль `SelecteAppIconScreenModule`
typealias SelecteAppIconScreenModule = ViewController & SelecteAppIconScreenModuleInput

/// Презентер
final class SelecteAppIconScreenViewController: SelecteAppIconScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: SelecteAppIconScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: SelecteAppIconScreenInteractorInput
  private let moduleView: SelecteAppIconScreenViewProtocol
  private let factory: SelecteAppIconScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: SelecteAppIconScreenViewProtocol,
       interactor: SelecteAppIconScreenInteractorInput,
       factory: SelecteAppIconScreenFactoryInput) {
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
    
    title = Appearance().title
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    interactor.getContent()
    navigationItem.largeTitleDisplayMode = .never
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
  }
}

// MARK: - SelecteAppIconScreenViewOutput

extension SelecteAppIconScreenViewController: SelecteAppIconScreenViewOutput {
  func noPremiumAccessAction() {
    moduleOutput?.noPremiumAccessAction()
  }
  
  func didSelectImage(type: SelecteAppIconType) {
    factory.createListModelWith(selectImageType: type, and: interactor.returnIsPremium())
    interactor.updateAppIcon(type: type)
  }
}

// MARK: - SelecteAppIconScreenInteractorOutput

extension SelecteAppIconScreenViewController: SelecteAppIconScreenInteractorOutput {
  func iconSelectedSuccessfully() {
    moduleOutput?.iconSelectedSuccessfully()
  }
  
  func somethingWentWrong() {
    moduleOutput?.somethingWentWrong()
  }
  
  func didReceive(selecteIconType: SelecteAppIconType, isPremium: Bool) {
    factory.createListModelWith(selectImageType: selecteIconType, and: isPremium)
  }
}

// MARK: - SelecteAppIconScreenFactoryOutput

extension SelecteAppIconScreenViewController: SelecteAppIconScreenFactoryOutput {
  func didReceive(models: [SelecteAppIconScreenType]) {
    moduleView.updateContentWith(models: models)
  }
}

// MARK: - Private

private extension SelecteAppIconScreenViewController {}

// MARK: - Appearance

private extension SelecteAppIconScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.chooseIcon
  }
}
