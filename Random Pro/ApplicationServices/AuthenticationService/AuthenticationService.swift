//
//  AuthenticationService.swift
//  Random Pro
//
//  Created by SOSIN Vitaly on 10.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import AuthenticationServices
import CryptoKit
import FirebaseFirestore
import FirebaseAuth

protocol AuthenticationService {
  
  /// Сделать запрос в Apple чтобы (зарегистрировать / авторизовать) пользователя
  /// - Parameters:
  ///  - delegate: Делегат запроса на авторизацию
  ///  - nonce: Одноразовый код
  func authenticationRequest(
    delegate: ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding,
    completion: (_ nonce: String) -> Void
  )
  
  /// Зарегистрирован пользователь или нет
  /// - Parameters:
  ///  - forUserID: ID пользователя
  ///  - completion: Зарегистрирован пользователь или нет
  func getIsRegistered(forUserID: String, completion: @escaping (Bool) -> Void)
  
  /// Авторизация в Firebase
  /// - Parameters:
  ///  - idTokenString: Токен пользователя
  ///  - nonce: Одноразовый код
  func authFirebaseWith(idTokenString: String,
                        nonce: String,
                        completion: @escaping (Result<AuthenticationServiceFirebaseModel, Error>) -> Void)
}

final class AuthenticationServiceImpl: AuthenticationService {
  func authFirebaseWith(idTokenString: String,
                        nonce: String,
                        completion: @escaping (Result<AuthenticationServiceFirebaseModel, Error>) -> Void) {
    let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                              idToken: idTokenString,
                                              rawNonce: nonce)
    Auth.auth().signIn(with: credential) { authResult, error in
      if let error {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
        return
      }
      
      let model = AuthenticationServiceFirebaseModel(name: authResult?.user.displayName,
                                                     email: authResult?.user.email)
      DispatchQueue.main.async {
        completion(.success(model))
      }
    }
  }
  
  func authenticationRequest(
    delegate: ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding,
    completion: (_ nonce: String) -> Void
  ) {
    let nonce = randomNonceString()
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    request.nonce = sha256(nonce)
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = delegate
    authorizationController.presentationContextProvider = delegate
    completion(nonce)
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

// MARK: - Private

private extension AuthenticationServiceImpl {
  // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
  func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
      let randoms: [UInt8] = (0 ..< 16).map { _ in
        var random: UInt8 = 0
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if errorCode != errSecSuccess {
          assertionFailure(
            "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
          )
        }
        return random
      }
      
      randoms.forEach { random in
        if remainingLength == 0 {
          return
        }
        
        if random < charset.count {
          result.append(charset[Int(random)])
          remainingLength -= 1
        }
      }
    }
    return result
  }
  
  func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      String(format: "%02x", $0)
    }.joined()
    return hashString
  }
}
