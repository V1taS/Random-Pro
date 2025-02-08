//
//  FeatureToggleServices.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public protocol FeatureToggleServices {

  /// Проверить тоггл для определенного функционала
  func isToggleFor(feature: FeatureToggleType) -> Bool

  /// Получить секции, которые надо скрыть из приложения
  func isHiddenToggleFor(section: MainScreenModel.SectionType) -> Bool

  /// Получить лайблы для ячеек на главном экране
  func getLabelsFor(section: MainScreenModel.SectionType) -> String

  /// Получить премиум
  func getPremiumFeatureToggle(models: [PremiumFeatureToggleModel], completion: @escaping (Bool?) -> Void)
}
