//
//  TruthOrDareScreenInteractor.swift
//  Random
//
//  Created by Artem Pavlov on 09.06.2023.
//

import UIKit
import RandomNetwork
import RandomUIKit

/// События которые отправляем из Interactor в Presenter
protocol TruthOrDareScreenInteractorOutput: AnyObject {

  /// Были получены данные
  ///  - Parameters:
  ///   - data: данные с правдой или действием
  ///   - type: тип генерации: правда или действие
  func didReceive(data: String?, type: TruthOrDareScreenModel.TruthOrDareType)

  /// Что-то пошло не так
  func somethingWentWrong()

  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем от Presenter к Interactor
protocol TruthOrDareScreenInteractorInput {

  /// Получить данные
  /// - Parameter type: тип генерации: правда или действие
  func getContent(type: TruthOrDareScreenModel.TruthOrDareType?)

  /// Пользователь нажал на кнопку генерации
  func generateButtonAction()

  /// Запросить текущую модель
  func returnCurrentModel() -> TruthOrDareScreenModel

  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()

  /// Пол имени изменился
  /// - Parameter type: тип генерации: правда или действие
  func segmentedControlValueDidChange(type: TruthOrDareScreenModel.TruthOrDareType)

  /// Установить новый язык
  func setNewLanguage(language: TruthOrDareScreenModel.Language)
}

/// Интерактор
final class TruthOrDareScreenInteractor: TruthOrDareScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: TruthOrDareScreenInteractorOutput?

  // MARK: - Private property

  private var storageService: StorageService
  private var networkService: NetworkService
  private var casheTruthOrDare: [String] = []
  private let buttonCounterService: ButtonCounterService

  // MARK: - Initialization

  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
    networkService = services.networkService
    buttonCounterService = services.buttonCounterService
  }

  // MARK: - Internal func

  func getContent(type: TruthOrDareScreenModel.TruthOrDareType?) {
    let newModel = TruthOrDareScreenModel(
      result: Appearance().result,
      listResult: [],
      language: getDefaultLanguage(),
      type: .truth
    )
    let model = storageService.truthOrDareScreenModel ?? newModel
    let typeTruthOrDare = type ?? (model.type ?? .truth)
    let language = model.language ?? getDefaultLanguage()

    storageService.truthOrDareScreenModel = TruthOrDareScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language,
      type: type
    )

    fetchListTruthOrDare(type: type,
                   language: language) { [weak self] result in
      switch result {
      case let .success(listTruthOrDare):
        self?.casheTruthOrDare = listTruthOrDare
        self?.output?.didReceive(data: model.result, type: type)
      case .failure:
        self?.output?.somethingWentWrong()
      }
    }
  }

  func generateButtonAction() {
    guard let model = storageService.truthOrDareScreenModel,
          let result = casheTruthOrDare.shuffled().first else {
      output?.somethingWentWrong()
      return
    }

    var listResult = model.listResult
    listResult.append(result)

    storageService.truthOrDareScreenModel = TruthOrDareScreenModel(
      result: result,
      listResult: listResult,
      language: model.language,
      type: model.type
    )
    output?.didReceive(data: result, type: model.type ?? .truth)
    buttonCounterService.onButtonClick()
  }

  func segmentedControlValueDidChange(type: TruthOrDareScreenModel.TruthOrDareType) {
    getContent(type: type)
  }

  func setNewLanguage(language: TruthOrDarecreenModel.Language) {
    guard let model = storageService.truthOrDareScreenModel else {
      output?.somethingWentWrong()
      return
    }

    let newModel = TruthOrDareScreenModel(
      result: model.result,
      listResult: model.listResult,
      language: language,
      type: model.type
    )
    storageService.truthOrDareScreenModel = newModel
    getContent(type: nil)
  }

}

// MARK: - Appearance

private extension TruthOrDareScreenInteractor {
  struct Appearance {}
}
