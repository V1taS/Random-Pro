import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: appName,
  organizationName: organizationName,
  options: .options(),
  packages: [],
  settings: projectBuildIOSSettings,
  targets: [
    Target(
      name: appName,
      platform: .iOS,
      product: .app,
      productName: nil,
      bundleId: "\(reverseOrganizationName).\(appName)",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: getMainIOSInfoPlist(),
      sources: [
        "Sources/**"
      ],
      resources: [
        "Resources/**"
      ],
      copyFiles: nil,
      headers: nil,
      entitlements: nil,
      scripts: [
        scriptSwiftLint
      ],
      dependencies: [
        // External
        .external(name: "YandexMobileMetricaPush"),
        .external(name: "Notifications"),
        .external(name: "RandomNetwork"),
        
        // Core
        .project(target: appPurchasesService,
                 path: .relativeToRoot("\(corePath)/\(appPurchasesService)")),
          .project(target: deepLinkService,
                   path: .relativeToRoot("\(corePath)/\(deepLinkService)")),
        .project(target: firebaseService,
                 path: .relativeToRoot("\(corePath)/\(firebaseService)")),
        .project(target: fileManagerService,
                 path: .relativeToRoot("\(corePath)/\(fileManagerService)")),
        .project(target: hapticService,
                 path: .relativeToRoot("\(corePath)/\(hapticService)")),
        .project(target: keyboardService,
                 path: .relativeToRoot("\(corePath)/\(keyboardService)")),
        .project(target: permissionService,
                 path: .relativeToRoot("\(corePath)/\(permissionService)")),
        .project(target: storageService,
                 path: .relativeToRoot("\(corePath)/\(storageService)")),
        .project(target: timerService,
                 path: .relativeToRoot("\(corePath)/\(timerService)")),
        .project(target: updateAppService,
                 path: .relativeToRoot("\(corePath)/\(updateAppService)")),
        .project(target: notificationService,
                 path: .relativeToRoot("\(corePath)/\(notificationService)")),
        
        // Features
        .project(target: bottleScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(bottleScreenModule)")),
        .project(target: coinScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(coinScreenModule)")),
        .project(target: colorsScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(colorsScreenModule)")),
        .project(target: contactScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(contactScreenModule)")),
        .project(target: cubesScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(cubesScreenModule)")),
        .project(target: customMainSectionsModule,
                 path: .relativeToRoot("\(featuresPath)/\(customMainSectionsModule)")),
        .project(target: dateTimeScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(dateTimeScreenModule)")),
        .project(target: filmsScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(filmsScreenModule)")),
        .project(target: imageFiltersScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(imageFiltersScreenModule)")),
        .project(target: letterScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(letterScreenModule)")),
        .project(target: listResultScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(listResultScreenModule)")),
        .project(target: listScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(listScreenModule)")),
        .project(target: lotteryScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(lotteryScreenModule)")),
        .project(target: mainScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(mainScreenModule)")),
        .project(target: mainSettingsScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(mainSettingsScreenModule)")),
        .project(target: numberScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(numberScreenModule)")),
        .project(target: passwordScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(passwordScreenModule)")),
        .project(target: premiumScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(premiumScreenModule)")),
        .project(target: rockPaperScissorsScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(rockPaperScissorsScreenModule)")),
        .project(target: selecteAppIconScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(selecteAppIconScreenModule)")),
        .project(target: settingsScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(settingsScreenModule)")),
        .project(target: shareScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(shareScreenModule)")),
        .project(target: teamsScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(teamsScreenModule)")),
        .project(target: yesNoScreenModule,
                 path: .relativeToRoot("\(featuresPath)/\(yesNoScreenModule)"))
      ],
      settings: targetBuildIOSSettings,
      coreDataModels: [],
      environment: [:],
      launchArguments: [],
      additionalFiles: []
    ),
    Target(
      name: "\(appName)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(reverseOrganizationName).\(appName)Tests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["Tests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(appName)")
      ]),
    Target(
      name: "\(appName)UITests",
      platform: .iOS,
      product: .uiTests,
      bundleId: "\(reverseOrganizationName).\(appName)UITests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["UITests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(appName)")
      ])
  ],
  schemes: [mainIOSScheme],
  fileHeaderTemplate: nil,
  additionalFiles: [],
  resourceSynthesizers: [
    .strings(),
    .assets()
  ]
)
