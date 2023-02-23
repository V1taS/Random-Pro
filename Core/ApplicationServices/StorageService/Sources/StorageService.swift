//
//  StorageService.swift
//  StorageService
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

public final class StorageServiceImpl: StorageServiceProtocol {
  
  // MARK: - Init
  
  public init() {}
  
  // MARK: - Public property
  
  public var isPremium: Bool {
    return mainScreenModelUserDefaults?.isPremium ?? false
  }
  
  public var mainScreenModel: MainScreenModelProtocol? {
    get {
      isPremium ? mainScreenModelKeychain : mainScreenModelUserDefaults
    } set {
      mainScreenModelUserDefaults = newValue?.toCodable()
      mainScreenModelKeychain = newValue?.toCodable()
    }
  }
  
  public var numberScreenModel: NumberScreenModelProtocol? {
    get {
      isPremium ? numberScreenModelKeychain : numberScreenModelUserDefaults
    } set {
      numberScreenModelUserDefaults = newValue?.toCodable()
      numberScreenModelKeychain = newValue?.toCodable()
    }
  }
  
  public var filmsScreenModel: [FilmsScreenModelProtocol]? {
    get {
      isPremium ? filmsScreenModelsKeychain : filmsScreenModelsUserDefaults
    } set {
      filmsScreenModelsUserDefaults = newValue?.toCodable()
      filmsScreenModelsKeychain = newValue?.toCodable()
    }
  }
  
  public var listScreenModel: ListScreenModelProtocol? {
    get {
      isPremium ? listScreenModelKeychain : listScreenModelUserDefaults
    } set {
      listScreenModelUserDefaults = newValue?.toCodable()
      listScreenModelKeychain = newValue?.toCodable()
    }
  }
  
  public var contactScreenModel: ContactScreenModelProtocol? {
    get {
      isPremium ? contactScreenModelKeychain : contactScreenModelUserDefaults
    } set {
      contactScreenModelUserDefaults = newValue?.toCodable()
      contactScreenModelKeychain = newValue?.toCodable()
    }
  }
  
  public var cubesScreenModel: CubesScreenModelProtocol? {
    get {
      isPremium ? cubesScreenModelKeychain : cubesScreenModelUserDefaults
    } set {
      cubesScreenModelUserDefaults = newValue?.toCodable()
      cubesScreenModelKeychain = newValue?.toCodable()
    }
  }
  
  public var teamsScreenModel: TeamsScreenModelProtocol? {
    get {
      isPremium ? teamsScreenModelKeychain : teamsScreenModelUserDefaults
    } set {
      teamsScreenModelUserDefaults = newValue?.toCodable()
      teamsScreenModelKeychain = newValue?.toCodable()
    }
  }
  
  public var passwordScreenModel: PasswordScreenModelProtocol? {
    get {
      isPremium ? passwordScreenModelKeychain : passwordScreenModelUserDefaults
    } set {
      passwordScreenModelUserDefaults = newValue?.toCodable()
      passwordScreenModelKeychain = newValue?.toCodable()
    }
  }
  
  public var lotteryScreenModel: LotteryScreenModelProtocol? {
    get {
      isPremium ? lotteryScreenModelKeychain : lotteryScreenModelUserDefaults
    } set {
      lotteryScreenModelUserDefaults = newValue?.toCodable()
      lotteryScreenModelKeychain = newValue?.toCodable()
    }
  }
  
  public var coinScreenModel: CoinScreenModelProtocol? {
    get {
      isPremium ? coinScreenModelKeychain : coinScreenModelUserDefaults
    } set {
      coinScreenModelUserDefaults = newValue?.toCodable()
      coinScreenModelKeychain = newValue?.toCodable()
    }
  }
  
  public var letterScreenModel: LetterScreenModelProtocol? {
    get {
      isPremium ? letterScreenModelKeychain : letterScreenModelUserDefaults
    } set {
      letterScreenModelUserDefaults = newValue?.toCodable()
      letterScreenModelKeychain = newValue?.toCodable()
    }
  }
  
