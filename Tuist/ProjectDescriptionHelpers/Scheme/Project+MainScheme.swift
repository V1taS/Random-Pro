import Foundation
import ProjectDescription

// MARK: - IOS

public let mainIOSScheme = Scheme(
  name: appName,
  buildAction: .buildAction(targets: ["\(appName)"]),
  runAction: .runAction(
    arguments: Arguments(environment: [
      "OS_ACTIVITY_MODE": "disable"
    ])
  ),
  archiveAction: ArchiveAction.archiveAction(configuration: .release),
  profileAction: ProfileAction.profileAction(configuration: .release),
  analyzeAction: AnalyzeAction.analyzeAction(configuration: .debug)
)
