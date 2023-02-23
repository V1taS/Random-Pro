//
//  NetworkErrorImpl.swift
//  NetworkService
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

/// Сетевая ошибка
public enum NetworkErrorImpl: NetworkErrorProtocol {
  
  /// Подключение к Интернету отсутствует
  case noInternetConnection
  
  /// Неверный URL-запрос
  case invalidURLRequest
  
  /// Код ошибки HTTPS
  /// - Parameters:
  ///  - code: Код ошибки
  ///  - localizedDescription: Описание ошибки
  case unacceptedHTTPStatus(code: Int, localizedDescription: String?)
  
  /// Непредвиденный ответ сервера
  case unexpectedServerResponse
}
