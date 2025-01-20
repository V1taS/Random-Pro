import Foundation
import ProjectDescription

// MARK: - IOS Widget

public let yesNoWidgetScheme: Scheme = .scheme(
  name: widgetName,
  hidden: true,
  buildAction: .buildAction(targets: ["\(widgetName)"]),
  runAction: .runAction(
    arguments: .arguments(environmentVariables: [
      "_XCWidgetKind": .environmentVariable(value: "", isEnabled: true),
      "_XCWidgetDefaultView": .environmentVariable(value: "timeline", isEnabled: true),
      "XCWidgetFamily": .environmentVariable(value: "medium", isEnabled: true)
    ])
  ),
  archiveAction: ArchiveAction.archiveAction(configuration: .release),
  profileAction: ProfileAction.profileAction(configuration: .release),
  analyzeAction: AnalyzeAction.analyzeAction(configuration: .debug)
)
