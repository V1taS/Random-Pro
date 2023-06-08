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
  
  /// Модель для никнейм
  var nickNameScreenModel: NickNameScreenModel? { get set }
  
  /// Модель для поздравлений
  var congratulationsScreenModel: CongratulationsScreenModel? { get set }
  
  /// Модель для Загадок
  var riddlesScreenModel: RiddlesScreenModel? { get set }

  /// Модель для Подарков
  var giftsScreenModel: GiftsScreenModel? { get set }
  
  /// Модель для генерации имен
  var namesScreenModel: NamesScreenModel? { get set }
  
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
  
  /// Модель Хорошие дела
  var goodDeedsScreenModel: GoodDeedsScreenModel? { get set }
  
  /// Модель Анекдоты
  var jokeGeneratorScreenModel: JokeGeneratorScreenModel? { get set }

  /// Модель Слонаны
  var slogansScreenModel: SlogansScreenModel? { get set }
  
  /// Модель для выбора иконки
  var appIconScreenModel: SelecteAppIconScreenModel? { get set }
  
  /// Модель для выбора карточки игрока
  var playerCardSelectionScreenModel: [PlayerCardSelectionScreenModel]? { get set }
  
  /// Модель для глубоких ссылок
  var deepLinkModel: MainScreenModel.SectionType? { get set }
  
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
  
  var nickNameScreenModel: NickNameScreenModel? {
    get {
      isPremium ? nickNameScreenModelKeychain : nickNameScreenModelUserDefaults
    } set {
      nickNameScreenModelUserDefaults = newValue
      nickNameScreenModelKeychain = newValue
    }
  }
  
  var congratulationsScreenModel: CongratulationsScreenModel? {
    get {
      isPremium ? congratulationsScreenModelKeychain : congratulationsScreenModelUserDefaults
    } set {
      congratulationsScreenModelUserDefaults = newValue
      congratulationsScreenModelKeychain = newValue
    }
  }

  var giftsScreenModel: GiftsScreenModel? {
    get {
      isPremium ? giftsScreenModelKeychain : giftsScreenModelUserDefaults
    } set {
      giftsScreenModelUserDefaults = newValue
      giftsScreenModelKeychain = newValue
    }
  }
  
  var namesScreenModel: NamesScreenModel? {
    get {
      isPremium ? namesScreenModelKeychain : namesScreenModelUserDefaults
    } set {
      namesScreenModelUserDefaults = newValue
      namesScreenModelKeychain = newValue
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
  
  var riddlesScreenModel: RiddlesScreenModel? {
    get {
      isPremium ? riddlesScreenModelKeychain : riddlesScreenModelUserDefaults
    } set {
      riddlesScreenModelKeychain = newValue
      riddlesScreenModelUserDefaults = newValue
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
  
  var goodDeedsScreenModel: GoodDeedsScreenModel? {
    get {
      isPremium ? goodDeedsScreenModelKeychain : goodDeedsScreenModelUserDefaults
    } set {
      goodDeedsScreenModelUserDefaults = newValue
      goodDeedsScreenModelKeychain = newValue
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
  
  var playerCardSelectionScreenModel: [PlayerCardSelectionScreenModel]? {
    get {
      isPremium ? playerCardSelectionModelKeychain : playerCardSelectionModelUserDefaults
    } set {
      playerCardSelectionModelUserDefaults = newValue
      playerCardSelectionModelKeychain = newValue
    }
  }
  
  var jokeGeneratorScreenModel: JokeGeneratorScreenModel? {
    get {
      isPremium ? jokeScreenModelKeychain : jokeScreenModelUserDefaults
    } set {
      jokeScreenModelUserDefaults = newValue
      jokeScreenModelKeychain = newValue
    }
  }

  var slogansScreenModel: SlogansScreenModel? {
    get {
      isPremium ? slogansScreenModelKeychain : slogansScreenModelUserDefaults
    } set {
      slogansScreenModelUserDefaults = newValue
      slogansScreenModelKeychain = newValue
    }
  }
  
  var deepLinkModel: MainScreenModel.SectionType? {
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

  // MARK: - Slogans model

  @ObjectCustomUserDefaultsWrapper(key: Appearance().slogansScreenKeyUserDefaults)
  private var slogansScreenModelUserDefaults: SlogansScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().slogansScreenKeyUserDefaults)
  private var slogansScreenModelKeychain: SlogansScreenModel?
  
  // MARK: - Joke model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().jokeScreenKeyUserDefaults)
  private var jokeScreenModelUserDefaults: JokeGeneratorScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().jokeScreenKeyUserDefaults)
  private var jokeScreenModelKeychain: JokeGeneratorScreenModel?
  
  // MARK: - Riddles model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().riddlesScreenKeyUserDefaults)
  private var riddlesScreenModelUserDefaults: RiddlesScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().riddlesScreenKeyUserDefaults)
  private var riddlesScreenModelKeychain: RiddlesScreenModel?
  
  // MARK: - Main model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().mainScreenKeyUserDefaults)
  private var mainScreenModelUserDefaults: MainScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().mainScreenKeyUserDefaults)
  private var mainScreenModelKeychain: MainScreenModel?
  
  // MARK: - NickName model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().nickNameScreenKeyUserDefaults)
  private var nickNameScreenModelUserDefaults: NickNameScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().nickNameScreenKeyUserDefaults)
  private var nickNameScreenModelKeychain: NickNameScreenModel?
  
  // MARK: - Names model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().namesScreenKeyUserDefaults)
  private var namesScreenModelUserDefaults: NamesScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().namesScreenKeyUserDefaults)
  private var namesScreenModelKeychain: NamesScreenModel?
  
  // MARK: - Congratulations model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().congratulationsScreenKeyUserDefaults)
  private var congratulationsScreenModelUserDefaults: CongratulationsScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().congratulationsScreenKeyUserDefaults)
  private var congratulationsScreenModelKeychain: CongratulationsScreenModel?

  // MARK: - Gifts model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().giftsScreenKeyUserDefaults)
  private var giftsScreenModelUserDefaults: GiftsScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().giftsScreenKeyUserDefaults)
  private var giftsScreenModelKeychain: GiftsScreenModel?
  
  // MARK: - GoodDeeds model
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().goodDeedsScreenKeyUserDefaults)
  private var goodDeedsScreenModelUserDefaults: GoodDeedsScreenModel?
  @ObjectCustomKeychainWrapper(key: Appearance().goodDeedsScreenKeyUserDefaults)
  private var goodDeedsScreenModelKeychain: GoodDeedsScreenModel?
  
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
  private var deepLinkModelUserDefaults: MainScreenModel.SectionType?
  
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
    let nickNameScreenKeyUserDefaults = "nick_name_screen_user_defaults_key"
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
    let namesScreenKeyUserDefaults = "names_screen_user_defaults_key"
    let congratulationsScreenKeyUserDefaults = "congratulations_screen_user_defaults_key"
    let goodDeedsScreenKeyUserDefaults = "good_deeds_screen_user_defaults_key"
    let riddlesScreenKeyUserDefaults = "riddles_screen_user_defaults_key"
    let jokeScreenKeyUserDefaults = "joke_screen_user_defaults_key"
    let giftsScreenKeyUserDefaults = "gifts_screen_user_defaults_key"
    let slogansScreenKeyUserDefaults = "slogans_screen_user_defaults_key"
  }
}