  public var dateTimeScreenModel: DateTimeScreenModelProtocol? {
    get {
      isPremium ? dateTimeScreenModelKeychain : dateTimeScreenModelUserDefaults
    } set {
      dateTimeScreenModelUserDefaults = newValue?.toCodable()
      dateTimeScreenModelKeychain = newValue?.toCodable()
    }
  }
  
  public var yesNoScreenModel: YesNoScreenModelProtocol? {
    get {
      isPremium ? yesNoScreenModelKeychain : yesNoScreenModelUserDefaults
    } set {
      yesNoScreenModelUserDefaults = newValue?.toCodable()
      yesNoScreenModelKeychain = newValue?.toCodable()
    }
  }
  
  public var appIconScreenModel: SelecteAppIconScreenModelProtocol? {
    get {
      isPremium ? appIconScreenModelKeychain : appIconScreenModelUserDefaults
    } set {
      appIconScreenModelUserDefaults = newValue?.toCodable()
      appIconScreenModelKeychain = newValue?.toCodable()
    }
  }
  
  public var playerCardSelectionScreenModel: [PlayerCardSelectionScreenModelProtocol]? {
    get {
      isPremium ? playerCardSelectionModelKeychain : playerCardSelectionModelUserDefaults
    } set {
      playerCardSelectionModelUserDefaults = newValue?.toCodable()
      playerCardSelectionModelKeychain = newValue?.toCodable()
    }
  }
  
  public var deepLinkModel: DeepLinkTypeProtocol? {
    get {
      deepLinkModelUserDefaults
    } set {
      deepLinkModelUserDefaults = newValue?.toCodable()
    }
  }
  
  // MARK: - Private property
  
