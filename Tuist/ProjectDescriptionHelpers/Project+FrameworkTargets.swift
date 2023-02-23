import ProjectDescription

extension Project {
  /// Helper function to create a framework target and an associated unit test target and example app
  public static func makeFrameworkTargets(module: Module, platform: Platform) -> [Target] {
    let appearance = Appearance()
    
    let frameworkPath = "\(module.moduleType.path())/\(module.path)"
    
    let frameworkResourceFilePaths = module.frameworkResources.map {
      ResourceFileElement.glob(
        pattern: Path("\(module.moduleType.path())/\(module.path)/" + $0),
        tags: []
      )
    }
    
    let exampleResourceFilePaths = module.exampleResources.map {
      ResourceFileElement.glob(
        pattern: Path("\(module.moduleType.path())/\(module.path)/\(appearance.examplePath)/" + $0),
        tags: []
      )
    }
    
    let testResourceFilePaths = module.testResources.map {
      ResourceFileElement.glob(
        pattern: Path("\(module.moduleType.path())/\(module.path)/Tests/" + $0),
        tags: []
      )
    }
    
    var exampleAppDependancies = module.exampleDependencies
    exampleAppDependancies.append(.target(name: module.name))
    
    let exampleSourcesPath = "\(module.moduleType.path())/\(module.path)/\(appearance.examplePath)/Sources"
    let exampleAppName = "\(module.name)\(appearance.exampleAppSuffix)"
    var targets: [Target] = []
    
    if module.targets.contains(.framework) {
      let headers = Headers.headers(public: ["\(frameworkPath)/Sources/**/*.h"])
      targets.append(Target(name: module.name,
                            platform: platform,
                            product: .framework,
                            bundleId: "\(appearance.reverseOrganizationName).\(module.name)",
                            infoPlist: .default,
                            sources: ["\(frameworkPath)/Sources/**"],
                            resources: ResourceFileElements(resources: frameworkResourceFilePaths),
                            headers: headers,
                            dependencies: module.frameworkDependancies))
    }
    
    if module.targets.contains(.unitTests) {
      targets.append(Target(name: "\(module.name)Tests",
                            platform: platform,
                            product: .unitTests,
                            bundleId: "\(appearance.reverseOrganizationName).\(module.name)Tests",
                            infoPlist: .default,
                            sources: ["\(frameworkPath)/Tests/**"],
                            resources: ResourceFileElements(resources: testResourceFilePaths),
                            dependencies: [.target(name: module.name)]))
    }
    
    if module.targets.contains(.exampleApp) {
      targets.append(Target(name: exampleAppName,
                            platform: platform,
                            product: .app,
                            bundleId: "\(appearance.reverseOrganizationName).\(module.name)\(appearance.exampleAppSuffix)",
                            infoPlist: makeAppInfoPlist(),
                            sources: ["\(exampleSourcesPath)/**"],
                            resources: ResourceFileElements(resources: exampleResourceFilePaths),
                            dependencies: exampleAppDependancies))
    }
    
    if module.targets.contains(.uiTests) {
      targets.append(Target(name: "\(module.name)UITests",
                            platform: platform,
                            product: .uiTests,
                            bundleId: "\(appearance.reverseOrganizationName).\(module.name)UITests",
                            infoPlist: .default,
                            sources: ["\(frameworkPath)/UITests/**"],
                            resources: ResourceFileElements(resources: testResourceFilePaths),
                            dependencies: [.target(name: exampleAppName)]))
    }
    return targets
  }
}
