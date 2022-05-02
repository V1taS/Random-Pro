//
//  NetworkError.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case noInternetConnection
    case invalidURLRequest
    case unacceptedHTTPStatusCode
    case unexpectedServerResponse
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unacceptedHTTPStatusCode:
            return Constant.serverNotResponding
        case .noInternetConnection:
            return Constant.noInternetConnection
        case .unexpectedServerResponse:
            return Constant.unexpectedServerResponse
        case .invalidURLRequest:
            return Constant.invalidURLRequest
        }
    }
}

private enum Constant {
    static var serverNotResponding: String { NSLocalizedString("server_not_responding", comment: "server_not_responding") }
    static var noInternetConnection: String { NSLocalizedString("no_internet_connection", comment: "no_internet_connection") }
    static var unexpectedServerResponse: String { NSLocalizedString("unexpected_response", comment: "unexpected_response") }
    static var invalidURLRequest: String { NSLocalizedString("invalid_url_request", comment: "invalid_url_request") }
}
