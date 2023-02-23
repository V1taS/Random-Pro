import ProjectDescription

extension Project {
  public static func makeAppInfoPlist() -> InfoPlist {
    let infoPlist: [String: InfoPlist.Value] = [
      "Bundle identifier": .string("com.sosinvitalii.Random"),
      "CFBundleName": .string("Random Pro"),
      "UIDeviceFamily": .array([.integer(1), .integer(2)]),
      "UIRequiresFullScreen": .boolean(true),
      "UILaunchStoryboardName": .string("LaunchScreen"),
      "UIApplicationSupportsIndirectInputEvents": .boolean(true),
      "CFBundleDisplayName": .string("Random Pro"),
      "CFBundlePackageType": .string("APPL"),
      "NSCameraUsageDescription": .string("Please provide access to the Camera"),
      "NSAccentColorName": .string("AccentColor"),
      "CFBundleInfoDictionaryVersion": .string("6.0"),
      "NSContactsUsageDescription": .string("Provide access to randomly generate contacts"),
      "SKAdNetworkItems": .array([.dictionary([
        "SKAdNetworkIdentifier": .string("zq492l623r.skadnetwork")
      ])]),
      "UIRequiredDeviceCapabilities": .array([.string("armv7")]),
      "CFBundleSupportedPlatforms": .array([.string("iPhoneSimulator")]),
      "NSUserTrackingUsageDescription": .string("Can you use your activity data? If you allow, Random Pro's ads on websites and other apps will be more relevant."),
      "NSPhotoLibraryUsageDescription": .string("Please provide access to the Photo Library"),
      "DTXcode": .integer(1420),
      "LSRequiresIPhoneOS": .boolean(true),
      "CFBundleIcons~ipad": .dictionary([
        "CFBundlePrimaryIcon": .dictionary([
          "CFBundleIconFiles": .array([.string("AppIcon60x60"), .string("AppIcon76x76")]),
          "CFBundleIconName": .string("AppIcon")
        ])
      ]),
      "DTCompiler": .string("com.apple.compilers.llvm.clang.1_0"),
      "UIStatusBarStyle": .string("UIStatusBarStyleLightContent"),
      "CFBundleDevelopmentRegion": .string("en"),
      "DTSDKBuild": .string("20C52"),
      "UIApplicationSceneManifest": .dictionary([
        "UIApplicationSupportsMultipleScenes": .boolean(false),
        "UISceneConfigurations": .dictionary([
          "UIWindowSceneSessionRoleApplication": .array([
            .dictionary([
              "UISceneConfigurationName": .string("Default Configuration"),
              "UISceneDelegateClassName": .string("SceneDelegate")
            ])
          ])
        ])
      ]),
      "DTPlatformName": .string("iphonesimulator"),
      "DTXcodeBuild": .string("14C18"),
      "CFBundleShortVersionString": .string("730.21.2"),
      "DTPlatformVersion": .string("16.2"),
      "CFBundleVersion": .string("147.0"),
      "NSPhotoLibraryAddUsageDescription": .string("Please provide access to the Photo Library"),
      "DTPlatformBuild": .string("20C52"),
      "UISupportedInterfaceOrientations~ipad": .array([
        .string("UIInterfaceOrientationPortrait"),
        .string("UIInterfaceOrientationPortraitUpsideDown"),
        .string("UIInterfaceOrientationLandscapeLeft"),
        .string("UIInterfaceOrientationLandscapeRight")
      ]),
      "UIStatusBarHidden": .boolean(false),
      "CFBundleIcons": .dictionary([
        "CFBundleAlternateIcons": .dictionary([
          "selecte_app_icon_avocado": .dictionary([
            "CFBundleIconFiles": .array([.string("selecte_app_icon_avocado")]),
            "UIPrerenderedIcon": .boolean(false)
          ]),
          "selecte_app_icon_blue_raspberry": .dictionary([
            "CFBundleIconFiles": .array([.string("selecte_app_icon_blue_raspberry")]),
            "UIPrerenderedIcon": .boolean(false)
          ]),
          // TODO: - Добавить остальные иконки
          
        ])
      ])
    ]
    return InfoPlist.extendingDefault(with: infoPlist)
  }
}
