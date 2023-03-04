//
//  ApphudProductModel.swift
//  AppPurchasesService
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import StoreKit

public struct ApphudProductModel: ApphudProductProtocol {
  public var productId: String
  public var name: String?
  public var store: String
  public var skProduct: SKProduct?
  public var paywallIdentifier: String?
  
  public init(productId: String,
              name: String? = nil,
              store: String,
              skProduct: SKProduct?,
              paywallIdentifier: String? = nil) {
    self.productId = productId
    self.name = name
    self.store = store
    self.skProduct = skProduct
    self.paywallIdentifier = paywallIdentifier
  }
}
