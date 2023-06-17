//
//  FortuneWheelInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//

import UIKit
import RandomWheel

/// События которые отправляем из Interactor в Presenter
protocol FortuneWheelInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameters:
  ///   - model: Модель данных
  func didReceive(model: FortuneWheelModel)
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем от Presenter к Interactor
protocol FortuneWheelInteractorInput {
  
  /// Запросить текущую модель
  func returnCurrentModel() -> FortuneWheelModel
  
  /// Получить данные
  func getContent()
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
}

/// Интерактор
final class FortuneWheelInteractor: FortuneWheelInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: FortuneWheelInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageService
  private var buttonCounterService: ButtonCounterService
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
    buttonCounterService = services.buttonCounterService
  }
  
  // MARK: - Internal func
  
  func cleanButtonAction() {
    let model = returnCurrentModel()
    let newModel = FortuneWheelModel(
      result: Appearance().result,
      listResult: [],
      style: model.style,
      sections: model.sections,
      selectedSection: model.selectedSection,
      isEnabledSound: model.isEnabledSound,
      isEnabledFeedback: model.isEnabledFeedback,
      isEnabledListResult: model.isEnabledListResult
    )
    self.storageService.fortuneWheelModel = newModel
    output?.didReceive(model: newModel)
    output?.cleanButtonWasSelected()
  }
  
  func getContent() {
    output?.didReceive(model: returnCurrentModel())
  }
  
  func returnCurrentModel() -> FortuneWheelModel {
    if let model = storageService.fortuneWheelModel {
      return model
    } else {
      return getDefaultFortuneWheelModel()
    }
  }
}

// MARK: - Private

private extension FortuneWheelInteractor {
  func getDefaultFortuneWheelModel() -> FortuneWheelModel {
    return FortuneWheelModel(
      result: Appearance().result,
      listResult: [],
      style: .regular,
      sections: getDefaultSection(),
      selectedSection: getDefaultSection()[0],
      isEnabledSound: true,
      isEnabledFeedback: true,
      isEnabledListResult: true
    )
  }
  
  func getDefaultSection() -> [FortuneWheelModel.Section] {
    return FortuneWheelModel.MockSection.allCases.map {
      return FortuneWheelModel.Section(
        title: $0.title,
        icon: $0.icon,
        objects: $0.objects
      )
    }
  }
}

// MARK: - Appearance

private extension FortuneWheelInteractor {
  struct Appearance {
    let result = "?"
  }
}
