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
  var isRegistered: Bool?
  var firebaseAuthResult: Result<Random.AuthenticationServiceFirebaseModel, Error>?
  var firebaseSignOutResult: Result<Void, Error>?
  var isSignedFirebase: Bool?
  var userProfile: Random.AuthenticationServiceFirebaseModel?
  var updateProfileResult: Result<Void, Error>?
  var updateEmailResult: Result<Void, Error>?
  var sendUserVerificationEmailResult: Result<Void, Error>?
  var deleteUserResult: Result<Void, Error>?
  
  func authenticationRequest(
    delegate: ASAuthorizationControllerDelegate & ASAuthorizationControllerPresentationContextProviding,
    completion: (String) -> Void
  ) {
    authenticationRequestCalled = true
  }
  
  func getIsRegistered(forUserID: String, completion: @escaping (Bool) -> Void) {
    getIsRegisteredCalled = true
    if let isRegistered = isRegistered {
      completion(isRegistered)
    }
  }
  
  func authFirebaseWith(
    idTokenString: String,
    nonce: String,
    completion: @escaping (Result<Random.AuthenticationServiceFirebaseModel, Error>) -> Void
  ) {
    authFirebaseWithCalled = true
    if let firebaseAuthResult = firebaseAuthResult {
      completion(firebaseAuthResult)
    }
  }
  
  func signOutFirebaseWith(completion: @escaping (Result<Void, Error>) -> Void) {
    signOutFirebaseWithCalled = true
    if let firebaseSignOutResult = firebaseSignOutResult {
      completion(firebaseSignOutResult)
    }
  }
  
  func checkIsSignedFirebase(completion: @escaping (Bool) -> Void) {
    checkIsSignedFirebaseCalled = true
    if let isSignedFirebase = isSignedFirebase {
      completion(isSignedFirebase)
    }
  }
  
  func getUserProfile(completion: @escaping (Random.AuthenticationServiceFirebaseModel?) -> Void) {
    getUserProfileCalled = true
    completion(userProfile)
  }
  
  func updateUserProfileWith(
    model: Random.AuthenticationServiceFirebaseModel,
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    updateUserProfileWithCalled = true
    if let updateProfileResult = updateProfileResult {
      completion(updateProfileResult)
    }
  }
  
  func updateEmail(_ email: String, completion: @escaping (Result<Void, Error>) -> Void) {
    updateEmailCalled = true
    if let updateEmailResult = updateEmailResult {
      completion(updateEmailResult)
    }
  }
  
  func sendUserVerificationEmail(completion: @escaping (Result<Void, Error>) -> Void) {
    sendUserVerificationEmailCalled = true
    if let sendUserVerificationEmailResult = sendUserVerificationEmailResult {
      completion(sendUserVerificationEmailResult)
    }
  }
  
  func deleteUser(completion: @escaping (Result<Void, Error>) -> Void) {
    deleteUserCalled = true
    if let deleteUserResult = deleteUserResult {
      completion(deleteUserResult)
    }
  }
}
