//
//  HotTravelRequest.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

public struct HotTravelRequest: NetworkRequest {
    
    public var basePath: String = "https://api.level.travel/"
    public let httpMethod: NetworkRequestHTTPMethod = .get
    public var httpHeaders: [String : String] {
        ["Accept": "application/vnd.leveltravel.v3",
         "Authorization": "Token token=\"f7ca9ff62cac7ebe403b35b9e4065be4\""]
    }
    public var queryParameters: [String : Any] {
        params
    }
    public var logRequest = false
    public var path: String {
        "hot/tours"
    }
    
    private var params = [String: Any]()
    
    init(startDate: String, endDate: String) {
        params["start_date"] = startDate
        params["end_date"] = endDate
        params["per_page"] = 100
        params["sort_by"] = "prices"
    }
}
