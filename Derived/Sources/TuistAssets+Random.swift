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
public enum RandomAsset {
  public static let bottle = RandomImages(name: "Bottle")
  public static let coinEagle = RandomImages(name: "coin_eagle")
  public static let coinTails = RandomImages(name: "coin_tails")
  public static let accentColor = RandomColors(name: "AccentColor")
  public static let launchScreenColorBG = RandomColors(name: "LaunchScreenColorBG")
  public static let primaryColor = RandomColors(name: "PrimaryColor")
  public static let dieFive = RandomImages(name: "die.five")
  public static let dieFour = RandomImages(name: "die.four")
  public static let dieOne = RandomImages(name: "die.one")
  public static let dieSix = RandomImages(name: "die.six")
  public static let dieThree = RandomImages(name: "die.three")
  public static let dieTwo = RandomImages(name: "die.two")
  public static let empty = RandomImages(name: "Empty")
  public static let filmsLoader = RandomData(name: "films_loader")
  public static let playTrailerDisabled = RandomImages(name: "play_trailer_disabled")
  public static let playTrailerEnabled = RandomImages(name: "play_trailer_enabled")
  public static let imageFiltersPlug = RandomImages(name: "image_filters_plug")
  public static let femalePlayer1 = RandomImages(name: "female_player1")
  public static let femalePlayer10 = RandomImages(name: "female_player10")
  public static let femalePlayer11 = RandomImages(name: "female_player11")
  public static let femalePlayer12 = RandomImages(name: "female_player12")
  public static let femalePlayer13 = RandomImages(name: "female_player13")
  public static let femalePlayer14 = RandomImages(name: "female_player14")
  public static let femalePlayer15 = RandomImages(name: "female_player15")
  public static let femalePlayer16 = RandomImages(name: "female_player16")
  public static let femalePlayer17 = RandomImages(name: "female_player17")
  public static let femalePlayer18 = RandomImages(name: "female_player18")
  public static let femalePlayer19 = RandomImages(name: "female_player19")
  public static let femalePlayer2 = RandomImages(name: "female_player2")
  public static let femalePlayer20 = RandomImages(name: "female_player20")
  public static let femalePlayer21 = RandomImages(name: "female_player21")
  public static let femalePlayer3 = RandomImages(name: "female_player3")
  public static let femalePlayer4 = RandomImages(name: "female_player4")
  public static let femalePlayer5 = RandomImages(name: "female_player5")
  public static let femalePlayer6 = RandomImages(name: "female_player6")
  public static let femalePlayer7 = RandomImages(name: "female_player7")
  public static let femalePlayer8 = RandomImages(name: "female_player8")
  public static let femalePlayer9 = RandomImages(name: "female_player9")
  public static let malePlayer1 = RandomImages(name: "male_player1")
  public static let malePlayer10 = RandomImages(name: "male_player10")
  public static let malePlayer11 = RandomImages(name: "male_player11")
  public static let malePlayer12 = RandomImages(name: "male_player12")
  public static let malePlayer13 = RandomImages(name: "male_player13")
  public static let malePlayer14 = RandomImages(name: "male_player14")
  public static let malePlayer15 = RandomImages(name: "male_player15")
  public static let malePlayer2 = RandomImages(name: "male_player2")
  public static let malePlayer3 = RandomImages(name: "male_player3")
  public static let malePlayer4 = RandomImages(name: "male_player4")
  public static let malePlayer5 = RandomImages(name: "male_player5")
  public static let malePlayer6 = RandomImages(name: "male_player6")
  public static let malePlayer7 = RandomImages(name: "male_player7")
  public static let malePlayer8 = RandomImages(name: "male_player8")
  public static let malePlayer9 = RandomImages(name: "male_player9")
  public static let cardPaymentInProcess = RandomData(name: "card_payment_in_process")
  public static let crownIsPremium = RandomImages(name: "crown_is_premium")
  public static let crownNotPremium = RandomImages(name: "crown_not_premium")
  public static let premiumDonate = RandomData(name: "premium_donate")
  public static let premiumFilms = RandomData(name: "premium_films")
  public static let premiumFilters = RandomData(name: "premium_filters")
  public static let premiumIcon = RandomData(name: "premium_icon")
  public static let premiumPlayerCardSelection = RandomData(name: "premium_player_card_selection")
  public static let premiumRockPaperScissos = RandomData(name: "premium_rock_paper_scissos")
  public static let premiumSync = RandomData(name: "premium_sync")
  public static let paperLeft = RandomImages(name: "paper_left")
  public static let paperRight = RandomImages(name: "paper_right")
  public static let rockLeft = RandomImages(name: "rock_left")
  public static let rockPaperScissosCupWinner = RandomData(name: "rock_paper_scissos_cup_winner")
  public static let rockPaperScissosHandShake = RandomData(name: "rock_paper_scissos_hand_shake")
  public static let rockRight = RandomImages(name: "rock_right")
  public static let scissorsLeft = RandomImages(name: "scissors_left")
  public static let scissorsRight = RandomImages(name: "scissors_right")
  public static let selecteAppIconAvocado = RandomImages(name: "selecte_app_icon_avocado")
  public static let selecteAppIconBlueRaspberry = RandomImages(name: "selecte_app_icon_blue_raspberry")
  public static let selecteAppIconCrimsonTide = RandomImages(name: "selecte_app_icon_crimson_tide")
  public static let selecteAppIconDefault = RandomImages(name: "selecte_app_icon_default")
  public static let selecteAppIconEveningNight = RandomImages(name: "selecte_app_icon_evening_night")
  public static let selecteAppIconFrostySky = RandomImages(name: "selecte_app_icon_frosty_sky")
  public static let selecteAppIconGradeGrey = RandomImages(name: "selecte_app_icon_grade_grey")
  public static let selecteAppIconHarvey = RandomImages(name: "selecte_app_icon_harvey")
  public static let selecteAppIconHeliotrope = RandomImages(name: "selecte_app_icon_heliotrope")
  public static let selecteAppIconLithium = RandomImages(name: "selecte_app_icon_lithium")
  public static let selecteAppIconMarineFuchsia = RandomImages(name: "selecte_app_icon_marine_fuchsia")
  public static let selecteAppIconMidnightCity = RandomImages(name: "selecte_app_icon_midnight_city")
  public static let selecteAppIconMoonPurple = RandomImages(name: "selecte_app_icon_moon_purple")
  public static let selecteAppIconMoonlitAsteroid = RandomImages(name: "selecte_app_icon_moonlit_asteroid")
  public static let selecteAppIconOrangeFun = RandomImages(name: "selecte_app_icon_orange_fun")
  public static let selecteAppIconPureLust = RandomImages(name: "selecte_app_icon_pure_lust")
  public static let selecteAppIconQueenNecklace = RandomImages(name: "selecte_app_icon_queen_necklace")
  public static let selecteAppIconRedLime = RandomImages(name: "selecte_app_icon_red_lime")
  public static let selecteAppIconSandyDesert = RandomImages(name: "selecte_app_icon_sandy_desert")
  public static let selecteAppIconSelenium = RandomImages(name: "selecte_app_icon_selenium")
  public static let selecteAppIconSinCityRed = RandomImages(name: "selecte_app_icon_sin_city_red")
  public static let selecteAppIconSummerDog = RandomImages(name: "selecte_app_icon_summer_dog")
  public static let selecteAppIconTerminal = RandomImages(name: "selecte_app_icon_terminal")
  public static let selecteAppIconVioletLemon = RandomImages(name: "selecte_app_icon_violet_lemon")
  public static let icClose = RandomImages(name: "ic_close")
  public static let refresh = RandomImages(name: "refresh")
  public static let appstore = RandomImages(name: "appstore")
  public static let playstore = RandomImages(name: "playstore")
  public static let randomPro = RandomImages(name: "random-pro")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class RandomColors {
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

public extension RandomColors.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: RandomColors) {
    let bundle = RandomResources.bundle
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
  init(asset: RandomColors) {
    let bundle = RandomResources.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

public struct RandomData {
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
  convenience init?(asset: RandomData) {
    let bundle = RandomResources.bundle
    #if os(iOS) || os(tvOS)
    self.init(name: asset.name, bundle: bundle)
    #elseif os(macOS)
    self.init(name: NSDataAsset.Name(asset.name), bundle: bundle)
    #endif
  }
}
#endif

public struct RandomImages {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  public var image: Image {
    let bundle = RandomResources.bundle
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

public extension RandomImages.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the RandomImages.image property")
  convenience init?(asset: RandomImages) {
    #if os(iOS) || os(tvOS)
    let bundle = RandomResources.bundle
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
  init(asset: RandomImages) {
    let bundle = RandomResources.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: RandomImages, label: Text) {
    let bundle = RandomResources.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: RandomImages) {
    let bundle = RandomResources.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:enable all
// swiftformat:enable all
