//
//  KinopoiskInfoRequest.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

public struct KinopoiskInfoRequest: AppNetworkRequest {
    
    public var basePath: String = "https://kinopoiskapiunofficial.tech/"
    public let httpMethod: AppNetworkRequestHTTPMethod = .get
    public var httpHeaders: [String : String] {
        ["X-API-KEY": "f835989c-b489-4624-9209-6d93bfead535"]
    }
    public var queryParameters: [String : Any] = [:]
    public var logRequest = false
    public var path: String {
        "api/v2.1/films/" + kinopoiskID
    }
    
    private var kinopoiskID: String
    
    init(kinopoiskID: String) {
        self.kinopoiskID = kinopoiskID
    }
}
