//
//  CoinScreenStorageServiceProtocol.swift.swift
//  CoinScreenModule
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - CoinScreenStorageServiceProtocol

public protocol CoinScreenStorageServiceProtocol {
  
  /// Активирован премиум в приложении
  var isPremium: Bool { get }
  
  /// Сохранить данные
  func saveData<T: Codable>(_ data: T, key: String)
  
  /// Получить данные
  func getDataWith<ResponseType: Codable>(key: String, to _: ResponseType.Type) -> ResponseType?
}
