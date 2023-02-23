//
//  NetworkServiceProtocol.swift
//  ApplicationServices
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - NetworkServiceProtocol

/// Сервис по работе с сетью
public protocol NetworkServiceProtocol {
  
  /// Сделать запрос в сеть
  ///  - Parameters:
  ///   - urlString: Адрес запроса
  ///   - queryItems: Query параметры
  ///   - httpMethod: Метод запроса
  ///   - headers: Хедеры
  ///   - Reuterns: Результат выполнения
  func performRequestWith(urlString: String,
                          queryItems: [URLQueryItem],
                          httpMethod: NetworkMethodProtocol,
                          headers: [HeadersTypeProtocol],
                          completion: ((Result<Data?, Error>) -> Void)?)
  
  /// Делает маппинг из `JSON` в структуру данных типа `Generic`
  /// - parameters:
  ///  - result: модель данных с сервера
  ///  - to: В какой тип данных маппим
  /// - returns: Результат маппинга в структуру `Generic`
  func map<ResponseType: Codable>(_ result: Data?,
                                  to _: ResponseType.Type) -> ResponseType?
}

// MARK: - NetworkMethodProtocol

/// HTTP-метод сетевого запроса
public protocol NetworkMethodProtocol {
  
  /// Тип сетевого запроса
  var rawValue: String { get }
  
  /// Получить данные
  static var get: Self { get }
  
  /// Отправить данные
  static func post(_ data: Data?) -> Self
  
  /// Обновить данные. Перезаписывает данные (даже если файл не изменился)
  static func put(_ data: Data?) -> Self
  
  /// Метод запроса HTTP PATCH частично изменяет ресурс. Такой же как и метод `PUT`,
  /// только `PATCH` не перезапишет данные если они не изменились, а `PUT` перезапишет
  static func patch(_ data: Data?) -> Self
  
  /// Удалить данные
  static var delete: Self { get }
  
  /// HTTP-метод `HEAD` запрашивает заголовки `httpHeaders`.
  static var head: Self { get }
  
  /// HTTP Метод TRACE выполняет проверку обратной связи по пути к целевому ресурсу `code 200`
  static var trace: Self { get }
  
  /// Метод HTTP CONNECTзапускает двустороннюю связь с запрошенным ресурсом.
  static var connect: Self { get }
  
  /// Запрос `OPTIONS` вернет список доступных методов `GET, Post ...`
  static var options: Self { get }
}

// MARK: - HeadersTypeProtocol

/// Тип хедера
public protocol HeadersTypeProtocol {
  
  /// Хедоры
  var headers: [String: String] { get }
  
  /// Accept `JSON`
  static var acceptJson: Self { get }
  
  /// Content-Type `JSON`
  static var contentTypeJson: Self { get }
  
  /// Accept `Custom`
  static func acceptCustom(setValue: String) -> Self
  
  /// Content-Type `Custom`
  static func contentTypeCustom(setValue: String) -> Self
  
  /// Дополнительные заголовки
  static func additionalHeaders(setValue: [String: String]) -> Self
}

// MARK: - NetworkErrorProtocol

/// Сетевая ошибка
public protocol NetworkErrorProtocol: Error {
  
  /// Подключение к Интернету отсутствует
  static var noInternetConnection: Self { get }
  
  /// Неверный URL-запрос
  static var invalidURLRequest: Self { get }
  
  /// Код ошибки HTTPS
  /// - Parameters:
  ///  - code: Код ошибки
  ///  - localizedDescription: Описание ошибки
  static func unacceptedHTTPStatus(code: Int,
                                   localizedDescription: String?) -> Self
  
  /// Непредвиденный ответ сервера
  static var unexpectedServerResponse: Self { get }
}
