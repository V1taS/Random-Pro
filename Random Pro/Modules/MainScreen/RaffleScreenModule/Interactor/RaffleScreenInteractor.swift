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
}

/// События которые отправляем от Presenter к Interactor
protocol RaffleScreenInteractorInput {
  
  /// Пользователь нажал Войти / Зарегистрироваться
  func actionOnSignInWithApple()
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
      case let .success(model):
        // TODO: - Пользователь зарегистрирован
        
        let fullName = "\(appleIDCredential.fullName?.familyName ?? "") \(appleIDCredential.fullName?.middleName ?? "")"
        let newModel = RaffleScreenModel(avatar: self?.model?.avatar ?? Appearance().defaultAvatar,
                                         identifier: appleIDCredential.user,
                                         fullName: fullName,
                                         email: appleIDCredential.email)
        self?.model = newModel
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
