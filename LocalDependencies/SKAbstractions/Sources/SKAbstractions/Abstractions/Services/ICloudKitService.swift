//
//  ICloudKitService.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

/// Протокол для работы с CloudKit для получения конфигурационных данных.
public protocol ICloudKitService {
  /// Получает значение конфигурации по ключу.
  /// - Parameters:
  ///   - keyName: Имя ключа, по которому нужно получить значение.
  ///   - recordTypes: Тип получения данных
  ///   - completion: Замыкание, которое будет вызвано при завершении операции. Возвращает значение типа `T?` или ошибку.
  func getConfigurationValue<T: Codable>(
    from keyName: String,
    recordTypes: CloudKitRecordTypes,
    completion: @escaping (Result<T?, Error>) -> Void
  )
}
