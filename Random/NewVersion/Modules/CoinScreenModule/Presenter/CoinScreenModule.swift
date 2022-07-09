//
//  CoinScreenModule.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 17.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol CoinScreenModuleOutput: AnyObject {
  
  /// Была нажата кнопка (настройки)
  func settingsButtonAction()
}

protocol CoinScreenModuleInput: AnyObject {
  
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
  
  // MARK: - Private func
  
  private func settingNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.settingsButtonIcon, style: .plain,
                                                        target: self, action: #selector(settingsButtonAction))
  }
  
  @objc private func settingsButtonAction() {
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
  func didReciveName(result: String) {
    moduleView.setName(result: result)
  }
  
  func didReciveImage(result: UIImage?) {
    moduleView.setImage(resultImage: result)
  }
  
  func didRecive(listResult: [String]) {
    factory.revers(listResult: listResult)
  }
}

// MARK: - CoinScreenFactoryOutput

extension CoinScreenViewController: CoinScreenFactoryOutput {
  func didRevarsed(listResult: [String]) {
    moduleView.set(listResult: listResult)
  }
}

// MARK: - Private Appearance

private extension CoinScreenViewController {
  struct Appearance {
    let title =  NSLocalizedString("Орел или Pешка", comment: "")
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}
