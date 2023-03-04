import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: yesNoScreenModule,
  organizationName: organizationName,
  targets: [
    Target(
      name: yesNoScreenModule,
      platform: .iOS,
      product: .framework,
      productName: nil,
      bundleId: "\(reverseOrganizationName).\(yesNoScreenModule)",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
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
        .external(name: "RandomUIKit")
      ]
    ),
    Target(
      name: "\(yesNoScreenModule)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(reverseOrganizationName).\(yesNoScreenModule)Tests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["Tests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(yesNoScreenModule)")
      ]),
    Target(
      name: "\(yesNoScreenModule)UITests",
      platform: .iOS,
      product: .uiTests,
      bundleId: "\(reverseOrganizationName).\(yesNoScreenModule)UITests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["UITests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(yesNoScreenModule)")
      ])
  ]
)
