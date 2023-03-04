//
//  DateTimeScreenModelProtocol.swift
//  StorageService
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - DateTimeScreenModelProtocol

public protocol DateTimeScreenModelProtocol {
  
  /// Результат генерации
  var result: String { get }
  
  /// Список результатов
  var listResult: [String] { get }
}
