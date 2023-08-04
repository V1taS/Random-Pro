//
//  ReferalModel.swift
//  Random
//
//  Created by Vitalii Sosin on 01.08.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct ReferalModel {
  
  /// Уникальное ID устройства
  let id: String?
  
  /// Список кто зарегистрировался по ссылке
  let referals: [String]?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - dictionary: Словарь с фича тогглами
  init(dictionary: [String: Any]) {
    id = dictionary["id"] as? String
    referals = dictionary["referals"] as? [String]
  }
}