  // MARK: - Main model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().mainScreenKeyUserDefaults)
  private var mainScreenModelUserDefaults: MainScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().mainScreenKeyUserDefaults)
  private var mainScreenModelKeychain: MainScreenModel?
  
  // MARK: - Number model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().numberScreenKeyUserDefaults)
  private var numberScreenModelUserDefaults: NumberScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().numberScreenKeyUserDefaults)
  private var numberScreenModelKeychain: NumberScreenModel?
  
  // MARK: - Films model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().filmsScreenModelsKeyUserDefaults)
  private var filmsScreenModelsUserDefaults: [FilmsScreenModel]?
  @ObjectCustomKeychainWrapper(key: Appearance().filmsScreenModelsKeyUserDefaults)
  private var filmsScreenModelsKeychain: [FilmsScreenModel]?
  
  // MARK: - List model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().listScreenModelKeyUserDefaults)
  private var listScreenModelUserDefaults: ListScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().listScreenModelKeyUserDefaults)
  private var listScreenModelKeychain: ListScreenModel?
  
  // MARK: - Contact model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().contactScreenModelKeyUserDefaults)
  private var contactScreenModelUserDefaults: ContactScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().contactScreenModelKeyUserDefaults)
  private var contactScreenModelKeychain: ContactScreenModel?
  
  // MARK: - Cubes model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().cubesScreenModelKeyUserDefaults)
  private var cubesScreenModelUserDefaults: CubesScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().cubesScreenModelKeyUserDefaults)
  private var cubesScreenModelKeychain: CubesScreenModel?
  
  // MARK: - Teams model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().teamsScreenModelKeyUserDefaults)
  private var teamsScreenModelUserDefaults: TeamsScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().teamsScreenModelKeyUserDefaults)
  private var teamsScreenModelKeychain: TeamsScreenModel?
  
  // MARK: - Password model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().passwordScreenModelKeyUserDefaults)
  private var passwordScreenModelUserDefaults: PasswordScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().passwordScreenModelKeyUserDefaults)
  private var passwordScreenModelKeychain: PasswordScreenModel?
  
  // MARK: - Lottery model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().lotteryScreenModelKeyUserDefaults)
  private var lotteryScreenModelUserDefaults: LotteryScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().lotteryScreenModelKeyUserDefaults)
  private var lotteryScreenModelKeychain: LotteryScreenModel?
  
  // MARK: - Coin model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().coinScreenModelKeyUserDefaults)
  private var coinScreenModelUserDefaults: CoinScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().coinScreenModelKeyUserDefaults)
  private var coinScreenModelKeychain: CoinScreenModel?
  
  // MARK: - Letter model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().letterScreenModelKeyUserDefaults)
  private var letterScreenModelUserDefaults: LetterScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().letterScreenModelKeyUserDefaults)
  private var letterScreenModelKeychain: LetterScreenModel?
  
  // MARK: - Date time model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().dateTimeScreenModelKeyUserDefaults)
  private var dateTimeScreenModelUserDefaults: DateTimeScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().dateTimeScreenModelKeyUserDefaults)
  private var dateTimeScreenModelKeychain: DateTimeScreenModel?
  
  // MARK: - Yes/No model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().yesNoScreenModelKeyUserDefaults)
  private var yesNoScreenModelUserDefaults: YesNoScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().yesNoScreenModelKeyUserDefaults)
  private var yesNoScreenModelKeychain: YesNoScreenModel?
  
  // MARK: - Selecte app icon model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().appIconScreenModelKeyUserDefaults)
  private var appIconScreenModelUserDefaults: SelecteAppIconScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().appIconScreenModelKeyUserDefaults)
  private var appIconScreenModelKeychain: SelecteAppIconScreenModel?
  
  // MARK: - Player card selection model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().playerCardSelectionModelKeyUserDefaults)
  private var playerCardSelectionModelUserDefaults: [PlayerCardSelectionScreenModel]?
  @ObjectCustomKeychainWrapper(key: Appearance().playerCardSelectionModelKeyUserDefaults)
  private var playerCardSelectionModelKeychain: [PlayerCardSelectionScreenModel]?
  
  // MARK: - DeepLink model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().deepLinkModelKeyUserDefaults)
  private var deepLinkModelUserDefaults: DeepLinkType?
}

// MARK: - Private

private extension StorageServiceImpl {
  
}

// MARK: - Appearance

private extension StorageServiceImpl {
  struct Appearance {
    let mainScreenKeyUserDefaults = "main_screen_user_defaults_key"
    let numberScreenKeyUserDefaults = "number_screen_user_defaults_key"
    let filmsScreenModelsKeyUserDefaults = "films_screen_user_defaults_key"
    let listScreenModelKeyUserDefaults = "list_screen_user_defaults_key"
    let contactScreenModelKeyUserDefaults = "contact_screen_user_defaults_key"
    let cubesScreenModelKeyUserDefaults = "cubes_screen_user_defaults_key"
    let teamsScreenModelKeyUserDefaults = "team_screen_user_defaults_key"
    let passwordScreenModelKeyUserDefaults = "password_screen_user_defaults_key"
    let lotteryScreenModelKeyUserDefaults = "lottery_screen_user_defaults_key"
    let coinScreenModelKeyUserDefaults = "coin_screen_user_defaults_key"
    let letterScreenModelKeyUserDefaults = "letter_screen_user_defaults_key"
    let dateTimeScreenModelKeyUserDefaults = "date_time_screen_user_defaults_key"
    let yesNoScreenModelKeyUserDefaults = "yes_no_screen_user_defaults_key"
    let appIconScreenModelKeyUserDefaults = "selecte_app_icon_screen_user_defaults_key"
    let deepLinkModelKeyUserDefaults = "deep_link_user_defaults_key"
    let dictionaryCountTappedKeyUserDefaults = "metrics_service_user_defaults_key"
    let playerCardSelectionModelKeyUserDefaults = "player_card_selection_screen_user_defaults_key"
  }
}
