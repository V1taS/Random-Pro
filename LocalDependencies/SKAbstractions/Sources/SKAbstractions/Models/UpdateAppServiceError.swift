//
//  UpdateAppServiceError.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public enum UpdateAppServiceError: Error {

  /// Ошибка в получении данных
  case invalidResponse

  /// Ошибка в данных
  case invalidData

  /// Ошибка в Bundle Info
  case invalidBundleInfo

  /// Что-то пошло не так
  case somethingWrongWith(String?)
}
