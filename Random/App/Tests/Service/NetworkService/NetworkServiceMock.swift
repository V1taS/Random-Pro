//
//  NetworkServiceMock.swift
//  RandomTests
//
//  Created by Vitalii Sosin on 27.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyNetwork
import XCTest
@testable import Random

final class NetworkServiceMock: NetworkService {
  
  // Spy variables
  var performRequestWithCalled = false
  var mapCalled = false
  
  // Stub variables
  var requestResult: Result<Data?, FancyNetwork.NetworkError>?
  var mappedData: Codable?
  
  func performRequestWith(
    urlString: String,
    queryItems: [URLQueryItem],
    httpMethod: FancyNetwork.NetworkMethod,
    headers: [FancyNetwork.HeadersType],
    completion: ((Result<Data?, FancyNetwork.NetworkError>) -> Void)?) {
      performRequestWithCalled = true
      completion?(requestResult ?? .failure(.invalidURLRequest))
    }
  
  func map<ResponseType: Codable>(_ result: Data?,
                                  to _: ResponseType.Type) -> ResponseType? {
    mapCalled = true
    return mappedData as? ResponseType
  }
}
