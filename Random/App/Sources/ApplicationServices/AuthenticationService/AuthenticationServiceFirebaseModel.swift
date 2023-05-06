//
//  AuthenticationServiceFirebaseModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct AuthenticationServiceFirebaseModel {
  
  /// Уникальный номер пользователя
  var uid: String?
  
  /// Имя пользователя
  let name: String?
  
  /// Электронная почта пользователя
  var email: String?
  
  /// Ссылка на аватарку
  var photoURL: String?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - name: Имя пользователя
  ///   - uid: Уникальный номер пользователя
  ///   - email: Электронная почта пользователя
  ///   - photoURL: Ссылка на аватарку
  init(name: String?,
       uid: String? = nil,
       email: String? = nil,
       photoURL: String? = nil) {
    self.uid = uid
    self.name = name
    self.email = email
    self.photoURL = photoURL
  }
}
