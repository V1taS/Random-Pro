//
//  URLRequest.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

extension URLRequest {
    init?(baseUrl: String, path: String, params: [String: Any] = [:], method: NetworkRequest, headers: [String: String] = [:]) {
        guard let url = URL(baseUrl: baseUrl, path: path, params: params) else { return nil }
        self.init(url: url)
        httpMethod = method.httpMethod.rawValue
        
        switch method.httpMethod {
        case .post, .put, .head, .patch, .trace, .connect:
            if let jsonBody = try? JSONSerialization.data(withJSONObject: method.queryParameters) {
                httpBody = jsonBody
            }
        default:
            break
        }
        
        headers.forEach {
            setValue($1, forHTTPHeaderField: $0)
        }
    }
}
