// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
// Generated using tuist — https://github.com/tuist/tuist

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum SKStyleAsset {
  public static let constantAmberGlow = SKStyleColors(name: "constantAmberGlow")
  public static let constantAzure = SKStyleColors(name: "constantAzure")
  public static let constantGhost = SKStyleColors(name: "constantGhost")
  public static let constantLime = SKStyleColors(name: "constantLime")
  public static let constantNavy = SKStyleColors(name: "constantNavy")
  public static let constantOnyx = SKStyleColors(name: "constantOnyx")
  public static let constantRuby = SKStyleColors(name: "constantRuby")
  public static let constantSlate = SKStyleColors(name: "constantSlate")
  public static let constantSearchCurrency = SKStyleColors(name: "constantSearchCurrency")
  public static let constantLightMistGray = SKStyleColors(name: "constantLightMistGray")
  public static let ghost = SKStyleColors(name: "ghost")
  public static let navy = SKStyleColors(name: "navy")
  public static let onyx = SKStyleColors(name: "onyx")
  public static let componentSlateMessageBG = SKStyleColors(name: "componentSlateMessageBG")
  public static let currencifyLogo = SKStyleAssetData(name: "currencify_logo")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class SKStyleColors {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if canImport(SwiftUI)
  private var _swiftUIColor: Any? = nil
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public private(set) var swiftUIColor: SwiftUI.Color {
    get {
      if self._swiftUIColor == nil {
        self._swiftUIColor = SwiftUI.Color(asset: self)
      }

      return self._swiftUIColor as! SwiftUI.Color
    }
    set {
      self._swiftUIColor = newValue
    }
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension SKStyleColors.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: SKStyleColors) {
    let bundle = Bundle.module
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Color {
  init(asset: SKStyleColors) {
    let bundle = Bundle.module
    self.init(asset.name, bundle: bundle)
  }
}
#endif

public struct SKStyleAssetData {
  public fileprivate(set) var name: String
  
#if os(iOS) || os(tvOS) || os(macOS)
  @available(iOS 9.0, macOS 10.11, *)
  public var data: NSDataAsset {
    guard let data = NSDataAsset(asset: self) else {
      fatalError("Unable to load data asset named \(name).")
    }
    return data
  }
#endif
}

// MARK: - Bundle

public enum SKStyle {
  public static let bundle: Bundle = .module
}

#if os(iOS) || os(tvOS) || os(macOS)
@available(iOS 9.0, macOS 10.11, *)
public extension NSDataAsset {
  convenience init?(asset: SKStyleAssetData) {
    let bundle = Bundle.module
#if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
#elseif os(macOS)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
#endif
  }
}
#endif


// swiftlint:enable all
// swiftformat:enable all
