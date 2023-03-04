import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: colorsScreenModule,
  organizationName: organizationName,
  targets: [
    Target(
      name: colorsScreenModule,
      platform: .iOS,
      product: .framework,
      productName: nil,
      bundleId: "\(reverseOrganizationName).\(colorsScreenModule)",
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
      name: "\(colorsScreenModule)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(reverseOrganizationName).\(colorsScreenModule)Tests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["Tests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(colorsScreenModule)")
      ]),
    Target(
      name: "\(colorsScreenModule)UITests",
      platform: .iOS,
      product: .uiTests,
      bundleId: "\(reverseOrganizationName).\(colorsScreenModule)UITests",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: ["UITests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(colorsScreenModule)")
      ])
  ]
)
