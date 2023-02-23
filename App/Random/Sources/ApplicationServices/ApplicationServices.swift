//
//  ApplicationServices.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 03.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface
import AuthenticationService
import DeepLinkService
import FileManagerService
import PermissionService
import NotificationService
import MetricsService
import KeyboardService
import NetworkService
import TimerService
import HapticService
import FeatureToggleServices
import UpdateAppService
import AppPurchasesService
import StorageService

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
  var keyboardService: KeyboardServiceProtocol { get }
  
  /// Сервис по работе с сетью
  var networkService: NetworkServiceProtocol { get }
  
  /// Сервис по работе с метриками
  var metricsService: MetricsServiceProtocol { get }
  
  /// Сервис по работе с уведомлениями
  var notificationService: NotificationServiceProtocol { get }
  
  /// Сервис по работе с разрешениями
  var permissionService: PermissionServiceProtocol { get }
  
  /// Сервис по работе с локальным хранилищем
  var fileManagerService: FileManagerServiceProtocol { get }
  
  /// Сервис по работе с глубокими и универсальными ссылками
  var deepLinkService: DeepLinkServiceProtocol { get }
  
  /// Сервис по работе с тайсером
  var timerService: TimerServiceProtocol { get }
  
  /// Сервис виброоткликов
  var hapticService: HapticServiceProtocol { get }
  
  /// Сервис фичатогглов
  var featureToggleServices: FeatureToggleServicesProtocol { get }
  
  /// Сервис проверки обновлений приложения
  var updateAppService: UpdateAppServiceProtocol { get }
  
  /// Сервис авторизации пользователей
  var authenticationService: AuthenticationService { get }
  
  /// Сервис подписок и покупок премиум версии
  var appPurchasesService: AppPurchasesServiceProtocol { get }
  
  /// Сервис Хранения данных
  var storageService: StorageServiceProtocol { get }
}

// MARK: - Реализация ApplicationServices

final class ApplicationServicesImpl: ApplicationServices {
  
  // MARK: - Internal property
  
  var deepLinkService: DeepLinkServiceProtocol {
    DeepLinkServiceImpl()
  }
  
  var fileManagerService: FileManagerServiceProtocol {
    FileManagerImpl()
  }
  
  var permissionService: PermissionServiceProtocol {
    PermissionServiceImpl()
  }
  
  var notificationService: NotificationServiceProtocol {
    NotificationServiceImpl()
  }
  
  var metricsService: MetricsServiceProtocol {
    MetricsServiceImpl()
  }
  
  var keyboardService: KeyboardServiceProtocol {
    KeyboardServiceImpl()
  }
  
  var networkService: NetworkServiceProtocol {
    NetworkService()
  }
  
  var timerService: TimerServiceProtocol {
    TimerServiceImpl()
  }
  
  var hapticService: HapticServiceProtocol {
    HapticServiceImpl()
  }
  
  var featureToggleServices: FeatureToggleServicesProtocol {
    FeatureToggleServicesImpl()
  }
  
  var updateAppService: UpdateAppServiceProtocol {
    UpdateAppServiceImpl()
  }
  
  var authenticationService: AuthenticationService {
    AuthenticationServiceImpl()
  }

  var appPurchasesService: AppPurchasesServiceProtocol {
    AppPurchasesServiceImpl()
  }
  
  var storageService: StorageServiceProtocol {
    return storageServiceImpl
  }
  
  // MARK: - Private property
  
  let storageServiceImpl = StorageServiceImpl()
}
