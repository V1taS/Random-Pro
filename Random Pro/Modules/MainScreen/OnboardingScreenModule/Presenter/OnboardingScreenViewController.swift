//
//  OnboardingScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 17.09.2022.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol OnboardingScreenModuleOutput: AnyObject {
  
  /// Закончить онбоардинг
  func onboardingDidFinish()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol OnboardingScreenModuleInput {
  
  /// Вернуть текущую модель
  func returnCurrentModels() -> [OnboardingScreenModel]
  
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
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
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
    
    interactor.getContent(OnboardingScreenFactory.createOnboardingModels())
  }
  
  // MARK: - Internal func
  
  func returnCurrentModels() -> [OnboardingScreenModel] {
    OnboardingScreenInteractor.returnCurrentModels()
  }
}

// MARK: - OnboardingScreenViewOutput

extension OnboardingScreenViewController: OnboardingScreenViewOutput {
  func didPressCloseButton() {
    moduleOutput?.onboardingDidFinish()
    impactFeedback.impactOccurred()
  }
  
  func didPressButton(to page: Int) {
    interactor.didPressButton(to: page)
  }
  
  func didChangePage(to page: Int) {
    interactor.changePage(to: page)
  }
}

// MARK: - OnboardingScreenInteractorOutput

extension OnboardingScreenViewController: OnboardingScreenInteractorOutput {
  func didReceiveButton(title: String) {
    moduleView.setButtonTitle(title)
  }
  
  func didReceiveCurrent(screen: Int) {
    moduleView.setPage(screen)
  }
  
  func didReceiveScreens(_ screens: [OnboardingScreenModel]) {
    moduleView.setOnboardingWith(screens)
  }
  
  func onboardingDidFinish() {
    moduleOutput?.onboardingDidFinish()
  }
}

// MARK: - OnboardingScreenFactoryOutput

extension OnboardingScreenViewController: OnboardingScreenFactoryOutput {}

// MARK: - Appearance

private extension OnboardingScreenViewController {
  struct Appearance {}
}
