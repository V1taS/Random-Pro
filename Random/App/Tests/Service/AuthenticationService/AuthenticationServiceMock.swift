//
//  AuthenticationServiceMock.swift
//  RandomTests
//
//  Created by Vitalii Sosin on 27.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import AuthenticationServices
import CryptoKit
import FirebaseFirestore
import FirebaseAuth
import XCTest
@testable import Random

final class AuthenticationServiceMock: AuthenticationService {
  
  // Spy variables
  var authenticationRequestCalled = false
  var getIsRegisteredCalled = false
  var authFirebaseWithCalled = false
  var signOutFirebaseWithCalled = false
  var checkIsSignedFirebaseCalled = false
  var getUserProfileCalled = false
  var updateUserProfileWithCalled = false
  var updateEmailCalled = false
  var sendUserVerificationEmailCalled = false
  var deleteUserCalled = false
  
  // Stub variables
  var authenticationRequestStub: (() -> Void)?
  var getIsRegisteredStub: (() -> Void)?
  var authFirebaseWithStub: (() -> Void)?
  var signOutFirebaseWithStub: (() -> Void)?
  var checkIsSignedFirebaseStub: (() -> Void)?
  var getUserProfileStub: (() -> Void)?
  var updateUserProfileWithStub: (() -> Void)?
  var updateEmailStub: (() -> Void)?
  var sendUserVerificationEmailStub: (() -> Void)?
  var deleteUserStub: (() -> Void)?
  
  func authenticationRequest(
    delegate: ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding,
    completion: (String) -> Void
  ) {
    authenticationRequestCalled = true
    authenticationRequestStub?()
    completion("")
  }
  
  func getIsRegistered(forUserID: String, completion: @escaping (Bool) -> Void) {
    getIsRegisteredCalled = true
    getIsRegisteredStub?()
    completion(false)
  }
  
  func authFirebaseWith(
    idTokenString: String,
    nonce: String,
    completion: @escaping (Result<Random.AuthenticationServiceFirebaseModel, Error>) -> Void
  ) {
    authFirebaseWithCalled = true
    authFirebaseWithStub?()
    completion(.success(.init(name: nil)))
  }
  
  func signOutFirebaseWith(completion: @escaping (Result<Void, Error>) -> Void) {
    signOutFirebaseWithCalled = true
    signOutFirebaseWithStub?()
    completion(.success(()))
  }
  
  func checkIsSignedFirebase(completion: @escaping (Bool) -> Void) {
    checkIsSignedFirebaseCalled = true
    checkIsSignedFirebaseStub?()
    completion(false)
  }
  
  func getUserProfile(completion: @escaping (Random.AuthenticationServiceFirebaseModel?) -> Void) {
    getUserProfileCalled = true
    getUserProfileStub?()
    completion(nil)
  }
  
  func updateUserProfileWith(
    model: Random.AuthenticationServiceFirebaseModel,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    updateUserProfileWithCalled = true
    updateUserProfileWithStub?()
    completion(.success(()))
  }
  
  func updateEmail(_ email: String, completion: @escaping (Result<Void, Error>) -> Void) {
    updateEmailCalled = true
    updateEmailStub?()
    completion(.success(()))
  }
  
  func sendUserVerificationEmail(completion: @escaping (Result<Void, Error>) -> Void) {
    sendUserVerificationEmailCalled = true
    sendUserVerificationEmailStub?()
    completion(.success(()))
  }
  
  func deleteUser(completion: @escaping (Result<Void, Error>) -> Void) {
    deleteUserCalled = true
    deleteUserStub?()
    completion(.success(()))
  }
}
