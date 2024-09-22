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
  ///   - recordTypes: Тип получения данных
  ///   - completion: Замыкание, которое будет вызвано при завершении операции. Возвращает значение типа `T?` или ошибку.
  func getConfigurationValue<T>(
    from keyName: String,
    recordTypes: CloudKitService.RecordTypes,
    completion: @escaping (Result<T?, Error>
    ) -> Void)
}

public final class CloudKitService: ICloudKitService {
  private let timeoutInterval: TimeInterval = 20.0
  
  /// Инициализирует новый экземпляр CloudKitService.
  public init() {}
  
  public func getConfigurationValue<T>(
    from keyName: String,
    recordTypes: CloudKitService.RecordTypes,
    completion: @escaping (Result<T?, Error>) -> Void
  ) {
    let container = CKContainer(identifier: "iCloud.com.sosinvitalii.Random")
    let publicDatabase = container.publicCloudDatabase
    let predicate = NSPredicate(value: true)
    let query = CKQuery(recordType: recordTypes.rawValue, predicate: predicate)
    
    let timeoutWorkItem = DispatchWorkItem {
      completion(
        .failure(
          NSError(
            domain: "CloudKitService",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Request timed out"]
          )
        )
      )
    }
    
    DispatchQueue.global().asyncAfter(deadline: .now() + timeoutInterval, execute: timeoutWorkItem)
    
    publicDatabase.perform(query, inZoneWith: nil) { records, error in
      timeoutWorkItem.cancel()  // Отменяем тайм-аут, если запрос завершился до истечения времени
      
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard let record = records?.first else {
        completion(.success(nil))
        return
      }
      
      // Проверяем, является ли значение CKAsset
      if let asset = record[keyName] as? CKAsset,
         T.self == Data.self,
         let fileURL = asset.fileURL {
        let data = try? Data(contentsOf: fileURL) as? T
        completion(.success(data))
      } else {
        let value = record[keyName] as? T
        completion(.success(value))
      }
    }
  }
}

// MARK: - RecordTypes

extension CloudKitService {
  public enum RecordTypes: String, Codable {
    case config = "Config"
    
    case congratulationsAnniversaries
    case congratulationsBirthday
    case congratulationsNewYear
    case congratulationsWedding
    
    case namesFemale
    case namesMale
    
    case giftIdeas
    case goodDeeds
    case jokes
    case memes
    case nicknames
    case quotes
    case riddles
    case slogans
    case truthOrDare
  }
}
