//
//  PurchasesCardsCellModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import RandomUIKit

struct PurchasesCardsCellModel: PurchasesCardsCellModelProtocol {
  var header: String?
  
  var title: String?
  
  var description: String?
  
  var amount: String?
  
  var action: (() -> Void)?
  
}
