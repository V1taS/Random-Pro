//
//  URLSessionRequestPerformer.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import UIKit

public protocol AppNetworkRequestPerformerDelegate: AnyObject {
    func networkRequestPerformer(_ performer: AppNetworkRequestPerformer,
                                 needsTokenUpdateFor request: AppNetworkRequest,
                                 completion: @escaping (NetworkRequestResult) -> Void)
}

public protocol AppNetworkRequestPerformer {
    var delegate: AppNetworkRequestPerformerDelegate? { get set }
    func perform(_ request: AppNetworkRequest, completion: ((NetworkRequestResult) -> Void)?)
}

public protocol AppNetworkRequest {
    var httpMethod: AppNetworkRequestHTTPMethod { get }
    var basePath: String { get }
    var path: String { get }
    var httpHeaders: [String: String] { get }
    var queryParameters: [String: Any] { get }
    var logRequest: Bool { get }
}

public enum AppNetworkRequestHTTPMethod: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}

public struct NetworkRequestResult {
    public let data: Data?
    public let error: Error?
}

final class AppURLSessionRequestPerformer {
    
    weak var delegate: AppNetworkRequestPerformerDelegate?
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        if #available(iOS 11.0, *) {
            config.waitsForConnectivity = true
        }
        config.timeoutIntervalForRequest = 90
        config.timeoutIntervalForResource = 401
        session = URLSession(configuration: config)
    }
}

extension AppURLSessionRequestPerformer: AppNetworkRequestPerformer {

    func perform(_ request: AppNetworkRequest, completion: ((NetworkRequestResult) -> Void)?) {

        guard let urlRequest = URLRequest(baseUrl: request.basePath, path: request.path, params: request.queryParameters, method: request, headers: request.httpHeaders) else {
            completion?(NetworkRequestResult(data: nil, error: NetworkError.invalidURLRequest))
            return
        }
       
        #if DEBUG
        if request.logRequest {
            print("urlRequest: \(String(describing: urlRequest.url)), httpMethod: \(String(describing: urlRequest.httpMethod)), headers: \(String(describing: urlRequest.allHTTPHeaderFields)), body: \(String(describing: try? JSONSerialization.jsonObject(with: urlRequest.httpBody ?? Data(), options: .allowFragments))), bodyJSON: \(String(describing: urlRequest.httpBody?.prettyPrintedJSON))")
        }
        #endif

        let task = session.dataTask(with: urlRequest) {
            let response = (data: $0, response: $1, error: $2)

            #if DEBUG
            if request.logRequest {
                print("Task urlRequest result: \(String(describing: $0?.prettyPrintedJSON))")
            }
            #endif

            if let error = response.2 {
                completion?(NetworkRequestResult(data: response.0, error: error))
            } else {
                if let httpResponse = response.1 as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode {
                    completion?(NetworkRequestResult(data: response.0, error: nil))
                } else {
                    let statusCode = (response.1 as? HTTPURLResponse)?.statusCode ?? 0

                    #if DEBUG
                    print("statusCode: \(statusCode)")
                    #endif

                    completion?(NetworkRequestResult(data: response.0, error: NetworkError.unacceptedHTTPStatusCode))
                }
            }
        }
        task.resume()
    }
}
