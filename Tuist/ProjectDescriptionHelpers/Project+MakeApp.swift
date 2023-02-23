import ProjectDescription

extension Project {
  /// Helper function to create the Project for this ExampleApp
  public static func app(name: String,
                         platform: Platform,
                         externalDependencies: [String],
                         targetDependancies: [TargetDependency] = [],
                         moduleTargets: [Module]) -> Project {
    var dependencies = moduleTargets.map { TargetDependency.target(name: $0.name) }
    dependencies.append(contentsOf: targetDependancies)
    
    let externalTargetDependencies = externalDependencies.map {
      TargetDependency.external(name: $0)
    }
    dependencies.append(contentsOf: externalTargetDependencies)
    
    var targets = makeAppTargets(name: name,
                                 platform: platform,
                                 dependencies: dependencies)
    
    targets += moduleTargets.flatMap({ makeFrameworkTargets(module: $0, platform: platform) })
    
    /// These schemes were previously used for testing specific UI test cases but not needed now.
    // let schemes = makeSchemes(targetName: name)
    
    /// Add custom schemes with code coverage enabled
    // schemes += moduleTargets.flatMap({ makeSchemeWithCodeCoverage(targetName: $0.name) })
    
    let automaticSchemesOptions = Options.AutomaticSchemesOptions.enabled(
      targetSchemesGrouping: .byNameSuffix(build: ["Implementation",
                                                   "Interface",
                                                   "Mocks",
                                                   "Testing"],
                                           test: ["Tests",
                                                  "IntegrationTests",
                                                  "UITests",
                                                  "SnapshotTests"],
                                           run: ["App",
                                                 "Example"]),
      codeCoverageEnabled: true,
      testingOptions: TestingOptions()
    )
    
    let options = Project.Options.options(automaticSchemesOptions: automaticSchemesOptions,
                                          developmentRegion: nil,
                                          disableBundleAccessors: false,
                                          disableShowEnvironmentVarsInScriptPhases: false,
                                          disableSynthesizedResourceAccessors: false,
                                          textSettings: Options.TextSettings.textSettings(),
                                          xcodeProjectName: nil)
    return Project(name: name,
                   organizationName: Appearance().organizationName,
                   options: options,
                   targets: targets,
                   schemes: [])
  }
}
