import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: metricsService,
  organizationName: organizationName,
  targets: [
    Target(
      name: metricsService,
      platform: .iOS,
      product: .framework,
      productName: nil,
      bundleId: "\(reverseOrganizationName).\(metricsService)",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: [
        "Sources/**"
      ],
      scripts: [
        scriptSwiftLint
      ],
      dependencies: []
    )
  ]
)
