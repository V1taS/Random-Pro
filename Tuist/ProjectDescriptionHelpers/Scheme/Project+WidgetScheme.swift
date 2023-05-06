import Foundation
import ProjectDescription

// MARK: - IOS Widget

public let yesNoWidgetScheme = Scheme(
  name: widgetName,
  shared: true,
  buildAction: BuildAction(
    targets: [
      TargetReference.project(path: .relativeToRoot("."),
                              target: widgetName)
    ]
  ),
  runAction: RunAction.runAction(
    configuration: .debug,
    attachDebugger: true,
    executable: TargetReference.project(path: .relativeToRoot("."),
                                        target: widgetName),
    arguments: Arguments(environment: [
      "OS_ACTIVITY_MODE": "disable"
    ])
  ),
  archiveAction: ArchiveAction.archiveAction(configuration: .release),
  profileAction: ProfileAction.profileAction(configuration: .release),
  analyzeAction: AnalyzeAction.analyzeAction(configuration: .debug)
)
