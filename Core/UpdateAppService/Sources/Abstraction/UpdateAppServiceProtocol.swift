//
//  UpdateAppServiceProtocol.swift
//  UpdateAppService
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - UpdateAppServiceProtocol

public protocol UpdateAppServiceProtocol {
  
  /// Проверить доступность нового обновления для приложения
  func checkIsUpdateAvailable(completion: @escaping (Result<UpdateAppServiceModelProtocol, Error>) -> Void)
}

// MARK: - UpdateAppServiceErrorProtocol

public protocol UpdateAppServiceErrorProtocol: Error {
  
  /// Ошибка в получении данных
  static var invalidResponse: Self { get }
  
  /// Ошибка в данных
  static var invalidData: Self { get }
  
  /// Ошибка в Bundle Info
  static var invalidBundleInfo: Self { get }
  
  /// Что-то пошло не так
  static func somethingWrongWith(_ error: String?) -> Self
}

// MARK: - UpdateAppServiceModelProtocol

public protocol UpdateAppServiceModelProtocol {
  
  /// Доступность нового обновления в  App Store
  var isUpdateAvailable: Bool { get }
  
  /// Новая версия приложения в App Store
  var appStoreVersion: String { get }
  
  /// Текущая версия на устройстве
  var currentDeviceVersion: String { get }
}

