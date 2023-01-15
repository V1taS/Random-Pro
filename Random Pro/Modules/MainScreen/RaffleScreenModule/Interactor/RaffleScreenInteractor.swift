//
//  RaffleScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.01.2023.
//

import UIKit
import AuthenticationServices

/// События которые отправляем из Interactor в Presenter
protocol RaffleScreenInteractorOutput: AnyObject {
  
  /// Авторизация прошла успешно
  func authorizationSuccess()
  
  /// Ошибка в авторизации
  func authorizationError()
  
  /// Информация успешно обновлена
  func updateUserProfileSuccess()
  
  /// Ошибка обновления пользовательской информации
  func updateUserProfileError()
  
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
  
  /// Был получен контент
  /// - Parameter model: Модель данных
  func didReceiveUsertWith(model: RaffleScreenModel)
  
  /// Был получен результат авторизации пользователя
  /// - Parameter isSigned: Пользователь авторизован
  func didReceiveIsSigned(_ isSigned: Bool)
}

/// События которые отправляем от Presenter к Interactor
protocol RaffleScreenInteractorInput {
  
  /// Пользователь нажал Войти / Зарегистрироваться
  func actionOnSignInWithApple()
  
  /// Получить профиль пользователя
  func getUserProfile()
  
  /// Обновить профиль пользователя
  /// - Parameters:
  ///  - name: Имя пользователя
  ///  - photoURL: Ссылка на аватарку пользователя
  func updateUserProfileWith(name: String?, photoURL: String?)
  
  /// Выйти из аккаунта на сервере
  func signOut()
  
  /// Проверить авторизацию у пользователя
  func checkIsSigned()
  
  /// Обновить email
  /// - Parameter email: Электронная почта
  func updateEmail(_ email: String)
  
  /// Отправить пользователю письмо с подтверждением почты
  func sendUserVerificationEmail()
  
  /// Удалить пользователя
  func deleteUser()
}

/// Интерактор
final class RaffleScreenInteractor: NSObject, RaffleScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: RaffleScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private let authenticationService: AuthenticationService
  @ObjectCustomUserDefaultsWrapper(key: Appearance().keyUserDefaults)
  private var model: RaffleScreenModel?
  private var currentNonce: String?
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameter authenticationService: Сервис авторизации пользователей
  init(authenticationService: AuthenticationService) {
    self.authenticationService = authenticationService
  }
  
  // MARK: - Internal func
  
  func deleteUser() {
    authenticationService.deleteUser { [weak self] result in
      switch result {
      case .success:
        self?.output?.deleteUserSuccess()
      case .failure:
        self?.output?.deleteUserError()
      }
    }
  }
  
  func sendUserVerificationEmail() {
    authenticationService.sendUserVerificationEmail { [weak self] result in
      switch result {
      case .success:
        self?.output?.verificationEmailSuccess()
      case .failure:
        self?.output?.verificationEmailError()
      }
    }
  }
  
  func updateEmail(_ email: String) {
    authenticationService.updateEmail(email) { [weak self] result in
      switch result {
      case .success:
        self?.output?.updateEmailSuccess()
      case .failure:
        self?.output?.updateEmailError()
      }
    }
  }
  
  func checkIsSigned() {
    authenticationService.checkIsSignedFirebase { [weak self] isSigned in
      self?.output?.didReceiveIsSigned(isSigned)
    }
  }
  
  func signOut() {
    authenticationService.signOutFirebaseWith { [weak self] result in
      switch result {
      case .success:
        self?.output?.signOutSuccess()
      case .failure:
        self?.output?.signOutError()
      }
    }
  }
  
  func updateUserProfileWith(name: String?, photoURL: String?) {
    let model = AuthenticationServiceFirebaseModel(name: name,
                                                   photoURL: photoURL)
    authenticationService.updateUserProfileWith(model: model) { [weak self] result in
      switch result {
      case .success:
        self?.output?.updateUserProfileSuccess()
      case .failure:
        self?.output?.updateUserProfileError()
      }
    }
  }
  
  func getUserProfile() {
    if let model {
      output?.didReceiveUsertWith(model: model)
    } else {
      authenticationService.getUserProfile { [weak self] result in
        // TODO: - Сделать загрузку аватарки
        let newModel = RaffleScreenModel(avatar: Data(),
                                         identifier: result?.uid,
                                         fullName: result?.name,
                                         email: result?.email)
        self?.model = newModel
        self?.output?.didReceiveUsertWith(model: newModel)
      }
    }
  }
  
  func actionOnSignInWithApple() {
    authenticationService.authenticationRequest(delegate: self) { [weak self] nonce in
      self?.currentNonce = nonce
    }
  }
}

// MARK: - ASAuthorizationControllerDelegate

extension RaffleScreenInteractor: ASAuthorizationControllerDelegate {
  
  func authorizationController(controller: ASAuthorizationController,
                               didCompleteWithAuthorization authorization: ASAuthorization) {
    guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
          let nonce = currentNonce,
          let appleIDToken = appleIDCredential.identityToken,
          let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
      DispatchQueue.main.async { [weak self] in
        self?.output?.authorizationError()
      }
      return
    }
    
    authenticationService.authFirebaseWith(idTokenString: idTokenString,
                                           nonce: nonce) { [weak self] result in
      switch result {
      case .success:
        DispatchQueue.global().async {
          let fullName = "\(appleIDCredential.fullName?.familyName ?? "") \(appleIDCredential.fullName?.middleName ?? "")"
          let model = AuthenticationServiceFirebaseModel(name: fullName)
          self?.authenticationService.updateUserProfileWith(model: model) { _ in }
        }
        
        self?.output?.authorizationSuccess()
      case .failure:
        self?.output?.authorizationError()
      }
    }
  }
  
  func authorizationController(controller: ASAuthorizationController,
                               didCompleteWithError error: Error) {
    DispatchQueue.main.async { [weak self] in
      self?.output?.authorizationError()
    }
  }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension RaffleScreenInteractor: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIWindow()
  }
}

// MARK: - Appearance

private extension RaffleScreenInteractor {
  struct Appearance {
    let keyUserDefaults = "raffle_screen_user_defaults_key"
    let defaultAvatar = Data()
  }
}
