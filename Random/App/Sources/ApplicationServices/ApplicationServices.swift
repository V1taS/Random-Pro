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
  
  /// Сервис авторизации пользователей
  var authenticationService: AuthenticationService { get }
  
  /// Сервис облачной базы данных
  var cloudDatabaseService: CloudDatabaseService { get }
  
  /// Сервис подписок и покупок премиум версии
  var appPurchasesService: AppPurchasesService { get }
  
  /// Сервис хранения данных
  var storageService: StorageService { get }
  
  /// Сервис считает количество нажатий на кнопки
  var buttonCounterService: ButtonCounterService { get }

  /// Сервис онбоардинг экрана
  var onboardingService: OnboardingService { get }
}

// MARK: - Реализация ApplicationServices

final class ApplicationServicesImpl: ApplicationServices {
  
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
  
  var authenticationService: AuthenticationService {
    authenticationServiceImpl
  }
  
  var cloudDatabaseService: CloudDatabaseService {
    cloudDatabaseServiceImpl
  }
  
  var appPurchasesService: AppPurchasesService {
    appPurchasesServiceImpl
  }
  
  var storageService: StorageService {
    storageServiceImpl
  }
  
  var buttonCounterService: ButtonCounterService {
    buttonCounterServiceImpl
  }

  var onboardingService: OnboardingService {
    onboardingServiceImpl
  }
  
  // MARK: - Private property
  
  let storageServiceImpl = StorageServiceImpl()
  let deepLinkServiceImpl = DeepLinkServiceImpl()
  let networkServiceImpl = NetworkServiceImpl()
  let buttonCounterServiceImpl = ButtonCounterServiceImpl()
  let hapticServiceImpl = HapticServiceImpl()
  let timerServiceImpl = TimerServiceImpl()
  let appPurchasesServiceImpl = AppPurchasesServiceImpl()
  let cloudDatabaseServiceImpl = CloudDatabaseServiceImpl()
  let authenticationServiceImpl = AuthenticationServiceImpl()
  let updateAppServiceImpl = UpdateAppServiceImpl()
  let featureToggleServicesImpl = FeatureToggleServicesImpl()
  let keyboardServiceImpl = KeyboardServiceImpl()
  let metricsServiceImpl = MetricsServiceImpl()
  let notificationServiceImpl = NotificationServiceImpl()
  let permissionServiceImpl = PermissionServiceImpl()
  let fileManagerImpl = FileManagerImpl()
  let onboardingServiceImpl = OnboardingServiceImpl()
}
