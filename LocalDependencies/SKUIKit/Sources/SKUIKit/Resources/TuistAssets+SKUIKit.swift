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
public enum SKUIKitAsset {
  public static let loaderCircle = SKUIKitData(name: "loader_circle")
  public static let loaderFlipCoin = SKUIKitData(name: "loader_flip_coin")
  public static let loaderScaner = SKUIKitData(name: "loader_scaner")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public struct SKUIKitData {
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

#if os(iOS) || os(tvOS) || os(macOS)
@available(iOS 9.0, macOS 10.11, *)
public extension NSDataAsset {
  convenience init?(asset: SKUIKitData) {
    let bundle = Bundle.module
#if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
#elseif os(macOS)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
#endif
  }
}
#endif

public struct SKUIKitImages {
  public fileprivate(set) var name: String
  
#if os(macOS)
  public typealias Image = NSImage
#elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
#endif
  
  public var image: Image {
    let bundle = Bundle.module
#if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
#elseif os(macOS)
    let image = bundle.image(forResource: NSImage.Name(name))
#elseif os(watchOS)
    let image = Image(named: name)
#endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  
#if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
#endif
}

public extension SKUIKitImages.Image {
  @available(macOS, deprecated,
             message: "This initializer is unsafe on macOS, please use the SKUIKitImages.image property")
  convenience init?(asset: SKUIKitImages) {
#if os(iOS) || os(tvOS)
    let bundle = Bundle.module
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
#elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
#elseif os(watchOS)
    self.init(named: asset.name)
#endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Image {
  init(asset: SKUIKitImages) {
    let bundle = Bundle.module
    self.init(asset.name, bundle: bundle)
  }
  
  init(asset: SKUIKitImages, label: Text) {
    let bundle = Bundle.module
    self.init(asset.name, bundle: bundle, label: label)
  }
  
  init(decorative asset: SKUIKitImages) {
    let bundle = Bundle.module
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:enable all
// swiftformat:enable all
