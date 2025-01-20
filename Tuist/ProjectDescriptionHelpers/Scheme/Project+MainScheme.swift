import Foundation
import ProjectDescription

// MARK: - IOS

public let mainIOSScheme: Scheme = .scheme(
  name: appName,
  buildAction: .buildAction(targets: ["\(appName)"]),
  runAction: .runAction(
    arguments: .arguments(environmentVariables: ["OS_ACTIVITY_MODE": .environmentVariable(value: "disable", isEnabled: true)])
  ),
  archiveAction: ArchiveAction.archiveAction(
    configuration: .release
  ),
  profileAction: ProfileAction.profileAction(configuration: .release),
  analyzeAction: AnalyzeAction.analyzeAction(configuration: .debug)
)
