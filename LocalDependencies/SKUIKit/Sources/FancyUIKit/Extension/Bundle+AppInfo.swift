//
//  File.swift
//  
//
//  Created by SOSIN Vitaly on 09.01.2023.
//

import Foundation

public extension Bundle {
  var appName: String {
    getInfo("CFBundleName")
  }
  var displayName: String {
    getInfo("CFBundleDisplayName")
  }
  var language: String {
    getInfo("CFBundleDevelopmentRegion")
  }
  var identifier: String {
    getInfo("CFBundleIdentifier")
  }
  var copyright: String {
    getInfo("NSHumanReadableCopyright").replacingOccurrences(of: "\\\\n", with: "\n")
  }
  var appBuild: String {
    getInfo("CFBundleVersion")
  }
  var appVersionLong: String {
    getInfo("CFBundleShortVersionString")
  }
  var appVersionShort: String {
    getInfo("CFBundleShortVersion")
  }

  private func getInfo(_ str: String) -> String { infoDictionary?[str] as? String ?? "" }
}
