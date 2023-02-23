import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Project

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(name: "Random",
                          platform: .iOS,
                          externalDependencies: [],
                          targetDependancies: [
                            .external(name: "YandexMobileMetricaPush"),
                            .external(name: "YandexMobileMetrica"),
                            .external(name: "FirebaseFirestore"),
                            .external(name: "ApphudSDK"),

                            // MARK: - Features
                            /// - Main screen
                            .target(name: Appearance().moduleMainScreenModule),
                            .target(name: Appearance().moduleBottleScreenModule),
                            .target(name: Appearance().moduleCoinScreenModule),
                            .target(name: Appearance().moduleColorsScreenModule),
                            .target(name: Appearance().moduleContactScreenModule),
                            .target(name: Appearance().moduleCubesScreenModule),
                            .target(name: Appearance().moduleDateTimeScreenModule),
                            .target(name: Appearance().moduleFilmsScreenModule),
                            .target(name: Appearance().moduleImageFiltersScreenModule),
                            .target(name: Appearance().moduleLetterScreenModule),
                            .target(name: Appearance().moduleListScreenModule),
                            .target(name: Appearance().moduleListResultScreenModule),
                            .target(name: Appearance().moduleLotteryScreenModule),
                            .target(name: Appearance().moduleNumberScreenModule),
                            .target(name: Appearance().modulePasswordScreenModule),
                            .target(name: Appearance().moduleRockPaperScissorsScreenModule),
                            .target(name: Appearance().moduleSettingsScreenModule),
                            .target(name: Appearance().moduleShareScreenModule),
                            .target(name: Appearance().moduleTeamsScreenModule),
                            .target(name: Appearance().moduleYesNoScreenModule),
                            /// - Settings screen
                            .target(name: Appearance().moduleCustomMainSectionsModule),
                            .target(name: Appearance().moduleMainSettingsScreenModule),
                            .target(name: Appearance().moduleSelecteAppIconScreenModule),
                            /// - Shared screen
                            .target(name: Appearance().modulePremiumScreenModule),
                            
                            // MARK: - Core
                            .target(name: Appearance().applicationInterface),
                            .target(name: Appearance().keyboardService),
                            .target(name: Appearance().networkService),
                            .target(name: Appearance().metricsService),
                            .target(name: Appearance().notificationService),
                            .target(name: Appearance().permissionService),
                            .target(name: Appearance().fileManagerService),
                            .target(name: Appearance().deepLinkService),
                            .target(name: Appearance().timerService),
                            .target(name: Appearance().featureToggleServices),
                            .target(name: Appearance().updateAppService),
                            .target(name: Appearance().authenticationService),
                            .target(name: Appearance().appPurchasesService),
                            .target(name: Appearance().storageService)
                          ],
                          moduleTargets: [
                            // MARK: - Features
                            /// - Main screen
                            makeMainScreenModule(),
                            makeBottleScreenModule(),
                            makeCoinScreenModule(),
                            makeColorsScreenModule(),
                            makeContactScreenModule(),
                            makeCubesScreenModule(),
                            makeDateTimeScreenModule(),
                            makeFilmsScreenModule(),
                            makeImageFiltersScreenModule(),
                            makeLetterScreenModule(),
                            makeListScreenModule(),
                            makeListResultScreenModule(),
                            makeLotteryScreenModule(),
                            makeNumberScreenModule(),
                            makePasswordScreenModule(),
                            makeRockPaperScissorsScreenModule(),
                            makeSettingsScreenModule(),
                            makeShareScreenModule(),
                            makeTeamsScreenModule(),
                            makeYesNoScreenModule(),
                            /// - Settings screen
                            makeCustomMainSectionsModule(),
                            makeMainSettingsScreenModule(),
                            makeSelecteAppIconScreenModule(),
                            /// - Shared screen
                            makePremiumScreenModule(),
                            
                            // MARK: - Core
                            makeApplicationInterface(),
                            makeKeyboardService(),
                            makeNetworkService(),
                            makeMetricsService(),
                            makeNotificationService(),
                            makePermissionService(),
                            makeFileManagerService(),
                            makeDeepLinkService(),
                            makeTimerService(),
                            makeHapticService(),
                            makeFeatureToggleServices(),
                            makeUpdateAppService(),
                            makeAuthenticationService(),
                            makeAppPurchasesService(),
                            makeStorageService()
                          ])

// MARK: - Core

func makeStorageService() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.storageService,
                moduleType: .core(appearance.applicationServicesFolder),
                path: appearance.storageService,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "KeychainSwift")
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework])
}

func makeAppPurchasesService() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.appPurchasesService,
                moduleType: .core(appearance.applicationServicesFolder),
                path: appearance.appPurchasesService,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "ApphudSDK"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework])
}

func makeAuthenticationService() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.authenticationService,
                moduleType: .core(appearance.applicationServicesFolder),
                path: appearance.authenticationService,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "FirebaseFirestore"),
                  .external(name: "FirebaseAuth")
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework])
}

func makeUpdateAppService() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.updateAppService,
                moduleType: .core(appearance.applicationServicesFolder),
                path: appearance.updateAppService,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface)
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework])
}

func makeFeatureToggleServices() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.featureToggleServices,
                moduleType: .core(appearance.applicationServicesFolder),
                path: appearance.featureToggleServices,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "FirebaseFirestore"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework])
}

