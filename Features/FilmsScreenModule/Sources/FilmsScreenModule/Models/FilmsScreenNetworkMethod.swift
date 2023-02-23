//
//  FilmsScreenNetworkMethod.swift
//  FilmsScreenModule
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

/// HTTP-метод сетевого запроса
public enum FilmsScreenNetworkMethod: NetworkMethodProtocol {

  /// Тип сетевого запроса
  public var rawValue: String {
    switch self {
    case .get:
      return "GET"
    case .post:
      return "POST"
    case .put:
      return "PUT"
    case .patch:
      return "PATCH"
    case .delete:
      return "DELETE"
    case .head:
      return "HEAD"
    case .trace:
      return "TRACE"
    case .connect:
      return "CONNECT"
    case .options:
      return "OPTIONS"
    }
  }
  
  /// Получить данные
  case get
  
  /// Отправить данные
  case post(_ data: Data?)
  
  /// Обновить данные. Перезаписывает данные (даже если файл не изменился)
  case put(_ data: Data?)
  
  /// Метод запроса HTTP PATCH частично изменяет ресурс. Такой же как и метод `PUT`,
  /// только `PATCH` не перезапишет данные если они не изменились, а `PUT` перезапишет
  case patch(_ data: Data?)
  
  /// Удалить данные
  case delete
  
  /// HTTP-метод `HEAD` запрашивает заголовки `httpHeaders`.
  case head
  
  /// HTTP Метод TRACE выполняет проверку обратной связи по пути к целевому ресурсу `code 200`
  case trace
  
  /// Метод HTTP CONNECTзапускает двустороннюю связь с запрошенным ресурсом.
  case connect
  
  /// Запрос `OPTIONS` вернет список доступных методов `GET, Post ...`
  case options
}
