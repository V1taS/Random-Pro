//
//  CloudKitService.swift
//  Random
//
//  Created by Vitalii Sosin on 19.08.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import Foundation
import CloudKit

// MARK: - CloudKitService

/// Протокол для работы с CloudKit для получения конфигурационных данных.
public protocol ICloudKitService {
  /// Получает значение конфигурации по ключу.
  /// - Parameters:
  ///   - keyName: Имя ключа, по которому нужно получить значение.
  ///   - completion: Замыкание, которое будет вызвано при завершении операции. Возвращает значение типа `T?` или ошибку.
  func getConfigurationValue<T>(from keyName: String, completion: @escaping (Result<T?, Error>) -> Void)
}

public final class CloudKitService: ICloudKitService {
  /// Инициализирует новый экземпляр CloudKitService.
  public init() {}
  
  public func getConfigurationValue<T>(from keyName: String, completion: @escaping (Result<T?, Error>) -> Void) {
    let container = CKContainer(identifier: "iCloud.com.sosinvitalii.Random")
    let publicDatabase = container.publicCloudDatabase
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: "Config", predicate: predicate)
    
    publicDatabase.perform(query, inZoneWith: nil) { records, error in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard let record = records?.first,
            let value = record[keyName] as? T else {
        completion(.success(nil))
        return
      }
      
      completion(.success(value))
    }
  }
}
