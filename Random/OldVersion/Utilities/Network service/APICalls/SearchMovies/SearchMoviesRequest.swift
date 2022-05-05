//
//  SearchMoviesRequest.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

public struct SearchMoviesRequest: AppNetworkRequest {
    public var basePath: String = "https://videocdn.tv"
    public let path: String = "/api/short"
    public let httpMethod: AppNetworkRequestHTTPMethod = .get

    public var httpHeaders: [String : String] = [:]
    public var queryParameters: [String : Any] {
        params
    }
    public var logRequest = false
    
    private var params = [String: Any]()
    
    init(kinopoiskId: String) {
        params["api_token"] = "VGstdXXDwaGDIM4Ec8ofDLcZnAaTsU0X"
        params["kinopoisk_id"] = kinopoiskId
    }
}
