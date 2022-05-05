//
//  KinopoiskPopularFilmsRequest.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

public struct KinopoiskPopularFilmsRequest: AppNetworkRequest {
    
    public var basePath: String = "https://kinopoiskapiunofficial.tech/"
    public let httpMethod: AppNetworkRequestHTTPMethod = .get
    public var httpHeaders: [String : String] {
        ["X-API-KEY": "f835989c-b489-4624-9209-6d93bfead535"]
    }
    public var queryParameters: [String : Any] {
        params
    }
    public var logRequest = false
    public var path: String {
        "api/v2.2/films/top"
    }
    
    private var params = [String: Any]()
    
    init(page: Int) {
        params["type"] = "TOP_100_POPULAR_FILMS"
        params["page"] = page
    }
}
