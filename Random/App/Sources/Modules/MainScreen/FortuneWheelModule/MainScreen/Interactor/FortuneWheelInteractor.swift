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
  
  /// Включить звук
  /// - Parameter isEnabled: Значение
  func setSound(isEnabled: Bool)
  
  /// Включить тактильный отклик
  /// - Parameter isEnabled: Значение
  func setFeedback(isEnabled: Bool)
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Обновить текущую модель
  ///  - Parameter model: Модель данных
  func updateNew(model: FortuneWheelModel)
  
  /// Сохранить результат
  /// - Parameter result: Результат
  func save(result: String)
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
  
  func save(result: String) {
    let model = returnCurrentModel()
    var listResult = model.listResult
    listResult.append(result)
    
    let newModel = FortuneWheelModel(
      result: result,
      listResult: listResult,
      style: model.style,
      sections: model.sections,
      isEnabledSound: model.isEnabledSound,
      isEnabledFeedback: model.isEnabledFeedback
    )
    storageService.fortuneWheelModel = newModel
  }
  
  func updateNew(model: FortuneWheelModel) {
    storageService.fortuneWheelModel = model
    output?.didReceive(model: model)
  }
  
  func setSound(isEnabled: Bool) {
    let model = returnCurrentModel()
    let newModel = FortuneWheelModel(
      result: model.result,
      listResult: model.listResult,
      style: model.style,
      sections: model.sections,
      isEnabledSound: isEnabled,
      isEnabledFeedback: model.isEnabledFeedback
    )
    storageService.fortuneWheelModel = newModel
    output?.didReceive(model: newModel)
  }
  
  func setFeedback(isEnabled: Bool) {
    let model = returnCurrentModel()
    let newModel = FortuneWheelModel(
      result: model.result,
      listResult: model.listResult,
      style: model.style,
      sections: model.sections,
      isEnabledSound: model.isEnabledSound,
      isEnabledFeedback: isEnabled
    )
    storageService.fortuneWheelModel = newModel
    output?.didReceive(model: newModel)
  }
  
  func cleanButtonAction() {
    let model = returnCurrentModel()
    let newModel = FortuneWheelModel(
      result: Appearance().result,
      listResult: [],
      style: model.style,
      sections: model.sections,
      isEnabledSound: model.isEnabledSound,
      isEnabledFeedback: model.isEnabledFeedback
    )
    storageService.fortuneWheelModel = newModel
    output?.didReceive(model: newModel)
    output?.cleanButtonWasSelected()
  }
  
  func getContent() {
    var model = returnCurrentModel()
    
    if model.sections.isEmpty {
      model.sections = getDefaultSection()
    }
    
    if var section = model.sections.filter({ $0.isSelected }).first,
       section.objects.isEmpty {
      section.objects.append(" ")
      let newModel = updateSectionsAndCreateModel(from: model, with: section)
      output?.didReceive(model: newModel)
    } else {
      model.sections = model.sections.enumerated().map { index, value in
        return FortuneWheelModel.Section(
          isSelected: index == .zero ? true : false,
          title: value.title,
          icon: value.icon,
          objects: value.objects
        )
      }
    }
    storageService.fortuneWheelModel = model
    output?.didReceive(model: model)
  }
  
  func returnCurrentModel() -> FortuneWheelModel {
    if let model = storageService.fortuneWheelModel {
      return model
//      return getDefaultFortuneWheelModel()
    } else {
      return getDefaultFortuneWheelModel()
    }
  }
}

// MARK: - Private

private extension FortuneWheelInteractor {
  func updateSectionsAndCreateModel(from model: FortuneWheelModel,
                                    with section: FortuneWheelModel.Section) -> FortuneWheelModel {
    let sections = model.sections.map { $0.id == section.id ? section : $0 }
    
    let updatedModel = FortuneWheelModel(
      result: model.result,
      listResult: model.listResult,
      style: model.style,
      sections: sections,
      isEnabledSound: model.isEnabledSound,
      isEnabledFeedback: model.isEnabledFeedback
    )
    return updatedModel
  }
  
  func getDefaultFortuneWheelModel() -> FortuneWheelModel {
    return FortuneWheelModel(
      result: Appearance().result,
      listResult: [],
      style: .regular,
      sections: getDefaultSection(),
      isEnabledSound: true,
      isEnabledFeedback: true
    )
  }
  
  func getDefaultSection() -> [FortuneWheelModel.Section] {
    return FortuneWheelModel.MockSection.allCases.enumerated().map { index, value in
      return FortuneWheelModel.Section(
        isSelected: index == .zero ? true : false,
        title: value.title,
        icon: value.icon,
        objects: value.objects
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
