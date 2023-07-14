//
//  ApplicationServicesMock.swift
//  Random
//
//  Created by Vitalii Sosin on 27.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomNetwork
import XCTest
@testable import Random

// MARK: - Реализация ApplicationServicesMock

final class ApplicationServicesMock: ApplicationServices {

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
    onboardingServiceIml
  }

  // MARK: - Private property
  
  let storageServiceImpl = StorageServiceMock()
  let deepLinkServiceImpl = DeepLinkServiceMock()
  let networkServiceImpl = NetworkServiceMock()
  let buttonCounterServiceImpl = ButtonCounterServiceMock()
  let hapticServiceImpl = HapticServiceMock()
  let timerServiceImpl = TimerServiceMock()
  let appPurchasesServiceImpl = AppPurchasesServiceMock()
  let cloudDatabaseServiceImpl = CloudDatabaseServiceMock()
  let authenticationServiceImpl = AuthenticationServiceMock()
  let updateAppServiceImpl = UpdateAppServiceMock()
  let featureToggleServicesImpl = FeatureToggleServicesMock()
  let keyboardServiceImpl = KeyboardServiceMock()
  let metricsServiceImpl = MetricsServiceMock()
  let notificationServiceImpl = NotificationServiceMock()
  let permissionServiceImpl = PermissionServiceMock()
  let fileManagerImpl = FileManagerServiceMock()
  let onboardingServiceIml = OnboardingServiceMock()
}
