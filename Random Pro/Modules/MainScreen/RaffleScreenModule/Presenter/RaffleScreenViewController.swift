//
//  RaffleScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.01.2023.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol RaffleScreenModuleOutput: AnyObject {
  
  /// Ошибка в авторизации
  func authorizationError()
  
  /// Авторизация прошла успешно
  func authorizationSuccess()
  
  /// Ошибка обновления пользовательской информации
  func updateUserProfileError()
  
  /// Информация успешно обновлена
  func updateUserProfileSuccess()
  
  /// Пользователь успешно вышел
  func signOutSuccess()
  
  /// Произошла ошибка при выходе
  func signOutError()
  
  /// Email успешно обновлен
  func updateEmailSuccess()
  
  /// Email не обновлен
  func updateEmailError()
  
  /// Успешное подтверждение почты
  func verificationEmailSuccess()
  
  /// Ошибка в отправке письма для подтверждения почты
  func verificationEmailError()
  
  /// Пользователь успешно удален
  func deleteUserSuccess()
  
  /// Не получилось удалить пользователя
  func deleteUserError()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol RaffleScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: RaffleScreenModuleOutput? { get set }
}

/// Готовый модуль `RaffleScreenModule`
typealias RaffleScreenModule = UIViewController & RaffleScreenModuleInput

/// Презентер
final class RaffleScreenViewController: RaffleScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: RaffleScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: RaffleScreenInteractorInput
  private let moduleView: RaffleScreenViewProtocol
  private let factory: RaffleScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: RaffleScreenViewProtocol,
       interactor: RaffleScreenInteractorInput,
       factory: RaffleScreenFactoryInput) {
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
    
//    interactor.getUserProfile()
    interactor.sendUserVerificationEmail()
  }
}

// MARK: - RaffleScreenViewOutput

extension RaffleScreenViewController: RaffleScreenViewOutput {
  func actionOnSignInWithApple() {
    interactor.actionOnSignInWithApple()
  }
}

// MARK: - RaffleScreenInteractorOutput

extension RaffleScreenViewController: RaffleScreenInteractorOutput {
  func didReceiveIsSigned(_ isSigned: Bool) {
    // TODO: - Пользователь авторизован
  }
  
  func didReceiveUsertWith(model: RaffleScreenModel) {
    // TODO: - Были получены данные пользователя
  }
  
  func deleteUserSuccess() {
    moduleOutput?.deleteUserSuccess()
  }
  
  func deleteUserError() {
    moduleOutput?.deleteUserError()
  }
  
  func verificationEmailSuccess() {
    moduleOutput?.verificationEmailSuccess()
  }
  
  func verificationEmailError() {
    moduleOutput?.verificationEmailError()
  }
  
  func updateEmailSuccess() {
    moduleOutput?.updateEmailSuccess()
  }
  
  func updateEmailError() {
    moduleOutput?.updateEmailError()
  }
  
  func signOutSuccess() {
    moduleOutput?.signOutSuccess()
  }
  
  func signOutError() {
    moduleOutput?.signOutError()
  }
  
  func updateUserProfileSuccess() {
    moduleOutput?.updateUserProfileSuccess()
  }
  
  func updateUserProfileError() {
    moduleOutput?.updateUserProfileError()
  }
  
  func authorizationSuccess() {
    moduleOutput?.authorizationSuccess()
  }
  
  func authorizationError() {
    moduleOutput?.authorizationError()
  }
}

// MARK: - RaffleScreenFactoryOutput

extension RaffleScreenViewController: RaffleScreenFactoryOutput {}

// MARK: - Private

private extension RaffleScreenViewController {}

// MARK: - Appearance

private extension RaffleScreenViewController {
  struct Appearance {}
}
