//
//  SlogansScreenInteractor.swift
//  Random
//
//  Created by Artem Pavlov on 08.06.2023.
//

import UIKit
import RandomUIKit
import RandomNetwork

/// События которые отправляем из Interactor в Presenter
protocol SlogansScreenInteractorOutput: AnyObject {

  /// Были получены данные
  ///  - Parameter text: Текст со слоганами
  func didReceive(text: String?)

  /// Что-то пошло не так
  func somethingWentWrong()

  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем от Presenter к Interactor
protocol SlogansScreenInteractorInput {

  /// Получить данные
  func getContent()

  /// Пользователь нажал на кнопку
  func generateButtonAction()

  /// Запросить текущую модель
  func returnCurrentModel() -> SlogansScreenModel

  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()

  /// Установить новый язык
  func setNewLanguage(language: SlogansScreenModel.Language)
}

/// Интерактор
final class SlogansScreenInteractor: SlogansScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: SlogansScreenInteractorOutput?

  // MARK: - Private property

  private var storageService: StorageService
  private var networkService: NetworkService
  private let buttonCounterService: ButtonCounterService
  private var casheSlogans: [String] = []

  // MARK: - Initialization

  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
    networkService = services.networkService
    buttonCounterService = services.buttonCounterService
  }
  
  // MARK: - Internal func

  func getContent() {
    let appearance = Appearance()
    let host = appearance.host
    let apiVersion = appearance.apiVersion
    let endPoint = appearance.endPoint

    let newModel = SlogansScreenModel(
      result: Appearance().result,
      listResult: [],
      language: getDefaultLanguage()
    )

    let model = storageService.slogansScreenModel ?? newModel
    let language = model.language ?? getDefaultLanguage()

    storageService.slogansScreenModel = SlogansScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language
    )

    networkService.performRequestWith(
      urlString: host + apiVersion + endPoint,
      queryItems: [
        .init(name: "language", value: "\(language.rawValue)")
      ],
      httpMethod: .get,
      headers: [
        .contentTypeJson,
        .additionalHeaders(set: [
          (key: appearance.apiKey, value: appearance.apiValue)
        ])
      ]) { result in
        DispatchQueue.main.async { [weak self] in
          switch result {
          case let .success(data):
            guard let listSlogans = self?.networkService.map(data, to: [String].self) else {
              self?.output?.somethingWentWrong()
              return
            }
            self?.casheSlogans = listSlogans
            self?.output?.didReceive(text: model.result)
          case .failure:
            self?.output?.somethingWentWrong()
          }
        }
      }
  }

  func generateButtonAction() {
    guard let model = storageService.slogansScreenModel,
          let result = casheSlogans.shuffled().first else {
      output?.somethingWentWrong()
      return
    }

    var listResult = model.listResult
    listResult.append(result)

    storageService.slogansScreenModel = SlogansScreenModel(
      result: result,
      listResult: listResult,
      language: model.language
    )
    output?.didReceive(text: result)
    buttonCounterService.onButtonClick()
  }

  func returnCurrentModel() -> SlogansScreenModel {
    if let model = storageService.slogansScreenModel {
      return model
    } else {
      let appearance = Appearance()
      return SlogansScreenModel(
        result: appearance.result,
        listResult: [],
        language: getDefaultLanguage()
      )
    }
  }

  func cleanButtonAction() {
    let appearance = Appearance()
    let newModel = SlogansScreenModel(result: appearance.result,
                                      listResult: [],
                                      language: getDefaultLanguage())
    self.storageService.slogansScreenModel = newModel
    output?.didReceive(text: newModel.result)
    output?.cleanButtonWasSelected()
  }

  func setNewLanguage(language: SlogansScreenModel.Language) {
    guard let model = storageService.slogansScreenModel else {
      output?.somethingWentWrong()
      return
    }

    let newModel = SlogansScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language
    )
    storageService.slogansScreenModel = newModel
    getContent()
  }
}

// MARK: - Private

private extension SlogansScreenInteractor {
  func getDefaultLanguage() -> SlogansScreenModel.Language {
    let language: SlogansScreenModel.Language
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

private extension SlogansScreenInteractor {
  struct Appearance {
    let result = "?"

    let host = "https://sonorous-seat-386117.ew.r.appspot.com"
    let apiVersion = "/api/v1"
    let endPoint = "/slogans"
    let apiKey = "api_key"
    let apiValue = "4t2AceLVaSW88H8wJ1f6"
  }
}
