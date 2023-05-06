import ProjectDescription
import Foundation

// MARK: - IOS Widget

public let targetWidgetIOSSettings: Settings = .settings(
  base: [
    "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES": "NO",
    "CLANG_CXX_LANGUAGE_STANDARD": "gnu++14",
    "CLANG_CXX_LIBRARY": "libc++",
    "CLANG_ENABLE_MODULES": "YES",
    "CLANG_ENABLE_OBJC_ARC": "YES",
    "CLANG_ENABLE_OBJC_WEAK": "YES",
    "GCC_C_LANGUAGE_STANDARD": "gnu11",
    "IPHONEOS_DEPLOYMENT_TARGET": "14.0",
    "SDKROOT": "iphoneos",
    "TARGETED_DEVICE_FAMILY": "1,2",
    "DEVELOPMENT_TEAM": "34VDSPZYU9",
    "CODE_SIGN_STYLE": "Manual",
    "CODE_SIGN_IDENTITY": "Apple Distribution: Vitalii Sosin (34VDSPZYU9)",
    "PROVISIONING_PROFILE_SPECIFIER": "dbbda44e-3bbc-4f0b-875b-6af03f52b927",
  ],
  debug: [
    "DEBUG_INFORMATION_FORMAT": "dwarf",
    "ENABLE_TESTABILITY": "YES",
    "GCC_DYNAMIC_NO_PIC": "NO",
    "GCC_OPTIMIZATION_LEVEL": "0",
    "GCC_PREPROCESSOR_DEFINITIONS": "DEBUG=1 $(inherited)",
    "MTL_ENABLE_DEBUG_INFO": "INCLUDE_SOURCE",
    "ONLY_ACTIVE_ARCH": "YES",
    "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG",
    "SWIFT_OPTIMIZATION_LEVEL": "-Onone"
  ],
  release: [
    "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
    "ENABLE_NS_ASSERTIONS": "NO",
    "GCC_OPTIMIZATION_LEVEL": "s",
    "MTL_ENABLE_DEBUG_INFO": "NO",
    "ONLY_ACTIVE_ARCH": "NO",
    "SWIFT_COMPILATION_MODE": "wholemodule",
    "SWIFT_OPTIMIZATION_LEVEL": "-O",
    "VALIDATE_PRODUCT": "YES"
  ]
)
