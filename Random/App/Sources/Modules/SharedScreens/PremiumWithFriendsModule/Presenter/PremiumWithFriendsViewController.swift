//
//  PremiumWithFriendsViewController.swift
//  Random
//
//  Created by Vitalii Sosin on 24.07.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol PremiumWithFriendsModuleOutput: AnyObject {
  
  /// Модуль был закрыт
  func closeButtonAction()
  
  /// Пользователь скопировал ссылку
  ///  - Parameter link: Ссылка
  func copyLinkAction(_ link: String?)
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol PremiumWithFriendsModuleInput {
  
  /// Выбрать способ показа экрана
  /// - Parameter isModalPresentation: Открывается экран снизу вверх
  func selectIsModalPresentationStyle(_ isModalPresentation: Bool)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: PremiumWithFriendsModuleOutput? { get set }
}

/// Готовый модуль `PremiumWithFriendsModule`
typealias PremiumWithFriendsModule = ViewController & PremiumWithFriendsModuleInput

/// Презентер
final class PremiumWithFriendsViewController: PremiumWithFriendsModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: PremiumWithFriendsModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: PremiumWithFriendsInteractorInput
  private let moduleView: PremiumWithFriendsViewProtocol
  private let factory: PremiumWithFriendsFactoryInput
  private var cacheIsModalPresentation = false
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: PremiumWithFriendsViewProtocol,
       interactor: PremiumWithFriendsInteractorInput,
       factory: PremiumWithFriendsFactoryInput) {
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
    
    navigationItem.largeTitleDisplayMode = .always
    setNavigationBar()
    interactor.getContent()
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
  }
  
  // MARK: - Internal func
  
  func selectIsModalPresentationStyle(_ isModalPresentation: Bool) {
    cacheIsModalPresentation = isModalPresentation
  }
}

// MARK: - PremiumWithFriendsViewOutput

extension PremiumWithFriendsViewController: PremiumWithFriendsViewOutput {
  func doNotShowScreenAgain() {
    interactor.doNotShowScreenAgain()
    moduleOutput?.closeButtonAction()
  }
  
  func copyLinkAction(_ link: String?) {
    moduleOutput?.copyLinkAction(link)
  }
}

// MARK: - PremiumWithFriendsInteractorOutput

extension PremiumWithFriendsViewController: PremiumWithFriendsInteractorOutput {
  func didReceive(referals: [String], link: String) {
    let model = factory.configureModels(isModalPresentation: cacheIsModalPresentation,
                                        referals: referals,
                                        link: link)
    moduleView.updateContentWith(models: model)
  }
}

// MARK: - PremiumWithFriendsFactoryOutput

extension PremiumWithFriendsViewController: PremiumWithFriendsFactoryOutput {}

// MARK: - Private

private extension PremiumWithFriendsViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    title = appearance.title
    
    if cacheIsModalPresentation {
      let closeButton = UIBarButtonItem(image: appearance.closeButtonIcon,
                                        style: .plain,
                                        target: self,
                                        action: #selector(closeButtonAction))
      navigationItem.rightBarButtonItems = [closeButton]
    }
  }
  
  @objc
  func closeButtonAction() {
    moduleOutput?.closeButtonAction()
  }
}

// MARK: - Appearance

private extension PremiumWithFriendsViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.premiumWithFriends
    let closeButtonIcon = UIImage(systemName: "xmark")
  }
}
