//
//  GiftsScreenInteractor.swift
//  Random
//
//  Created by Artem Pavlov on 05.06.2023.
//

import Foundation
import RandomNetwork
import RandomUIKit

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
  private var networkService: NetworkService
  private var buttonCounterService: ButtonCounterService
  private var casheGifts: [String] = []

  // MARK: - Initialization

  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
    networkService = services.networkService
    buttonCounterService = services.buttonCounterService
  }
  
  // MARK: - Internal func

  func getContent(gender: GiftsScreenModel.Gender?) {
    let newModel = GiftsScreenModel(
      result: Appearance().result,
      listResult: [],
      language: getDefaultLanguage(),
      gender: .male
    )
    let model = storageService.giftsScreenModel ?? newModel
    let gender = gender ?? (model.gender ?? .male)
    let language = model.language ?? getDefaultLanguage()

    storageService.giftsScreenModel = GiftsScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language,
      gender: gender
    )

    fetchListGifts(gender: gender,
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
    guard let model = storageService.giftsScreenModel,
          let result = casheGifts.shuffled().first else {
      output?.somethingWentWrong()
      return
    }

    var listResult = model.listResult
    listResult.append(result)

    storageService.giftsScreenModel = GiftsScreenModel(
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
    self.storageService.giftsScreenModel = newModel
    output?.didReceive(text: newModel.result, gender: newModel.gender ?? .male)
    output?.cleanButtonWasSelected()
  }

  func segmentedControlValueDidChange(type: GiftsScreenModel.Gender?) {
    getContent(gender: type)
  }

  func setNewLanguage(language: GiftsScreenModel.Language) {
    guard let model = storageService.giftsScreenModel else {
      output?.somethingWentWrong()
      return
    }

    let newModel = GiftsScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language,
      gender: model.gender
    )
    storageService.giftsScreenModel = newModel
    getContent(gender: nil)
  }

  func returnCurrentModel() -> GiftsScreenModel {
    if let model = storageService.giftsScreenModel {
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
    let appearance = Appearance()
    let host = appearance.host
    let apiVersion = appearance.apiVersion
    let endPoint = appearance.endPoint

    networkService.performRequestWith(
      urlString: host + apiVersion + endPoint,
      queryItems: [
        .init(name: "gender", value: gender.rawValue),
        .init(name: "language", value: language.rawValue)
      ],
      httpMethod: .get,
      headers: [
        .contentTypeJson,
        .additionalHeaders(set: [
          (key: appearance.apiKey, value: appearance.apiValue)
        ])
      ]
    ) { [weak self] result in
      guard let self else {
        return
      }
      DispatchQueue.main.async {

        switch result {
        case let .success(data):
          guard let listGifts = self.networkService.map(data, to: [String].self) else {
            completion(.failure(NetworkError.mappingError))
            return
          }
          completion(.success(listGifts))
        case let .failure(error):
          completion(.failure(error))
        }
      }
    }
  }

  func getDefaultLanguage() -> GiftsScreenModel.Language {
    let language: GiftsScreenModel.Language
    let localeType = getCurrentLocaleType() ?? .us

    switch localeType {
    case .ru:
      language = .ru
    default:
      language = .en
    }
    return language
  }
}

// MARK: - Appearance

private extension GiftsScreenInteractor {
  struct Appearance {
    let result = "?"
    let host = "https://sonorous-seat-386117.ew.r.appspot.com"
    let apiVersion = "/api/v1"
    let endPoint = "/giftIdeas"
    let apiKey = "api_key"
    let apiValue = "4t2AceLVaSW88H8wJ1f6"
  }
}
