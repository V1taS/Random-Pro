//
//  ADVFeatureToggleModel.swift
//  Random
//
//  Created by Vitalii Sosin on 13.11.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import Foundation

struct ADVFeatureToggleModel: UserDefaultsCodable {
  
  /// Категория рекламы
  let category: String?
  
  /// Текст рекламы на русском языке
  let textADVRus: String?
  
  /// Текст рекламы на английском языке
  let textADVEng: String?
  
  /// URL-адрес для перехода по рекламе
  let urlString: String?
}
