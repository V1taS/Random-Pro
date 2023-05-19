//
//  MainSettingsScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol MainSettingsScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didReceive(model: MainSettingsScreenModel)
}

/// События которые отправляем от Presenter к Interactor
protocol MainSettingsScreenInteractorInput {
  
  /// Получить данные
  ///  - Parameter isDarkMode: Включить темную тему
  func getContentWith(isDarkMode: Bool?)
  
  /// Тема приложения была изменена
  /// - Parameter isEnabled: Темная тема включена
  func darkThemeChanged(_ isEnabled: Bool?)
}

/// Интерактор
final class MainSettingsScreenInteractor: MainSettingsScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: MainSettingsScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var model: MainSettingsScreenModel?
  
  // MARK: - Internal func
  
  func darkThemeChanged(_ isEnabled: Bool?) {
    let newModel = MainSettingsScreenModel(isDarkMode: isEnabled)
    model = newModel
  }
  
  func getContentWith(isDarkMode: Bool?) {
    if let model = model {
      output?.didReceive(model: model)
    } else {
      let newModel = MainSettingsScreenModel(isDarkMode: isDarkMode)
      output?.didReceive(model: newModel)
    }
  }
}

// MARK: - Appearance

private extension MainSettingsScreenInteractor {
  struct Appearance {}
}
