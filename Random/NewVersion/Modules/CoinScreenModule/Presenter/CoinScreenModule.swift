//
//  CoinScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 17.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol CoinScreenModuleOutput: AnyObject {
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: CoinScreenModel)
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: CoinScreenModel)
}

protocol CoinScreenModuleInput: AnyObject {
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  var moduleOutput: CoinScreenModuleOutput? { get set }
}

typealias CoinScreenModule = UIViewController & CoinScreenModuleInput

final class CoinScreenViewController: CoinScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: CoinScreenModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: CoinScreenViewProtocol
  private let interactor: CoinScreenInteractorInput
  private let factory: CoinScreenFactoryInput
  private var cacheModel: CoinScreenModel?
  
  // MARK: - Initialization
  
  init(moduleView: CoinScreenViewProtocol,interactor: CoinScreenInteractorInput,
       factory: CoinScreenFactoryInput) {
    
    self.moduleView = moduleView
    self.interactor = interactor
    self.factory = factory
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  override func loadView() {
    super.loadView()
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.getContent()
    settingNavigationBar()
  }
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
  
  // MARK: - Private func
  
  private func settingNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.settingsButtonIcon, style: .plain,
                                                        target: self, action: #selector(settingsButtonAction))
  }
  
  @objc
  private func settingsButtonAction() {
    guard let model = cacheModel else {
      return
    }
    moduleOutput?.settingButtonAction(model: model)
  }
}

// MARK: - CoinScreenViewOutput

extension CoinScreenViewController: CoinScreenViewOutput {
  func generateButtonAction() {
    interactor.generateContentCoin()
  }
}

// MARK: - CoinScreenInteractorOutput

extension CoinScreenViewController: CoinScreenInteractorOutput {
  func cleanButtonWasSelected(model: CoinScreenModel) {
    cacheModel = model
    moduleOutput?.cleanButtonWasSelected(model: model)
  }
  
  func didRecive(model: CoinScreenModel) {
    cacheModel = model
    factory.reverseListResultFrom(model: model)
  }
}

// MARK: - CoinScreenFactoryOutput

extension CoinScreenViewController: CoinScreenFactoryOutput {
  func didReverseListResult(model: CoinScreenModel) {
    moduleView.updateContentWith(model: model)
  }
}

// MARK: - Private Appearance

private extension CoinScreenViewController {
  struct Appearance {
    let title =  NSLocalizedString("Орел или Pешка", comment: "")
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}
