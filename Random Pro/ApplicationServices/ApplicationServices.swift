//
//  ApplicationServices.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 03.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation
import RandomNetwork

/// Протокол, описывающий все зависимости системы.
/// Создан для отказа от DI framework в пользу концепции Composition Root.
///
/// Причины отказа от DI:
/// 1. Использовать меньше сторонних зависимостей
/// 2. Уменьшение количества ошибок/крашей приложения, т.к. используется строгая типизация для каждой зависимости
///
/// Прочитать про концепцию можно в [статье](https://blog.ploeh.dk/2011/07/28/CompositionRoot/)
protocol ApplicationServices {
  
  /// Сервис клавиатуры
  var keyboardService: KeyboardService { get }
  
  /// Сервис по работе с сетью
  var network: NetworkRequestPerformer { get }
  
  /// Сервис по работе с метриками
  var metricsService: MetricsService { get }
  
  /// Сервис по работе с уведомлениями
  var notificationService: NotificationService { get }
  
  /// Сервис по работе с разрешениями
  var permissionService: PermissionService { get }
  
  /// Сервис по работе с локальным хранилищем
  var fileManagerService: FileManagerService { get }
  
  /// Сервис по работе с глубокими и универсальными ссылками
  var deepLinkService: DeepLinkService { get }
}

// MARK: - Реализация ApplicationServices

final class ApplicationServicesImpl: ApplicationServices {
  var deepLinkService: DeepLinkService {
    DeepLinkServiceImpl()
  }
  
  var fileManagerService: FileManagerService {
    FileManagerImpl()
  }
  
  var permissionService: PermissionService {
    PermissionServiceImpl()
  }
  
  var notificationService: NotificationService {
    NotificationServiceImpl()
  }
  
  var metricsService: MetricsService {
    MetricsServiceImpl()
  }
  
  var keyboardService: KeyboardService {
    KeyboardServiceImpl()
  }
  
  var network: NetworkRequestPerformer {
    let network: NetworkRequestPerformer = URLSessionRequestPerformer()
    return network
  }
}
