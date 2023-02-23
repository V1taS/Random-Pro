//
//  AuthenticationServiceFirebaseModel.swift
//  AuthenticationService
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

public struct AuthenticationServiceFirebaseModel {
  
  /// Уникальный номер пользователя
  public var uid: String?
  
  /// Имя пользователя
  public let name: String?
  
  /// Электронная почта пользователя
  public var email: String?
  
  /// Ссылка на аватарку
  public var photoURL: String?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - name: Имя пользователя
  ///   - uid: Уникальный номер пользователя
  ///   - email: Электронная почта пользователя
  ///   - photoURL: Ссылка на аватарку
  public init(name: String?,
              uid: String? = nil,
              email: String? = nil,
              photoURL: String? = nil) {
    self.uid = uid
    self.name = name
    self.email = email
    self.photoURL = photoURL
  }
}
