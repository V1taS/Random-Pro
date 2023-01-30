//
//  FilmsScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.01.2023.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol FilmsScreenModuleOutput: AnyObject {}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol FilmsScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: FilmsScreenModuleOutput? { get set }
}

/// Готовый модуль `FilmsScreenModule`
typealias FilmsScreenModule = UIViewController & FilmsScreenModuleInput

/// Презентер
final class FilmsScreenViewController: FilmsScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: FilmsScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: FilmsScreenInteractorInput
  private let moduleView: FilmsScreenViewProtocol
  private let factory: FilmsScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: FilmsScreenViewProtocol,
       interactor: FilmsScreenInteractorInput,
       factory: FilmsScreenFactoryInput) {
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
    
    setNavigationBar(isPlayTrailerEnabled: true)
  }
}

// MARK: - FilmsScreenViewOutput

extension FilmsScreenViewController: FilmsScreenViewOutput {}

// MARK: - FilmsScreenInteractorOutput

extension FilmsScreenViewController: FilmsScreenInteractorOutput {}

// MARK: - FilmsScreenFactoryOutput

extension FilmsScreenViewController: FilmsScreenFactoryOutput {}

// MARK: - Private

private extension FilmsScreenViewController {
  func setNavigationBar(isPlayTrailerEnabled: Bool) {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    
    let playTrailerImageName = isPlayTrailerEnabled ? appearance.playTrailerImageEnabledName : appearance.playTrailerImageDisabledName
    
    let playTrailerButton = UIBarButtonItem.menuButton(self,
                                                       action: #selector(playTrailerAction),
                                                       imageName: playTrailerImageName,
                                                       size: CGSize(width: 33,
                                                                    height: 28))
    playTrailerButton.isEnabled = isPlayTrailerEnabled
    navigationItem.rightBarButtonItems = [playTrailerButton]
  }
  
  @objc
  func playTrailerAction() {
    
    impactFeedback.impactOccurred()
  }
}

// MARK: - UIBarButtonItem

private extension UIBarButtonItem {
  static func menuButton(_ target: Any?,
                         action: Selector,
                         imageName: String,
                         size: CGSize) -> UIBarButtonItem {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
    button.addTarget(target, action: action, for: .touchUpInside)
    
    let menuBarItem = UIBarButtonItem(customView: button)
    menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
    menuBarItem.customView?.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    menuBarItem.customView?.widthAnchor.constraint(equalToConstant: size.width).isActive = true
    return menuBarItem
  }
}

// MARK: - Appearance

private extension FilmsScreenViewController {
  struct Appearance {
    let playTrailerImageEnabledName = "play_trailer_enabled"
    let playTrailerImageDisabledName = "play_trailer_disabled"
  }
}
