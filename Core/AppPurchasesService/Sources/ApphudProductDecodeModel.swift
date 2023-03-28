//
//  ApphudProductDecodeModel.swift
//  AppPurchasesService
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

public struct ApphudProductDecodeModel: Codable {
  public var productId: String
  public var name: String?
  public var store: String
  public var id: String?
  
  public init(productId: String,
              store: String,
              name: String? = nil,
              id: String? = nil) {
    self.productId = productId
    self.store = store
    self.name = name
    self.id = id
  }
  
  private enum CodingKeys: String, CodingKey {
    case id
    case name
    case store
    case productId = "product_id"
  }
}
