import Foundation
import ProjectDescription

// MARK: - IOS Widget

public let yesNoWidgetScheme = Scheme(
  name: widgetName,
  hidden: true,
  buildAction: .buildAction(targets: ["\(widgetName)"]),
  runAction: .runAction(
    arguments: Arguments(environment: [
      "_XCWidgetKind": "",
      "_XCWidgetDefaultView": "timeline",
      "XCWidgetFamily": "medium"
    ])
  ),
  archiveAction: ArchiveAction.archiveAction(configuration: .release),
  profileAction: ProfileAction.profileAction(configuration: .release),
  analyzeAction: AnalyzeAction.analyzeAction(configuration: .debug)
)
