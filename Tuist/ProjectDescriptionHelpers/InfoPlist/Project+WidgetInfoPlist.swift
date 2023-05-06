import Foundation
import ProjectDescription

public func getWidgetIOSInfoPlist() -> ProjectDescription.InfoPlist {
  return .dictionary([
    "CFBundleDevelopmentRegion": .string("en"),
    "CFBundleDisplayName": .string("Random Pro Widget"),
    "CFBundleIdentifier": .string("\(reverseOrganizationName).\(appName).\(widgetName)"),
    "CFBundleShortVersionString": .string("\(marketingVersion)"),
    "CFBundleVersion": .string("\(currentProjectVersion)"),
    "CFBundlePackageType": .string("WGRP"),
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
    "CFBundleInfoDictionaryVersion": .string("6.0"),
    "DTPlatformName": .string("iphoneos"),
    "DTSDKName": .string("iphoneos14.0"),
    "MinimumOSVersion": .string("14.0")
  ])
}
