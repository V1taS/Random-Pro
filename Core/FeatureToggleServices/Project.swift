import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: featureToggleServices,
  organizationName: organizationName,
  targets: [
    Target(
      name: featureToggleServices,
      platform: .iOS,
      product: .framework,
      productName: nil,
      bundleId: "\(reverseOrganizationName).\(featureToggleServices)",
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
