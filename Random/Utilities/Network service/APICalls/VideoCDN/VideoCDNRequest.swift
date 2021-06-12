//
//  VideoCDNRequest.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

public struct VideoCDNRequest: NetworkRequest {
    public var basePath: String = "https://videocdn.tv"
    public let path: String = "/api/movies"
    public let httpMethod: NetworkRequestHTTPMethod = .get

    public var httpHeaders: [String : String] = [:]
    public var queryParameters: [String : Any] {
        params
    }
    public var logRequest = false
    
    private var params = [String: Any]()
    
    init(year: Int, limit: Int) {
        params["api_token"] = "VGstdXXDwaGDIM4Ec8ofDLcZnAaTsU0X"
        params["year"] = "\(year)"
        params["limit"] = "\(limit)"
    }
}
