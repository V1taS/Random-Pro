//
//  HeadersTypeImpl.swift
//  NetworkService
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

/// Тип хедера
public enum HeadersTypeImpl: HeadersTypeProtocol {
  
  /// Хедоры
  public var headers: [String: String] {
    let appearance = Appearance()
    switch self {
    case .acceptJson:
      return [appearance.headerFieldValue: appearance.headerFieldAccept]
    case .contentTypeJson:
      return [appearance.headerFieldValue: appearance.headerFieldContentType]
    case .acceptCustom(let value):
      return [value: appearance.headerFieldAccept]
    case .contentTypeCustom(let value):
      return [value: appearance.headerFieldContentType]
    case .additionalHeaders(let value):
      return value
    }
  }
  
  /// Accept `JSON`
  case acceptJson
  
  /// Content-Type `JSON`
  case contentTypeJson
  
  /// Accept `Custom`
  case acceptCustom(setValue: String)
  
  /// Content-Type `Custom`
  case contentTypeCustom(setValue: String)
  
  /// Дополнительные заголовки
  case additionalHeaders(setValue: [String: String])
}

// MARK: - Appearance

private extension HeadersTypeImpl {
  struct Appearance {
    let headerFieldAccept = "Accept"
    let headerFieldContentType = "Content-Type"
    let headerFieldValue = "application/json"
  }
}
