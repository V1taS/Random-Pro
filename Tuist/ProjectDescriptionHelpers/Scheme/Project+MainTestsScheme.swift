import Foundation
import ProjectDescription

// MARK: - IOS

public let mainTestsIOSScheme = Scheme(
  name: "\(appName)Tests",
  buildAction: .buildAction(targets: ["\(appName)", "\(appName)Tests"]),
  testAction: .targets(["\(appName)Tests"]),
  runAction: .runAction(
    arguments: Arguments(environment: [
      "OS_ACTIVITY_MODE": "disable"
    ])
  ),
  archiveAction: ArchiveAction.archiveAction(configuration: .release),
  profileAction: ProfileAction.profileAction(configuration: .release),
  analyzeAction: AnalyzeAction.analyzeAction(configuration: .debug)
)
