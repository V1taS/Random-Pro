//
//  CubesScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 15.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего модуля` в  `другой модуль
protocol CubesScreenModuleOutput: AnyObject {}

/// События которые отправляем из `другого модуля` в  `текущий модуль`
protocol CubesScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
  var moduleOutput: CubesScreenModuleOutput? { get set }
}

typealias CubesScreenModule = UIViewController & CubesScreenModuleInput

final class CubesScreenViewController: CubesScreenModule {
  
  weak var moduleOutput: CubesScreenModuleOutput?
  
  private let moduleView: CubesScreenViewProtocol
  private let interactor: CubesScreenInteractorInput
  private let factory: CubesScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - interactor: интерактор
  ///   - moduleView: вью
  ///   - factory: фабрика
  init(moduleView: CubesScreenViewProtocol,
       interactor: CubesScreenInteractorInput,
       factory: CubesScreenFactoryInput) {
    self.moduleView = moduleView
    self.interactor = interactor
    self.factory = factory
    super.init(nibName: nil, bundle: nil)
  }
  
  override func loadView() {
    super.loadView()
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavigationBar()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private func
  
  private func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = "Кубики"
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.settingsButtonIcon,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(settingButtonAction))
  }
  
  @objc private func settingButtonAction() {}
}


extension CubesScreenViewController: CubesScreenViewOutput {
  func generateButtonAction() {}
}

extension CubesScreenViewController: CubesScreenInteractorOutput {}

extension CubesScreenViewController: CubesScreenFactoryOutput {}

extension CubesScreenViewController {
  struct Appearance {
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}

