//
//  CodableResultMapper.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

public struct CodableResultMapper {
    
    func map<ResponseType: Codable>(_ result: NetworkRequestResult) -> RemoteServiceResult<ResponseType> {
        if let error = result.error {
            return .failure(error)
        } else {
            if let data = result.data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(ResponseType.self, from: data)
                    return .success(result)
                } catch {
                    return .failure(error)
                }
            } else {
                return .failure(NetworkError.unexpectedServerResponse)
            }
        }
    }
}

