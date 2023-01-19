//
//  PremiumScreenSectionType.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

enum PremiumScreenSectionType {
  
  case onboardingPage(_ model: PremiumScreenOnboardingViewModel)
  
  case purchasesCards(_ models: [PurchasesCardsCellModel])
  
  case padding(_ value: CGFloat)
  
  case divider
}
