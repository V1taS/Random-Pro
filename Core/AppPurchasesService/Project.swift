import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: appPurchasesService,
  organizationName: organizationName,
  targets: [
    Target(
      name: appPurchasesService,
      platform: .iOS,
      product: .framework,
      productName: nil,
      bundleId: "\(reverseOrganizationName).\(appPurchasesService)",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .extendingDefault(with: [
        "NSUserTrackingUsageDescription": .string("Can you use your activity data? If you allow, Random Pro's ads on websites and other apps will be more relevant.")
      ]),
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
        .external(name: "ApphudSDK")
      ]
    ),
    Target(
      name: "\(appPurchasesService)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(reverseOrganizationName).\(appPurchasesService)Tests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["Tests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(appPurchasesService)")
      ]),
    Target(
      name: "\(appPurchasesService)UITests",
      platform: .iOS,
      product: .uiTests,
      bundleId: "\(reverseOrganizationName).\(appPurchasesService)UITests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["UITests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(appPurchasesService)")
      ])
  ]
)
