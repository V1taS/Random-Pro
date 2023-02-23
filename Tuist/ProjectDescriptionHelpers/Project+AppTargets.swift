import ProjectDescription

extension Project {
  /// Helper function to create the application target and the unit test target.
  public static func makeAppTargets(name: String,
                                    platform: Platform,
                                    dependencies: [TargetDependency]) -> [Target] {
    let appearance = Appearance()
    let mainTarget = Target(
      name: name,
      platform: platform,
      product: .app,
      bundleId: "\(appearance.reverseOrganizationName).\(name)",
      infoPlist: makeAppInfoPlist(),
      sources: [
        "\(appearance.appPath)/\(name)/Sources/**"
      ],
      resources: [
        "\(appearance.appPath)/\(name)/Resources/**"
                 ],
      scripts: [
      ],
      dependencies: dependencies
    )
    
    let testTarget = Target(
      name: "\(name)Tests",
      platform: platform,
      product: .unitTests,
      bundleId: "\(appearance.reverseOrganizationName).\(name)Tests",
      infoPlist: .default,
      sources: ["\(appearance.appPath)/\(name)/Tests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(name)")
      ])
    
    let uiTestTarget = Target(
      name: "\(name)UITests",
      platform: platform,
      product: .uiTests,
      bundleId: "\(appearance.reverseOrganizationName).\(name)UITests",
      infoPlist: .default,
      sources: ["\(appearance.appPath)/\(name)/UITests/**"],
      resources: [],
      dependencies: [
        .target(name: "\(name)")
      ])
    return [mainTarget, testTarget, uiTestTarget]
  }
}
