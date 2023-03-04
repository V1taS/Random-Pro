import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Setup project

let project = Project(
  name: firebaseService,
  organizationName: organizationName,
  targets: [
    Target(
      name: firebaseService,
      platform: .iOS,
      product: .framework,
      productName: nil,
      bundleId: "\(reverseOrganizationName).\(firebaseService)",
      deploymentTarget: .iOS(targetVersion: "13.0", devices: .iphone),
      infoPlist: .default,
      sources: [
        "Sources/**"
      ],
      scripts: [
        scriptSwiftLint
      ],
      dependencies: [
        .external(name: "YandexMobileMetrica"),
        .external(name: "FirebaseAnalytics"),
        .external(name: "FirebaseFirestore"),
        .external(name: "FirebaseAuth")
      ],
      settings: .settings(
        debug: [
          "OTHER_LDFLAGS": [
            "$(OTHER_LDFLAGS)",
            "-ObjC"
          ]
        ],
        release: [
          "OTHER_LDFLAGS": [
            "$(OTHER_LDFLAGS)",
            "-ObjC"
          ]
        ]
      )
    )
  ]
)
