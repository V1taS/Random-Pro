//
//  FeatureToggleServicesProtocol.swift
//  FeatureToggleServices
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

// MARK: - FeatureToggleServicesProtocol

public protocol FeatureToggleServicesProtocol {
  
  /// Получить секции, которые надо скрыть из приложения
  func getSectionsIsHiddenFT(completion: @escaping (SectionsIsHiddenFTModel?) -> Void)
  
  /// Получить лайблы для ячеек на главном экране
  func getLabelsFeatureToggle(completion: @escaping (LabelsFeatureToggleModel?) -> Void)
  
  /// Получить премиум
  func getPremiumFeatureToggle(completion: @escaping (Bool?) -> Void)
  
  /// Получить возможность показывать баннер обнови приложение
  func getUpdateAppFeatureToggle(completion: @escaping (_ isUpdateAvailable: Bool) -> Void)
}

// MARK: - UpdateAppFeatureToggleModelProtocol

public protocol UpdateAppFeatureToggleModelProtocol {
  
  /// Доступность баннера обновить приложение
  var isUpdateAvailable: Bool { get }
}

// MARK: - PremiumFeatureToggleModelProtocol

public protocol PremiumFeatureToggleModelProtocol {
  
  /// Уникальное ID устройства
  var id: String? { get }
  
  /// премиум включен
  var isPremium: Bool? { get }
}
