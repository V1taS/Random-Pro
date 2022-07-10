//
//  AdminFeatureToggleInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.07.2022.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol AdminFeatureToggleInteractorOutput: AnyObject {
  
  /// Неверный логин или пароль
  func loginOrPasswordFailure()
  
  /// Успешная проверка логина и пароля
  func loginOrPasswordSuccess()
  
  /// Список фича тоглов был получен
  ///  - Parameter toggles: Список фича тоглов
  func didReciveFeature(toggles: [MainScreenCellModel.MainScreenCell])
}

/// События которые отправляем от Presenter к Interactor
protocol AdminFeatureToggleInteractorInput {
  
  /// Проверка логина и пароля
  /// - Parameters:
  ///  - login: Логин админа
  ///  - password: Пароль админа
  func cheak(login: String, password: String)
  
  /// Получить список фича тоглов
  func getFeatureToggles()
}

/// Интерактор
final class AdminFeatureToggleInteractor: AdminFeatureToggleInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: AdminFeatureToggleInteractorOutput?
  
  // MARK: - Internal func
  
  func cheak(login: String, password: String) {
    output?.loginOrPasswordSuccess()
  }
  
  func getFeatureToggles() {
    output?.didReciveFeature(toggles: MainScreenCellModel.MainScreenCell.allCases)
  }
}

// MARK: - Appearance

private extension AdminFeatureToggleInteractor {
  struct Appearance {
    
  }
}
