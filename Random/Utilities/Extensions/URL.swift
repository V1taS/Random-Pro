//
//  URL.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

extension URL {
    init?(baseUrl: String, path: String, params: [String: Any]? = nil) {
        var components = URLComponents(string: baseUrl)
        components?.path += path
        
        if let params = params {
            components?.queryItems = params.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        }
        
        guard let url = components?.url else { return nil }
        self = url
    }
}
