import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: permissionService,
  organizationName: organizationName,
  targets: [
    Target(
      name: permissionService,
      platform: .iOS,
      product: .framework,
      productName: nil,
      bundleId: "\(reverseOrganizationName).\(permissionService)",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .extendingDefault(with: [
        "NSCameraUsageDescription": .string("Please provide access to the Camera"),
        "NSContactsUsageDescription": .string("Provide access to randomly generate contacts"),
        "NSUserTrackingUsageDescription": .string("Can you use your activity data? If you allow, Random Pro's ads on websites and other apps will be more relevant."),
        "NSPhotoLibraryUsageDescription": .string("Please provide access to the Photo Library"),
        "NSPhotoLibraryAddUsageDescription": .string("Please provide access to the Photo Library")
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
      dependencies: []
    ),
    Target(
      name: "\(permissionService)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(reverseOrganizationName).\(permissionService)Tests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["Tests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(permissionService)")
      ]),
    Target(
      name: "\(permissionService)UITests",
      platform: .iOS,
      product: .uiTests,
      bundleId: "\(reverseOrganizationName).\(permissionService)UITests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["UITests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(permissionService)")
      ])
  ]
)
