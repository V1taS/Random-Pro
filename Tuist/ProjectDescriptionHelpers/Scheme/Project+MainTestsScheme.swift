import Foundation
import ProjectDescription

// MARK: - IOS

public let mainTestsIOSScheme: Scheme = .scheme(
  name: "\(appName)Tests",
  buildAction: .buildAction(targets: ["\(appName)", "\(appName)Tests"]),
  testAction: .targets(["\(appName)Tests"]),
  runAction: .runAction(
    arguments: .arguments(environmentVariables: ["OS_ACTIVITY_MODE": .environmentVariable(value: "disable", isEnabled: true)])
  ),
  archiveAction: ArchiveAction.archiveAction(configuration: .release),
  profileAction: ProfileAction.profileAction(configuration: .release),
  analyzeAction: AnalyzeAction.analyzeAction(configuration: .debug)
)
