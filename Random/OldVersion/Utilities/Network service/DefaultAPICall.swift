//
//  DefaultAPICall.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

public struct DefaultAPICall {
    
    private let requestPerformer: AppNetworkRequestPerformer
    
    public init(_ requestPerformer: AppNetworkRequestPerformer) {
        self.requestPerformer = requestPerformer
    }
    
    public func perform(_ request: AppNetworkRequest, _ completion: ((NetworkRequestResult) -> Void)?) {
        requestPerformer.perform(request, completion: completion)
    }
}
