//
//  ApplicationServices.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 03.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation
import FancyNetwork
import SKAbstractions
import SKServices

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
  var networkService: NetworkService { get }
  
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
  
  /// Сервис по работе с тайсером
  var timerService: TimerService { get }
  
  /// Сервис виброоткликов
  var hapticService: HapticService { get }
  
  /// Сервис фичатогглов
  var featureToggleServices: FeatureToggleServices { get }
  
  /// Сервис проверки обновлений приложения
  var updateAppService: UpdateAppService { get }
  
  /// Сервис подписок и покупок премиум версии
  var appPurchasesService: IAppPurchasesService { get }

  /// Сервис хранения данных
  var storageService: StorageService { get }
  
  /// Сервис считает количество нажатий на кнопки
  var buttonCounterService: ButtonCounterService { get }
  
  /// Сервис для работы с CloudKit для получения конфигурационных данных.
  var cloudKitService: ICloudKitService { get }
}

// MARK: - Реализация ApplicationServices

final class ApplicationServicesImpl: ApplicationServices {
  
  // MARK: - Singleton Instance
  
  static let shared = ApplicationServicesImpl()
  
  // MARK: - Private Initializer
  
  private init() {}
  
  // MARK: - Internal property
  
  // MARK: - Internal property
  
  var deepLinkService: DeepLinkService {
    deepLinkServiceImpl
  }
  
  var fileManagerService: FileManagerService {
    fileManagerImpl
  }
  
  var permissionService: PermissionService {
    permissionServiceImpl
  }
  
  var notificationService: NotificationService {
    notificationServiceImpl
  }
  
  var metricsService: MetricsService {
    metricsServiceImpl
  }
  
  var keyboardService: KeyboardService {
    keyboardServiceImpl
  }
  
  var networkService: NetworkService {
    networkServiceImpl
  }
  
  var timerService: TimerService {
    timerServiceImpl
  }
  
  var hapticService: HapticService {
    hapticServiceImpl
  }
  
  var featureToggleServices: FeatureToggleServices {
    featureToggleServicesImpl
  }
  
  var updateAppService: UpdateAppService {
    updateAppServiceImpl
  }
  
  var appPurchasesService: IAppPurchasesService {
    appPurchasesServiceImpl
  }
  
  var storageService: StorageService {
    storageServiceImpl
  }
  
  var buttonCounterService: ButtonCounterService {
    buttonCounterServiceImpl
  }
  
  var cloudKitService: ICloudKitService {
    cloudKitServiceImpl
  }
  
  // MARK: - Private property
  
  let cloudKitServiceImpl = CloudKitService()
  let storageServiceImpl = StorageServiceImpl()
  let deepLinkServiceImpl = DeepLinkServiceImpl()
  let networkServiceImpl = NetworkServiceImpl()
  let buttonCounterServiceImpl = ButtonCounterServiceImpl()
  let hapticServiceImpl = HapticServiceImpl()
  let timerServiceImpl = TimerServiceImpl()
  let appPurchasesServiceImpl = AppPurchasesService.shared
  let updateAppServiceImpl = UpdateAppServiceImpl()
  let featureToggleServicesImpl = FeatureToggleServicesImpl()
  let keyboardServiceImpl = KeyboardServiceImpl()
  let metricsServiceImpl = MetricsServiceImpl.shared
  let notificationServiceImpl = NotificationServiceImpl()
  let permissionServiceImpl = PermissionServiceImpl()
  let fileManagerImpl = FileManagerImpl()
}
