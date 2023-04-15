import Foundation
import ProjectDescription

public func getMainIOSInfoPlist() -> ProjectDescription.InfoPlist {
  return .dictionary([
    "MARKETING_VERSION": .string("\(marketingVersion)"),
    "CFBundleShortVersionString": .string("\(marketingVersion)"),
    "CFBundleVersion": .string("\(currentProjectVersion)"),
    "CURRENT_PROJECT_VERSION": .string("\(currentProjectVersion)"),
    "PRODUCT_BUNDLE_IDENTIFIER": .string("com.sosinvitalii.Random"),
    "DISPLAY_NAME": .string("Random Pro"),
    "UISupportsDocumentBrowser": .boolean(true),
    "CFBundleAllowMixedLocalizations": .boolean(true),
    "CFBundleURLTypes": .array([
      .dictionary([
        "CFBundleTypeRole": .string("Editor"),
        "CFBundleURLName": .string("com.sosinvitalii.Deeplink"),
        "CFBundleURLSchemes": .array([
          .string("random")
        ])
      ])
    ]),
    "CFBundleDocumentTypes": .array([
      .dictionary([
        "CFBundleTypeExtensions": .array([
          .string("pdf")
        ]),
        "CFBundleTypeName": .string("PDF Document"),
        "CFBundleTypeRole": .string("Editor"),
        "LSHandlerRank": .string("Owner")
      ]),
      .dictionary([
        "CFBundleTypeExtensions": .array([
          .string("png"),
          .string("jpg"),
          .string("jpeg")
        ]),
        "CFBundleTypeName": .string("Image"),
        "CFBundleTypeRole": .string("Editor"),
        "LSHandlerRank": .string("Owner")
      ]),
      .dictionary([
        "CFBundleTypeExtensions": .array([
          .string("txt")
        ]),
        "CFBundleTypeName": .string("Text"),
        "CFBundleTypeRole": .string("Editor"),
        "LSHandlerRank": .string("Owner")
      ])
    ]),
    "IPHONEOS_DEPLOYMENT_TARGET": .string("13.0"),
    "CFBundleExecutable": .string("Random"),
    "TAB_WIDTH": .string("2"),
    "INDENT_WIDTH": .string("2"),
    "DEVELOPMENT_TEAM": .string("34VDSPZYU9"),
    "LSSupportsOpeningDocumentsInPlace": .boolean(true),
    "CFBundleLocalizations": .array([
      .string("en"),
      .string("de"),
      .string("es"),
      .string("it"),
      .string("ru"),
      .string("tr")
    ]),
    "CODE_SIGN_STYLE": .string("Automatic"),
    "CODE_SIGN_IDENTITY": .string("iPhone Developer"),
    "ENABLE_BITCODE": .string("NO"),
    "CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED": .string("YES"),
    "ENABLE_TESTABILITY": .string("YES"),
    "VALID_ARCHS": .string("arm64"),
    "DTPlatformVersion": .string("13.0"),
    "CFBundleName": .string("Random Pro"),
    "CFBundleDisplayName": .string("Random Pro"),
    "CFBundleIdentifier": .string("com.sosinvitalii.Random"),
    "LSApplicationCategoryType": .string("public.app-category.utilities"),
    "ITSAppUsesNonExemptEncryption": .boolean(false),
    "TARGETED_DEVICE_FAMILY": .string("1,2"),
    "UIRequiresFullScreen": .boolean(true),
    "UILaunchStoryboardName": .string("LaunchScreen.storyboard"),
    "UIApplicationSupportsIndirectInputEvents": .boolean(true),
    "CFBundlePackageType": .string("APPL"),
    "NSCameraUsageDescription": .string("Please provide access to the Camera"),
    "NSAccentColorName": .string("AccentColor"),
    "CFBundleInfoDictionaryVersion": .string("6.0"),
    "NSContactsUsageDescription": .string("Provide access to randomly generate contacts"),
    "NSPhotoLibraryUsageDescription": .string("Please provide access to the Photo Library"),
    "DTXcode": .integer(1420),
    "LSRequiresIPhoneOS": .boolean(true),
    "DTCompiler": .string("com.apple.compilers.llvm.clang.1_0"),
    "UIStatusBarStyle": .string("UIStatusBarStyleLightContent"),
    "CFBundleDevelopmentRegion": .string("en"),
    "DTSDKBuild": .string("20C52"),
    "DTPlatformBuild": .string("20C52"),
    "UIApplicationSceneManifest": .dictionary([
      "UIApplicationSupportsMultipleScenes": .boolean(false),
      "UISceneConfigurations": .dictionary([
        "UIWindowSceneSessionRoleApplication": .array([
          .dictionary([
            "UISceneConfigurationName": .string("Default Configuration"),
            "UISceneDelegateClassName": .string("Random.SceneDelegate")
          ])
        ])
      ])
    ]),
    "DTPlatformName": .string("iphoneos"),
    "DTXcodeBuild": .string("14C18"),
    "NSPhotoLibraryAddUsageDescription": .string("Please provide access to the Photo Library"),
    "UISupportedInterfaceOrientations~ipad": .array([
      .string("UIInterfaceOrientationPortrait"),
      .string("UIInterfaceOrientationPortraitUpsideDown"),
      .string("UIInterfaceOrientationLandscapeLeft"),
      .string("UIInterfaceOrientationLandscapeRight")
    ]),
    "UIStatusBarHidden": .boolean(false),
    "CFBundleIcons": .dictionary([
      "CFBundleAlternateIcons": .dictionary([
        "selecte_app_icon_blue_raspberry": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_blue_raspberry")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_crimson_tide": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_crimson_tide")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_evening_night": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_evening_night")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_grade_grey": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_grade_grey")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_harvey": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_harvey")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_lithium": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_lithium")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_midnight_city": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_midnight_city")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_moon_purple": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_moon_purple")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_moonlit_asteroid": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_moonlit_asteroid")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_orange_fun": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_orange_fun")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_pure_lust": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_pure_lust")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_selenium": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_selenium")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_terminal": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_terminal")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_summer_dog": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_summer_dog")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_sin_city_red": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_sin_city_red")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_queen_necklace": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_queen_necklace")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_marine_fuchsia": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_marine_fuchsia")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_sandy_desert": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_sandy_desert")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_red_lime": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_red_lime")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_heliotrope": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_heliotrope")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_violet_lemon": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_violet_lemon")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_avocado": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_avocado")]),
          "UIPrerenderedIcon": .boolean(false)
        ]),
        "selecte_app_icon_frosty_sky": .dictionary([
          "CFBundleIconFiles": .array([.string("selecte_app_icon_frosty_sky")]),
          "UIPrerenderedIcon": .boolean(false)
        ])
      ])
    ])
  ])
}
