//
//  StorageService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 09.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

protocol StorageService {
  
  /// Активирован премиум в приложении
  var isPremium: Bool { get }
  
  /// Модель главного экрана
  var mainScreenModel: MainScreenModel? { get set }
  
  /// Модель для чисел
  var numberScreenModel: NumberScreenModel? { get set }
  
  /// Модель для фильмов
  var filmsScreenModel: [FilmsScreenModel]? { get set }
  
  /// Модель для розыгрышей
  var raffleScreenModel: RaffleScreenModel? { get set }
  
  /// Модель для списка
  var listScreenModel: ListScreenModel? { get set }
  
  /// Модель для контактов
  var contactScreenModel: ContactScreenModel? { get set }
  
  /// Модель для кубиков
  var cubesScreenModel: CubesScreenModel? { get set }
  
  /// Модель для команд
  var teamsScreenModel: TeamsScreenModel? { get set }
  
  /// Модель для паролей
  var passwordScreenModel: PasswordScreenModel? { get set }
  
  /// Модель для лотереи
  var lotteryScreenModel: LotteryScreenModel? { get set }
  
  /// Модель для монетки
  var coinScreenModel: CoinScreenModel? { get set }
  
  /// Модель для буквы
  var letterScreenModel: LetterScreenModel? { get set }
  
  /// Модель для даты и времени
  var dateTimeScreenModel: DateTimeScreenModel? { get set }
  
  /// Модель для Да / Нет
  var yesNoScreenModel: YesNoScreenModel? { get set }
  
  /// Модель для выбора иконки
  var appIconScreenModel: SelecteAppIconScreenModel? { get set }
  
  /// Модель для глубоких ссылок
  var deepLinkModel: DeepLinkType? { get set }
  
  /// Модель для метрик
  var dictionaryCountTappedModel: [MetricsSections.RawValue: Int]? { get set }
}

final class StorageServiceImpl: StorageService {
  
  // MARK: - Internal property
  
  var isPremium: Bool {
    return mainScreenModelUserDefaults?.isPremium ?? false
  }
  
  var mainScreenModel: MainScreenModel? {
    get {
      isPremium ? mainScreenModelKeychain : mainScreenModelUserDefaults
    } set {
      mainScreenModelUserDefaults = newValue
      mainScreenModelKeychain = newValue
    }
  }
  
  var numberScreenModel: NumberScreenModel? {
    get {
      isPremium ? numberScreenModelKeychain : numberScreenModelUserDefaults
    } set {
      numberScreenModelUserDefaults = newValue
      numberScreenModelKeychain = newValue
    }
  }
  
  var filmsScreenModel: [FilmsScreenModel]? {
    get {
      isPremium ? filmsScreenModelsKeychain : filmsScreenModelsUserDefaults
    } set {
      filmsScreenModelsUserDefaults = newValue
      filmsScreenModelsKeychain = newValue
    }
  }
  
  var raffleScreenModel: RaffleScreenModel? {
    get {
      isPremium ? raffleScreenModelKeychain : raffleScreenModelUserDefaults
    } set {
      raffleScreenModelUserDefaults = newValue
      raffleScreenModelKeychain = newValue
    }
  }
  
  var listScreenModel: ListScreenModel? {
    get {
      isPremium ? listScreenModelKeychain : listScreenModelUserDefaults
    } set {
      listScreenModelUserDefaults = newValue
      listScreenModelKeychain = newValue
    }
  }
  
  var contactScreenModel: ContactScreenModel? {
    get {
      isPremium ? contactScreenModelKeychain : contactScreenModelUserDefaults
    } set {
      contactScreenModelUserDefaults = newValue
      contactScreenModelKeychain = newValue
    }
  }
  
  var cubesScreenModel: CubesScreenModel? {
    get {
      isPremium ? cubesScreenModelKeychain : cubesScreenModelUserDefaults
    } set {
      cubesScreenModelUserDefaults = newValue
      cubesScreenModelKeychain = newValue
    }
  }
  
  var teamsScreenModel: TeamsScreenModel? {
    get {
      isPremium ? teamsScreenModelKeychain : teamsScreenModelUserDefaults
    } set {
      teamsScreenModelUserDefaults = newValue
      teamsScreenModelKeychain = newValue
    }
  }
  
  var passwordScreenModel: PasswordScreenModel? {
    get {
      isPremium ? passwordScreenModelKeychain : passwordScreenModelUserDefaults
    } set {
      passwordScreenModelUserDefaults = newValue
      passwordScreenModelKeychain = newValue
    }
  }
  
  var lotteryScreenModel: LotteryScreenModel? {
    get {
      isPremium ? lotteryScreenModelKeychain : lotteryScreenModelUserDefaults
    } set {
      lotteryScreenModelUserDefaults = newValue
      lotteryScreenModelKeychain = newValue
    }
  }
  
  var coinScreenModel: CoinScreenModel? {
    get {
      isPremium ? coinScreenModelKeychain : coinScreenModelUserDefaults
    } set {
      coinScreenModelUserDefaults = newValue
      coinScreenModelKeychain = newValue
    }
  }
  
  var letterScreenModel: LetterScreenModel? {
    get {
      isPremium ? letterScreenModelKeychain : letterScreenModelUserDefaults
    } set {
      letterScreenModelUserDefaults = newValue
      letterScreenModelKeychain = newValue
    }
  }
  
  var dateTimeScreenModel: DateTimeScreenModel? {
    get {
      isPremium ? dateTimeScreenModelKeychain : dateTimeScreenModelUserDefaults
    } set {
      dateTimeScreenModelUserDefaults = newValue
      dateTimeScreenModelKeychain = newValue
    }
  }
  
  var yesNoScreenModel: YesNoScreenModel? {
    get {
      isPremium ? yesNoScreenModelKeychain : yesNoScreenModelUserDefaults
    } set {
      yesNoScreenModelUserDefaults = newValue
      yesNoScreenModelKeychain = newValue
    }
  }
  
  var appIconScreenModel: SelecteAppIconScreenModel? {
    get {
      isPremium ? appIconScreenModelKeychain : appIconScreenModelUserDefaults
    } set {
      appIconScreenModelUserDefaults = newValue
      appIconScreenModelKeychain = newValue
    }
  }
  
  var deepLinkModel: DeepLinkType? {
    get {
      deepLinkModelUserDefaults
    } set {
      deepLinkModelUserDefaults = newValue
    }
  }
  
  var dictionaryCountTappedModel: [MetricsSections.RawValue: Int]? {
    get {
      dictionaryCountTappedUserDefaults
    } set {
      dictionaryCountTappedUserDefaults = newValue
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
  
  // MARK: - Raffle model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().raffleScreenModelKeyUserDefaults)
  private var raffleScreenModelUserDefaults: RaffleScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().raffleScreenModelKeyUserDefaults)
  private var raffleScreenModelKeychain: RaffleScreenModel?
  
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
  
  // MARK: - DeepLink model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().deepLinkModelKeyUserDefaults)
  private var deepLinkModelUserDefaults: DeepLinkType?
  
  // MARK: - Metrics sections model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().dictionaryCountTappedKeyUserDefaults)
  private var dictionaryCountTappedUserDefaults: [MetricsSections.RawValue: Int]?
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
    let raffleScreenModelKeyUserDefaults = "raffle_screen_user_defaults_key"
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
  }
}
