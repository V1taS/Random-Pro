//
//  MetricsService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 05.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation
import YandexMobileMetrica
import Firebase
import RandomNetwork

protocol MetricsService {
  
  /// Отправляем стандартную метрику
  ///  - Parameter event: Выбираем метрику
  func track(event: MetricsSections)
  
  /// Отправляем метрику и дополнительную информацию в словаре `[String : String]`
  /// - Parameters:
  ///  - event: Выбираем метрику
  ///  - properties: Словарик с дополнительной информацией `[String : String]`
  func track(event: MetricsSections, properties: [String: String])
  
  /// Получаем модельки всех событий с количеством нажатий
  func getAllEvents() -> [MetricsServiceModel]?
  
  /// Получаем количество нажатий на конкретное событие
  ///  - Parameter type: Тип события
  func getCountTappedOn(_ type: MetricsSections) -> Int?
  
  /// Получаем общее количество нажатий на все события
  func getAllCountTapped() -> Int?
}

final class MetricsServiceImpl: MetricsService {
  
  // MARK: - Private property
  
  private var dictionaryCountTapped: [MetricsSections.RawValue: Int]? {
    get {
      StorageServiceImpl().dictionaryCountTappedModel
    } set {
      StorageServiceImpl().dictionaryCountTappedModel = newValue
    }
  }
  
  // MARK: - Internal func
  
  func track(event: MetricsSections) {
    Analytics.logEvent(event.rawValue, parameters: nil)
    
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: nil) { error in
      // swiftlint:disable:next no_print
      print("REPORT ERROR: %@", error.localizedDescription)
    }
    increaseCountTapped(event: event)
  }
  
  func track(event: MetricsSections, properties: [String: String]) {
    Analytics.logEvent(event.rawValue, parameters: properties)
    
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: properties) { error in
      // swiftlint:disable:next no_print
      print("REPORT ERROR: %@", error.localizedDescription)
    }
    increaseCountTapped(event: event)
  }
  
  func getAllEvents() -> [MetricsServiceModel]? {
    guard let dictionaryCountTapped = dictionaryCountTapped else {
      return nil
    }
    
    var countTappedModels: [MetricsServiceModel] = []
    
    for (key, value) in dictionaryCountTapped {
      if let type = MetricsSections(rawValue: key) {
        countTappedModels.append(MetricsServiceModel(type: type,
                                                     countTapped: value))
      }
    }
    return countTappedModels
  }
  
  func getCountTappedOn(_ type: MetricsSections) -> Int? {
    guard
      let dictionaryCountTapped = dictionaryCountTapped,
      let countTapped = dictionaryCountTapped[type.rawValue]
    else {
      return nil
    }
    return countTapped
  }
  
  func getAllCountTapped() -> Int? {
    guard let dictionaryCountTapped = dictionaryCountTapped else {
      return nil
    }
    
    var allCount = 0
    for (_, value) in dictionaryCountTapped {
      allCount += value
    }
    return allCount
  }
}

// MARK: - Private

private extension MetricsServiceImpl {
  func increaseCountTapped(event: MetricsSections) {
    if var dictionaryCountTapped = dictionaryCountTapped {
      if let count = dictionaryCountTapped[event.rawValue] {
        dictionaryCountTapped[event.rawValue] = count + 1
      } else {
        dictionaryCountTapped[event.rawValue] = 1
      }
      self.dictionaryCountTapped = dictionaryCountTapped
    } else {
      dictionaryCountTapped = [event.rawValue: 1]
    }
  }
}

// MARK: - Appearance

private extension MetricsServiceImpl {
  struct Appearance {}
}
