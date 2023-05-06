import Foundation
import ProjectDescription

public func getWidgetIOSInfoPlist() -> ProjectDescription.InfoPlist {
  return .dictionary([
    "CFBundleDevelopmentRegion": .string("en"),
    "CFBundleDisplayName": .string("Random Pro Widget"),
    "CFBundleIdentifier": .string("\(reverseOrganizationName).\(appName).\(widgetName)"),
    "CFBundleShortVersionString": .string("\(marketingVersion)"),
    "CFBundleVersion": .string("\(currentProjectVersion)"),
    "CFBundleExecutable": .string("$(EXECUTABLE_NAME)"),
    "CFBundleName": .string("YesNoWidget"),
    "NSExtension": .dictionary([
      "NSExtensionAttributes": .dictionary([
        "UNNotificationExtensionCategory": .string("CATEGORY_IDENTIFIER")
      ]),
      "NSExtensionPointIdentifier": .string("com.apple.widgetkit-extension")
    ]),
    "CFBundleLocalizations": .array([
      .string("en"),
      .string("ru"),
      .string("de"),
      .string("es"),
      .string("it")
    ]),
    "MinimumOSVersion": .string("14.0")
  ])
}
