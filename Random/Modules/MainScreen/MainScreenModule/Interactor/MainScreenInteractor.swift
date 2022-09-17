//
//  MainScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol MainScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didRecive(model: MainScreenModel)
}

/// События которые отправляем от Presenter к Interactor
protocol MainScreenInteractorInput {
  
  /// Обновить секции главного экрана
  /// - Parameter models: Список секция
  func updateSectionsWith(models: [MainScreenModel.Section])
  
  /// Получаем список ячеек
  func getContent()
  
  /// Возвращает модель
  func returnModel() -> MainScreenModel
  
  /// Сохранить темную тему
  /// - Parameter isEnabled: Темная тема включена
  func saveDarkModeStatus(_ isEnabled: Bool)
}

/// Интерактор
final class MainScreenInteractor: MainScreenInteractorInput {
  
  // MARK: - Private properties
  
  @ObjectCustomUserDefaultsWrapper<MainScreenModel>(key: Appearance().keyUserDefaults)
  private var model: MainScreenModel?
  
  // MARK: - Internal properties
  
  weak var output: MainScreenInteractorOutput?
  
  // MARK: - Internal func
  
  func updateSectionsWith(models: [MainScreenModel.Section]) {
    let models = MainScreenModel.updatesLocalizationTitleSectionForModel(models: models)
    
    if let model = model {
      let newModel = MainScreenModel(
        isDarkMode: model.isDarkMode,
        allSections: models
      )
      self.model = newModel
      output?.didRecive(model: newModel)
    } else {
      let newModel = MainScreenModel(
        isDarkMode: nil,
        allSections: models
      )
      self.model = newModel
      output?.didRecive(model: newModel)
    }
  }
  
  func getContent() {
    if let model = model {
      let newModel = MainScreenModel(
        isDarkMode: model.isDarkMode,
        allSections: MainScreenModel.updatesLocalizationTitleSectionForModel(models: model.allSections)
      )
      self.model = newModel
      output?.didRecive(model: newModel)
    } else {
      let newModel = MainScreenModel.createBaseModel()
      model = newModel
      output?.didRecive(model: newModel)
    }
  }
  
  func returnModel() -> MainScreenModel {
    if let model = model {
      return model
    } else {
      let newModel = MainScreenModel.createBaseModel()
      return newModel
    }
  }
  
  func saveDarkModeStatus(_ isEnabled: Bool) {
    guard let model = model else {
      return
    }
    let newModel = MainScreenModel(
      isDarkMode: isEnabled,
      allSections: model.allSections
    )
    self.model = newModel
  }
}

// MARK: - Private

private extension MainScreenInteractor {}

// MARK: - Appearance

private extension MainScreenInteractor {
  struct Appearance {
    let keyUserDefaults = "main_screen_user_defaults_key"
  }
}
