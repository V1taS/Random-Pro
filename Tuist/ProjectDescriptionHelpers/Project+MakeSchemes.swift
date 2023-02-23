import ProjectDescription

extension Project {
  public static func makeSchemes(targetName: String) -> [Scheme] {
    let mainTargetReference = TargetReference(stringLiteral: targetName)
    let debugConfiguration = ConfigurationName(stringLiteral: "Debug")
    let buildAction = BuildAction(targets: [mainTargetReference])
    let executable = mainTargetReference
    let asyncTestingLaunchArguments = Arguments(launchArguments: [
      LaunchArgument(name: "AsyncTesting",
                     isEnabled: true)
    ])
    let uiTestingLaunchArguments = Arguments(launchArguments: [
      LaunchArgument(name: "UITesting",
                     isEnabled: true)
    ])
    let target = TestableTarget(stringLiteral: "\(targetName)UITests")
    let testAction =
    TestAction.targets([target],
                       arguments: nil,
                       configuration: debugConfiguration,
                       attachDebugger: false,
                       expandVariableFromTarget: nil,
                       preActions: [],
                       postActions: [],
                       options: TestActionOptions.options(),
                       diagnosticsOptions: [])
    
    let runActionOptions = RunActionOptions.options(language: nil,
                                                    storeKitConfigurationPath: nil, simulatedLocation: nil)
    let asyncRunAction = RunAction.runAction(configuration: debugConfiguration,
                                             attachDebugger: false,
                                             preActions: [],
                                             postActions: [],
                                             executable: executable,
                                             arguments: asyncTestingLaunchArguments,
                                             options: runActionOptions,
                                             diagnosticsOptions: [])
    
    let asyncTestingScheme = Scheme(
      name: "\(targetName)AsyncNetworkTesting",
      shared: false,
      buildAction: buildAction,
      runAction: asyncRunAction)
    
    let uiTestRunAction = RunAction.runAction(configuration: debugConfiguration,
                                              attachDebugger: false,
                                              preActions: [],
                                              postActions: [],
                                              executable: executable,
                                              arguments: uiTestingLaunchArguments,
                                              options: runActionOptions,
                                              diagnosticsOptions: [])
    
    let uiTestingScheme = Scheme(
      name: "\(targetName)UITesting",
      shared: false,
      buildAction: buildAction,
      testAction: testAction,
      runAction: uiTestRunAction)
    
    return [asyncTestingScheme, uiTestingScheme]
  }
  
  public static func makeSchemeWithCodeCoverage(targetName: String) -> [Scheme] {
    let mainTargetReference = TargetReference(stringLiteral: targetName)
    let debugConfiguration = ConfigurationName(stringLiteral: "Debug")
    let buildAction = BuildAction(targets: [mainTargetReference])
    let executable = mainTargetReference
    let launchArguments = Arguments(launchArguments: [LaunchArgument(name: "Testing", isEnabled: true)])
    let target = TestableTarget(stringLiteral: "\(targetName)Tests")
    let testActionOptions = TestActionOptions.options(language: SchemeLanguage.init(stringLiteral: "en-US"),
                                                      region: "en-US",
                                                      coverage: true,
                                                      codeCoverageTargets: [])
    
    let testAction =
    TestAction.targets([target],
                       arguments: nil,
                       configuration: debugConfiguration,
                       attachDebugger: false,
                       expandVariableFromTarget: nil,
                       preActions: [],
                       postActions: [],
                       options: testActionOptions,
                       diagnosticsOptions: [])
    
    let runActionOptions = RunActionOptions.options(language: nil,
                                                    storeKitConfigurationPath: nil, simulatedLocation: nil)
    
    let runAction = RunAction.runAction(configuration: debugConfiguration,
                                        attachDebugger: false,
                                        preActions: [],
                                        postActions: [],
                                        executable: executable,
                                        arguments: launchArguments,
                                        options: runActionOptions,
                                        diagnosticsOptions: [])
    
    let testingScheme = Scheme(
      name: "\(targetName)WithCodeCoverage",
      shared: false,
      buildAction: buildAction,
      testAction: testAction,
      runAction: runAction)
    
    return [testingScheme]
  }
}
