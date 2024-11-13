//
//  ADVManager.swift
//  Random
//
//  Created by Vitalii Sosin on 13.11.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import Foundation

// Менеджер для управления рекламными моделями
final class ADVManager {
  // Словарь массивов моделей по категориям
  private var categoryModels: [String: [ADVFeatureToggleModel]] = [:]
  
  // Инициализация менеджера с массивом моделей
  init() {
    // Инициализируем категории
    for category in ["1", "2", "3", "4"] {
      categoryModels[category] = []
    }
    
    // Заполняем массивы моделей по категориям
    for model in SecretsAPI.advFeatureToggleModels {
      if let category = model.category, categoryModels.keys.contains(category) {
        categoryModels[category]?.append(model)
      }
    }
  }
  
  // Функция получения моделей по категориям
  func getModels() -> (
    category1: ADVFeatureToggleModel?,
    category2: ADVFeatureToggleModel?,
    category3: ADVFeatureToggleModel?,
    category4: ADVFeatureToggleModel?
  ) {
    let category1Model = getFirstModel(for: "1")
    let category2Model = getFirstModel(for: "2")
    let category3Model = getFirstModel(for: "3")
    let category4Model = getFirstModel(for: "4")
    
    return (category1: category1Model, category2: category2Model, category3: category3Model, category4: category4Model)
  }
  
  // Функция получения первой модели для конкретной категории
  private func getFirstModel(for category: String) -> ADVFeatureToggleModel? {
    return categoryModels[category]?.first
  }
}
