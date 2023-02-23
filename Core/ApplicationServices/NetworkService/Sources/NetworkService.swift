//
//  NetworkService.swift
//  NetworkService
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface
import RandomNetwork

public final class NetworkService: NetworkServiceProtocol {
  
  // MARK: - Private property
  
  private let networkServiceImpl = NetworkServiceImpl()
  
  // MARK: - Init
  
  public init() {}
  
  // MARK: - Public func
  
  public func performRequestWith(urlString: String,
                                 queryItems: [URLQueryItem],
                                 httpMethod: NetworkMethodProtocol,
                                 headers: [HeadersTypeProtocol],
                                 completion: ((Result<Data?, Error>) -> Void)?) {
    guard let httpMethod = httpMethod as? NetworkMethodImpl,
          let headers = headers as? [HeadersTypeImpl] else {
      return
    }
    
    let httpMethodServic: NetworkMethod
    let headersServic: [HeadersType] = headers.map {
      switch $0 {
      case .acceptJson:
        return .acceptJson
      case .contentTypeJson:
        return .contentTypeJson
      case let .acceptCustom(value):
        return .acceptCustom(setValue: value)
      case let .contentTypeCustom(value):
        return .contentTypeCustom(setValue: value)
      case let .additionalHeaders(value):
        return .additionalHeaders(setValue: value)
      }
    }
    
    switch httpMethod {
    case .get:
      httpMethodServic = .get
    case let .post(data):
      httpMethodServic = .post(data)
    case let .put(data):
      httpMethodServic = .put(data)
    case let .patch(data):
      httpMethodServic = .patch(data)
    case .delete:
      httpMethodServic = .delete
    case .head:
      httpMethodServic = .head
    case .trace:
      httpMethodServic = .trace
    case .connect:
      httpMethodServic = .connect
    case .options:
      httpMethodServic = .options
    }
    
    networkServiceImpl.performRequestWith(urlString: urlString,
                                          queryItems: queryItems,
                                          httpMethod: httpMethodServic,
                                          headers: headersServic) { result in
      switch result {
      case let .success(data):
        completion?(.success(data))
      case let .failure(error):
        let networkErrorImpl: NetworkErrorImpl
        switch error {
        case .noInternetConnection:
          networkErrorImpl = .noInternetConnection
        case .invalidURLRequest:
          networkErrorImpl = .invalidURLRequest
        case let .unacceptedHTTPStatus(code, localizedDescription):
          networkErrorImpl = .unacceptedHTTPStatus(code: code, localizedDescription: localizedDescription)
        case .unexpectedServerResponse:
          networkErrorImpl = .unexpectedServerResponse
        }
        completion?(.failure(networkErrorImpl))
      }
    }
  }
  
  public func map<ResponseType: Codable>(_ result: Data?,
                                         to _: ResponseType.Type) -> ResponseType? {
    return networkServiceImpl.map(result, to: ResponseType.self)
  }
}
