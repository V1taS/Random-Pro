//
//  ApphudProductModel.swift
//  AppPurchasesService
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import StoreKit

public struct ApphudProductModel {
  public var productId: String
  public var name: String?
  public var store: String
  public var skProduct: SKProduct?
  public var paywallIdentifier: String?
  
  public init(productId: String,
              store: String,
              skProduct: SKProduct?,
              name: String? = nil,
              paywallIdentifier: String? = nil) {
    self.productId = productId
    self.store = store
    self.skProduct = skProduct
    self.name = name
    self.paywallIdentifier = paywallIdentifier
  }
}
