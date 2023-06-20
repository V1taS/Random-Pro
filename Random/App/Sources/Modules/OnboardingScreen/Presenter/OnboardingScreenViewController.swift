//
//  OnboardingScreenViewController.swift
//  Random
//
//  Created by Artem Pavlov on 17.06.2023.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol OnboardingScreenModuleOutput: AnyObject {

  /// Что-то пошло не так
  func somethingWentWrong()

  /// Модуль был закрыт
  func closeButtonAction()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol OnboardingScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: OnboardingScreenModuleOutput? { get set }
}

/// Готовый модуль `OnboardingScreenModule`
typealias OnboardingScreenModule = UIViewController & OnboardingScreenModuleInput

/// Презентер
final class OnboardingScreenViewController: OnboardingScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: OnboardingScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: OnboardingScreenInteractorInput
  private let moduleView: OnboardingScreenViewProtocol
  private let factory: OnboardingScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: OnboardingScreenViewProtocol,
       interactor: OnboardingScreenInteractorInput,
       factory: OnboardingScreenFactoryInput) {
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

    interactor.getOnbordingScreens() //
    navigationItem.largeTitleDisplayMode = .never
    setNavigationBar()
  }
}

// MARK: - OnboardingScreenViewOutput

extension OnboardingScreenViewController: OnboardingScreenViewOutput {
  func didChangeOnboardingPage() {
    
  }
}

// MARK: - OnboardingScreenInteractorOutput

extension OnboardingScreenViewController: OnboardingScreenInteractorOutput {
  func didReceive() {
    factory.createListModelWith() //
  }

  func somethingWentWrong() {
    moduleOutput?.somethingWentWrong()
  }

}

// MARK: - OnboardingScreenFactoryOutput

extension OnboardingScreenViewController: OnboardingScreenFactoryOutput {
  func didReceive(models: [OnboardingScreenModel]) {
    moduleView.updateContentWith(models: models) //
  }
}

// MARK: - Private

private extension OnboardingScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    title = appearance.title

      let closeButton = UIBarButtonItem(image: appearance.closeButtonIcon,
                                        style: .plain,
                                        target: self,
                                        action: #selector(closeButtonAction))

      navigationItem.rightBarButtonItems = [closeButton]
  }

  @objc
  func closeButtonAction() {
    moduleOutput?.closeButtonAction()
  }
}

// MARK: - Appearance

private extension OnboardingScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.premium
    let closeButtonIcon = UIImage(systemName: "xmark")
  }
}
