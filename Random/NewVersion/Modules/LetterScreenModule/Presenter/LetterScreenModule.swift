//
//  LetterScreenModule.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 16.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

protocol LetterScreenModuleOutput: AnyObject {
  
}

protocol LetterScreenModuleInput: AnyObject {
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
  var moduleOutput: LetterScreenModuleOutput? { get set }
}

typealias LetterScreenModule = UIViewController & LetterScreenModuleInput

final class LetterScreenViewController: LetterScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: LetterScreenModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: LetterScreenViewProtocol
  private let interactor: LetterScreenInteractorInput
  private let factory: LetterScreenFactoryInput
  
  // MARK: - Initialization
  
  init(moduleView: LetterScreenViewProtocol,
       interactor: LetterScreenInteractorInput,
       factory: LetterScreenFactoryInput) {
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
    navigationBar()
    interactor.getContent()
  }
  
  // MARK: - Private func
  
  private func navigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.settingsButtonIcon,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(settingButtonAction))
  }
  
  @objc private func settingButtonAction() {
  }
}

// MARK: - LetterScreenViewOutput

extension LetterScreenViewController: LetterScreenViewOutput {
  func generateEngButtonAction() {
    interactor.generateContentEngLetter()
  }
  
  func generateRusButtonAction() {
    interactor.generateContentRusLetter()
  }
}

// MARK: - LetterScreenInteractorOutput

extension LetterScreenViewController: LetterScreenInteractorOutput {
  func didRecive(result: String?) {
    moduleView.set(result: result)
  }
  
  func didRecive(listResult: [String]) {
    factory.resive(listResult: listResult)
  }
}

// MARK: - LetterScreenFactoryOutput

extension LetterScreenViewController: LetterScreenFactoryOutput {
  func didReverse(listResult: [String]) {
    moduleView.set(listResult: listResult)
  }
}

// MARK: - Appearance

private extension LetterScreenViewController {
  struct Appearance {
    let title = NSLocalizedString("Буква", comment: "")
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}
