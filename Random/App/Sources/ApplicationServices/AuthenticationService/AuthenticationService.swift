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
  
  /// Зарегистрирован пользователь или нет  Возможно этот метод не нужен, посмотреть в дальнейшем
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
  
  /// Выйти из авторизованной зоны Firebase
  /// - Parameter completion: Возвращает результат выполнения
  func signOutFirebaseWith(completion: @escaping (Result<Void, Error>) -> Void)
  
  /// Проверка авторизован пользователь в данный момент или нет в Firebase
  /// - Parameter completion: Возвращает результат выполнения
  func checkIsSignedFirebase(completion: @escaping (_ isSigned: Bool) -> Void)
  
  /// Получить пользовательские данные (Имя, почта, фото, уникальный номер...)
  /// - Parameter completion: Возвращает результат выполнения
  func getUserProfile(completion: @escaping (AuthenticationServiceFirebaseModel?) -> Void)
  
  /// Обновить данные пользователя
  /// - Parameters:
  ///  - model: Модель для обновления данных
  ///  - completion: Возвращает результат выполнения
  func updateUserProfileWith(model: AuthenticationServiceFirebaseModel,
                             completion: @escaping (Result<Void, Error>) -> Void)
  
  /// Обновить почту пользователя
  /// - Parameters:
  ///  - email: Почта
  ///  - completion: Возвращает результат выполнения
  func updateEmail(_ email: String,
                   completion: @escaping (Result<Void, Error>) -> Void)
  
  /// Подтвердить почту
  /// - Parameter completion: Возвращает результат выполнения
  func sendUserVerificationEmail(completion: @escaping (Result<Void, Error>) -> Void)
  
  /// Удалить пользователя
  /// - Parameter completion: Возвращает результат выполнения
  func deleteUser(completion: @escaping (Result<Void, Error>) -> Void)
}

final class AuthenticationServiceImpl: AuthenticationService {
  func deleteUser(completion: @escaping (Result<Void, Error>) -> Void) {
    let user = Auth.auth().currentUser
    user?.delete { error in
      if let error {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
        return
      }
      DispatchQueue.main.async {
        completion(.success(()))
      }
    }
  }
  
  func sendUserVerificationEmail(completion: @escaping (Result<Void, Error>) -> Void) {
    Auth.auth().currentUser?.sendEmailVerification { error in
      if let error {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
        return
      }
      DispatchQueue.main.async {
        completion(.success(()))
      }
    }
  }
  
  func updateEmail(_ email: String,
                   completion: @escaping (Result<Void, Error>) -> Void) {
    Auth.auth().currentUser?.updateEmail(to: email) { error in
      if let error {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
        return
      }
      DispatchQueue.main.async {
        completion(.success(()))
      }
    }
  }
  
  func updateUserProfileWith(model: AuthenticationServiceFirebaseModel,
                             completion: @escaping (Result<Void, Error>) -> Void) {
    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
    
    if let url = model.photoURL {
      changeRequest?.photoURL = URL(string: url)
    }
    changeRequest?.displayName = model.name
    
    changeRequest?.commitChanges { error in
      if let error {
        DispatchQueue.main.async {
          completion(.failure(error))
        }
        return
      }
      DispatchQueue.main.async {
        completion(.success(()))
      }
    }
  }
  
  func getUserProfile(completion: @escaping (AuthenticationServiceFirebaseModel?) -> Void) {
    let user = Auth.auth().currentUser
    guard let user else {
      DispatchQueue.main.async {
        completion(nil)
      }
      return
    }
    
    DispatchQueue.main.async {
      completion(AuthenticationServiceFirebaseModel(name: user.displayName,
                                                    uid: user.uid,
                                                    email: user.email,
                                                    photoURL: user.photoURL?.absoluteString))
    }
  }
  
  func checkIsSignedFirebase(completion: @escaping (_ isSigned: Bool) -> Void) {
    DispatchQueue.main.async {
      if Auth.auth().currentUser != nil {
        completion(true)
      } else {
        completion(false)
      }
    }
  }
  
  func signOutFirebaseWith(completion: @escaping (Result<Void, Error>) -> Void) {
    DispatchQueue.main.async {
      let firebaseAuth = Auth.auth()
      do {
        try firebaseAuth.signOut()
        completion(.success(()))
      } catch {
        completion(.failure(error))
      }
    }
  }
  
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
