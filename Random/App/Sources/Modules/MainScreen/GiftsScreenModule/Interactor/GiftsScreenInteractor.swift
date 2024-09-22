//
//  GiftsScreenInteractor.swift
//  Random
//
//  Created by Artem Pavlov on 05.06.2023.
//

import Foundation
import FancyNetwork
import FancyUIKit
import FancyStyle

/// События которые отправляем из Interactor в Presenter
protocol GiftsScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameters:
  ///   - text: текст подарка
  ///   - gender: пол подарка
  func didReceive(text: String?, gender: GiftsScreenModel.Gender)
  
  /// Что-то пошло не так
  func somethingWentWrong()
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем от Presenter к Interactor
protocol GiftsScreenInteractorInput {
  
  /// Запросить текущую модель
  func returnCurrentModel() -> GiftsScreenModel
  
  /// Получить данные
  /// - Parameter gender: пол для подарка
  func getContent(gender: GiftsScreenModel.Gender?)
  
  /// Пользователь нажал на кнопку генерации подарка
  func generateButtonAction()
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Пол подарка изменился
  /// - Parameter type: пол подарка
  func segmentedControlValueDidChange(type: GiftsScreenModel.Gender?)
  
  /// Установить новый язык
  func setNewLanguage(language: GiftsScreenModel.Language)
}

/// Интерактор
final class GiftsScreenInteractor: GiftsScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: GiftsScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageService
  private var buttonCounterService: ButtonCounterService
  private var casheGifts: [String] = []
  private var cloudKitService: ICloudKitService
  private var giftsScreenModel: GiftsScreenModel? {
    get {
      storageService.getData(from: GiftsScreenModel.self)
    } set {
      storageService.saveData(newValue)
    }
  }
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
    buttonCounterService = services.buttonCounterService
    cloudKitService = services.cloudKitService
  }
  
  // MARK: - Internal func
  
  func getContent(gender: GiftsScreenModel.Gender?) {
    let newModel = GiftsScreenModel(
      result: Appearance().result,
      listResult: [],
      language: getDefaultLanguage(),
      gender: .male
    )
    let model = giftsScreenModel ?? newModel
    let gender = gender ?? (model.gender ?? .male)
    let language = model.language ?? getDefaultLanguage()
    
    giftsScreenModel = GiftsScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language,
      gender: gender
    )
    
    checkEnvironment(gender: gender,
                     language: language) { [weak self] result in
      switch result {
      case let .success(listGifts):
        self?.casheGifts = listGifts
        self?.output?.didReceive(text: model.result, gender: gender)
      case .failure:
        self?.output?.somethingWentWrong()
      }
    }
  }
  
  func generateButtonAction() {
    guard let model = giftsScreenModel,
          let result = casheGifts.shuffled().first else {
      output?.somethingWentWrong()
      return
    }
    
    var listResult = model.listResult
    listResult.append(result)
    
    giftsScreenModel = GiftsScreenModel(
      result: result,
      listResult: listResult,
      language: model.language,
      gender: model.gender
    )
    output?.didReceive(text: result, gender: model.gender ?? .male)
    buttonCounterService.onButtonClick()
  }
  
  func cleanButtonAction() {
    let newModel = GiftsScreenModel(
      result: Appearance().result,
      listResult: [],
      language: getDefaultLanguage(),
      gender: .male
    )
    self.giftsScreenModel = newModel
    output?.didReceive(text: newModel.result, gender: newModel.gender ?? .male)
    output?.cleanButtonWasSelected()
  }
  
  func segmentedControlValueDidChange(type: GiftsScreenModel.Gender?) {
    getContent(gender: type)
  }
  
  func setNewLanguage(language: GiftsScreenModel.Language) {
    guard let model = giftsScreenModel else {
      output?.somethingWentWrong()
      return
    }
    
    let newModel = GiftsScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language,
      gender: model.gender
    )
    giftsScreenModel = newModel
    getContent(gender: nil)
  }
  
  func returnCurrentModel() -> GiftsScreenModel {
    if let model = giftsScreenModel {
      return model
    } else {
      return GiftsScreenModel(
        result: Appearance().result,
        listResult: [],
        language: getDefaultLanguage(),
        gender: .male
      )
    }
  }
}

// MARK: - Private

private extension GiftsScreenInteractor {
  func fetchListGifts(gender: GiftsScreenModel.Gender,
                      language: GiftsScreenModel.Language,
                      completion: @escaping (Result<[String], Error>) -> Void) {
    switch gender {
    case .male:
      switch language {
      case .en:
        fetchGiftsList(forKey: "GiftIdeasMaleLanguageEN", completion: completion)
      case .ru:
        fetchGiftsList(forKey: "GiftIdeasMaleLanguageRU", completion: completion)
      }
    case .female:
      switch language {
      case .en:
        fetchGiftsList(forKey: "GiftIdeasFemaleLanguageEN", completion: completion)
      case .ru:
        fetchGiftsList(forKey: "GiftIdeasFemaleLanguageRU", completion: completion)
      }
    }
  }
  
  func getDefaultLanguage() -> GiftsScreenModel.Language {
    let language: GiftsScreenModel.Language
    let localeType = CountryType.getCurrentCountryType() ?? .us
    
    switch localeType {
    case .ru:
      language = .ru
    default:
      language = .en
    }
    return language
  }
  
  func checkEnvironment(gender: GiftsScreenModel.Gender,
                        language: GiftsScreenModel.Language,
                        completion: @escaping (Result<[String], Error>) -> Void) {
    fetchListGifts(gender: gender, language: language, completion: completion)
  }
  
  func fetchGiftsList(
    forKey key: String,
    completion: @escaping (Result<[String], Error>) -> Void
  ) {
    DispatchQueue.global().async { [weak self] in
      self?.getConfigurationValue(forKey: key) { (models: [String]?) -> Void in
        DispatchQueue.main.async {
          if let models {
            completion(.success(models))
          } else {
            completion(.failure(NetworkError.mappingError))
          }
        }
      }
    }
  }
  
  func getConfigurationValue<T: Codable>(forKey key: String, completion: ((T?) -> Void)?) {
    let decoder = JSONDecoder()
    
    cloudKitService.getConfigurationValue(
      from: key,
      recordTypes: .giftIdeas
    ) { (result: Result<Data?, Error>) in
      switch result {
      case let .success(jsonData):
        guard let jsonData,
              let models = try? decoder.decode(T.self, from: jsonData) else {
          completion?(nil)
          return
        }
        
        completion?(models)
      case .failure:
        completion?(nil)
      }
    }
  }
}

// MARK: - Appearance

private extension GiftsScreenInteractor {
  struct Appearance {
    let result = "?"
  }
}