func makeHapticService() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.hapticService,
                moduleType: .core(appearance.applicationServicesFolder),
                path: appearance.hapticService,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface)
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework])
}

func makeTimerService() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.timerService,
                moduleType: .core(appearance.applicationServicesFolder),
                path: appearance.timerService,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface)
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework])
}

func makeDeepLinkService() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.deepLinkService,
                moduleType: .core(appearance.applicationServicesFolder),
                path: appearance.deepLinkService,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface)
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework])
}

func makeFileManagerService() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.fileManagerService,
                moduleType: .core(appearance.applicationServicesFolder),
                path: appearance.fileManagerService,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface)
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework])
}

func makePermissionService() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.permissionService,
                moduleType: .core(appearance.applicationServicesFolder),
                path: appearance.permissionService,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface)
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework])
}

func makeNotificationService() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.notificationService,
                moduleType: .core(appearance.applicationServicesFolder),
                path: appearance.notificationService,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                  .external(name: "Notifications")
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework])
}

func makeMetricsService() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.metricsService,
                moduleType: .core(appearance.applicationServicesFolder),
                path: appearance.metricsService,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "YandexMobileMetrica"),
                  .external(name: "FirebaseAnalytics")
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework])
}

func makeNetworkService() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.networkService,
                moduleType: .core(appearance.applicationServicesFolder),
                path: appearance.networkService,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomNetwork")
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework])
}

func makeKeyboardService() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.keyboardService,
                moduleType: .core(appearance.applicationServicesFolder),
                path: appearance.keyboardService,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface)
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework])
}

func makeApplicationInterface() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.applicationInterface,
                moduleType: .core(),
                path: appearance.applicationInterface,
                frameworkDependancies: [],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework])
}

// MARK: - Features

// - Shared screen

func makePremiumScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.modulePremiumScreenModule,
                moduleType: .feature(),
                path: appearance.modulePremiumScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

// - Settings screen

func makeSelecteAppIconScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleSelecteAppIconScreenModule,
                moduleType: .feature(),
                path: appearance.moduleSelecteAppIconScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeMainSettingsScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleMainSettingsScreenModule,
                moduleType: .feature(),
                path: appearance.moduleMainSettingsScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeCustomMainSectionsModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleCustomMainSectionsModule,
                moduleType: .feature(),
                path: appearance.moduleCustomMainSectionsModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

// - Main screen

func makeYesNoScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleYesNoScreenModule,
                moduleType: .feature(),
                path: appearance.moduleYesNoScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeTeamsScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleTeamsScreenModule,
                moduleType: .feature(),
                path: appearance.moduleTeamsScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeShareScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleShareScreenModule,
                moduleType: .feature(),
                path: appearance.moduleShareScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeSettingsScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleSettingsScreenModule,
                moduleType: .feature(),
                path: appearance.moduleSettingsScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeRockPaperScissorsScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleRockPaperScissorsScreenModule,
                moduleType: .feature(),
                path: appearance.moduleRockPaperScissorsScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makePasswordScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.modulePasswordScreenModule,
                moduleType: .feature(),
                path: appearance.modulePasswordScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeNumberScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleNumberScreenModule,
                moduleType: .feature(),
                path: appearance.moduleNumberScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeLotteryScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleLotteryScreenModule,
                moduleType: .feature(),
                path: appearance.moduleLotteryScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeListResultScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleListResultScreenModule,
                moduleType: .feature(),
                path: appearance.moduleListResultScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeListScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleListScreenModule,
                moduleType: .feature(),
                path: appearance.moduleListScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeLetterScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleLetterScreenModule,
                moduleType: .feature(),
                path: appearance.moduleLetterScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeImageFiltersScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleImageFiltersScreenModule,
                moduleType: .feature(),
                path: appearance.moduleImageFiltersScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeFilmsScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleFilmsScreenModule,
                moduleType: .feature(),
                path: appearance.moduleFilmsScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeDateTimeScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleDateTimeScreenModule,
                moduleType: .feature(),
                path: appearance.moduleDateTimeScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeCubesScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleCubesScreenModule,
                moduleType: .feature(),
                path: appearance.moduleCubesScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeContactScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleContactScreenModule,
                moduleType: .feature(),
                path: appearance.moduleContactScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeColorsScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleColorsScreenModule,
                moduleType: .feature(),
                path: appearance.moduleColorsScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeCoinScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleCoinScreenModule,
                moduleType: .feature(),
                path: appearance.moduleCoinScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeBottleScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleBottleScreenModule,
                moduleType: .feature(),
                path: appearance.moduleBottleScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}

func makeMainScreenModule() -> Module {
  let appearance = Appearance()
  return Module(name: appearance.moduleMainScreenModule,
                moduleType: .feature(),
                path: appearance.moduleMainScreenModule,
                frameworkDependancies: [
                  .target(name: appearance.applicationInterface),
                  .external(name: "RandomUIKit"),
                ],
                exampleDependencies: [],
                frameworkResources: ["Resources/**"],
                exampleResources: ["Resources/**"],
                testResources: [],
                targets: [.framework, .unitTests, .uiTests, .exampleApp])
}
