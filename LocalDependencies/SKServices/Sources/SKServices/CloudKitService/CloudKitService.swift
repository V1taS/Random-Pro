//
//  CloudKitService.swift
//  Random
//
//  Created by Vitalii Sosin on 19.08.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import Foundation
import CloudKit
import SKAbstractions

// MARK: - CloudKitService

public final class CloudKitService: ICloudKitService {
  private let timeoutInterval: TimeInterval = 60.0
  private let cacheDuration: TimeInterval = 30 * 24 * 60 * 60 // 1 месяц в секундах
  private let userDefaults = UserDefaults.standard
  
  /// Инициализирует новый экземпляр CloudKitService.
  public init() {}
  
  public func getConfigurationValue<T: Codable>(
    from keyName: String,
    recordTypes: CloudKitRecordTypes,
    completion: @escaping (Result<T?, Error>) -> Void
  ) {
    // Если тип записи не config, пытаемся получить данные из кеша
    if recordTypes != .config {
      if let cachedResult: CachedValue<T> = getCachedValue(for: recordTypes, key: keyName) {
        completion(.success(cachedResult.data))
        return
      }
    }
    
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
    
    publicDatabase.perform(query, inZoneWith: nil) { [weak self] records, error in
      timeoutWorkItem.cancel()  // Отменяем тайм-аут, если запрос завершился до истечения времени
      
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard let record = records?.first else {
        completion(.success(nil))
        return
      }
      
      var fetchedValue: T?
      
      // Проверяем, является ли значение CKAsset
      if let asset = record[keyName] as? CKAsset,
         T.self == Data.self,
         let fileURL = asset.fileURL {
        fetchedValue = try? Data(contentsOf: fileURL) as? T
      } else {
        fetchedValue = record[keyName] as? T
      }
      
      // Если тип записи не config и значение успешно получено, сохраняем в кеш
      if recordTypes != .config, let valueToCache = fetchedValue {
        self?.cacheValue(valueToCache, for: recordTypes, key: keyName)
      }
      
      completion(.success(fetchedValue))
    }
  }
  
  // MARK: - Caching Methods
  
  /// Кеширует значение в UserDefaults с текущей датой.
  private func cacheValue<T: Codable>(_ value: T, for recordType: CloudKitRecordTypes, key: String) {
    guard let encodedValue = encodeToData(value) else { return }
    let cachedValue = CachedValue(data: encodedValue, timestamp: Date())
    if let encodedCachedValue = encodeToData(cachedValue) {
      userDefaults.set(encodedCachedValue, forKey: cacheKey(recordType: recordType, key: key))
    }
  }
  
  /// Получает кешированное значение, если оно существует и не истекло.
  private func getCachedValue<T: Codable>(for recordType: CloudKitRecordTypes, key: String) -> CachedValue<T>? {
    guard let cachedData = userDefaults.data(forKey: cacheKey(recordType: recordType, key: key)),
          let cachedValue: CachedValue<Data> = decodeFromData(cachedData),
          Date().timeIntervalSince(cachedValue.timestamp) < cacheDuration else {
      return nil
    }
    
    if let decodedValue: T = decodeFromData(cachedValue.data) {
      return CachedValue(data: decodedValue, timestamp: cachedValue.timestamp)
    }
    
    return nil
  }
  
  /// Генерирует уникальный ключ для кеша на основе типа записи и ключа.
  private func cacheKey(recordType: CloudKitRecordTypes, key: String) -> String {
    return "\(recordType.rawValue)_\(key)"
  }
  
  /// Кодирует значение в Data с использованием JSONEncoder.
  private func encodeToData<T: Encodable>(_ value: T) -> Data? {
    let encoder = JSONEncoder()
    return try? encoder.encode(value)
  }
  
  /// Декодирует значение из Data с использованием JSONDecoder.
  private func decodeFromData<T: Decodable>(_ data: Data) -> T? {
    let decoder = JSONDecoder()
    return try? decoder.decode(T.self, from: data)
  }
}

// MARK: - CachedValue

/// Структура для хранения закешированного значения с временной меткой.
private struct CachedValue<T: Codable>: Codable {
  let data: T
  let timestamp: Date
}
