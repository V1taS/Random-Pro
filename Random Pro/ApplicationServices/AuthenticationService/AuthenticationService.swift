//
//  AuthenticationService.swift
//  Random Pro
//
//  Created by SOSIN Vitaly on 10.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import AuthenticationServices

protocol AuthenticationService {

  /// Сделать запрос в Apple чтобы (зарегистрировать / авторизовать) пользователя
  func authenticationRequest(delegate: ASAuthorizationControllerDelegate)

  /// Зарегистрирован пользователь или нет
  func getIsRegistered(forUserID: String, completion: @escaping (Bool) -> Void)
}

final class AuthenticationServiceImpl: AuthenticationService {
  func authenticationRequest(delegate: ASAuthorizationControllerDelegate) {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = delegate
    authorizationController.performRequests()
  }

  func getIsRegistered(forUserID: String, completion: @escaping (Bool) -> Void) {
    let appleIDProvider = ASAuthorizationAppleIDProvider()

    DispatchQueue.global().async {
      appleIDProvider.getCredentialState(forUserID: forUserID) { credentialState, error in
        if error != nil {
          DispatchQueue.main.async {
            completion(false)
          }
          return
        }

        switch credentialState {
        case .authorized:
          DispatchQueue.main.async {
            completion(true)
          }
          return
        default:
          DispatchQueue.main.async {
            completion(false)
          }
          return
        }
      }
    }
  }
}

//extension AuthenticationServiceImpl: ASAuthorizationControllerDelegate {
//  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//      let userIdentifier = appleIDCredential.user
//      let fullName = appleIDCredential.fullName
//      let email = appleIDCredential.email
//    }
//  }
//
//  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//    // Handle error.
//  }
//}
