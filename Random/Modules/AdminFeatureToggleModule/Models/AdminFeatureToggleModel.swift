//
//  AdminFeatureToggleModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.07.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

/// Модель
struct AdminFeatureToggleModel {
  
  /// Название раздела
  let sectionName: String
  
  /// Список лайблов
  let advLabels: [MainScreenCellModel.MainScreenCell.ADVLabel]
  
  /// Текущий лайбл
  let currentIndexADVLabels: Int
  
  /// Включен раздел
  let isFeatureToggle: Bool
}
