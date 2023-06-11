//
//  FortuneWheelViewController.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol FortuneWheelModuleOutput: AnyObject {}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol FortuneWheelModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: FortuneWheelModuleOutput? { get set }
}

/// Готовый модуль `FortuneWheelModule`
typealias FortuneWheelModule = UIViewController & FortuneWheelModuleInput

/// Презентер
final class FortuneWheelViewController: FortuneWheelModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: FortuneWheelModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: FortuneWheelInteractorInput
  private let moduleView: FortuneWheelViewProtocol
  private let factory: FortuneWheelFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: FortuneWheelViewProtocol,
       interactor: FortuneWheelInteractorInput,
       factory: FortuneWheelFactoryInput) {
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

// MARK: - FortuneWheelViewOutput

extension FortuneWheelViewController: FortuneWheelViewOutput {}

// MARK: - FortuneWheelInteractorOutput

extension FortuneWheelViewController: FortuneWheelInteractorOutput {}

// MARK: - FortuneWheelFactoryOutput

extension FortuneWheelViewController: FortuneWheelFactoryOutput {}

// MARK: - Private

private extension FortuneWheelViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(image: appearance.settingsButtonIcon,
                      style: .plain,
                      target: self,
                      action: #selector(settingButtonAction)),
    ]
  }
  
  @objc
  func settingButtonAction() {
    // TODO: -
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension FortuneWheelViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.fortuneWheel
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}
