//
//  OnboardingScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 17.09.2022.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol OnboardingScreenInteractorOutput: AnyObject {
  
  /// Получено название кнопки
  /// - Parameter title: Название кнопки
  func didReceiveButton(title: String)
  
  /// Получен текущий экран
  /// - Parameter screen: Текущий экран
  func didReceiveCurrent(screen: Int)
  
  /// Получен список экранов
  /// - Parameter screen: Текущий экран
  func didReceiveScreens(_ screens: [OnboardingScreenModel])
  
  /// Закончить онбоардинг
  func onboardingDidFinish()
}

/// События которые отправляем от Presenter к Interactor
protocol OnboardingScreenInteractorInput {
  
  /// Получить контент
  /// - Parameter screens: Список экранов
  func getContent(_ screens: [OnboardingScreenModel])
  
  /// Страница изменена
  /// - Parameter page: Номер страницы
  func changePage(to page: Int)
  
  /// Была нажата кнопка
  /// - Parameter page: Номер страницы
  func didPressButton(to page: Int)
  
  /// Установить текущие страницы как просмотренные
  func viewedPages()
  
  /// Вернуть текущую модель
  static func returnCurrentModels() -> [OnboardingScreenModel]
  
  /// Получить актуальный список экранов
  static func getActualScreens() -> [OnboardingScreenModel]
}

/// Интерактор
final class OnboardingScreenInteractor: OnboardingScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: OnboardingScreenInteractorOutput?
  
  // MARK: - Private property
  
  @ObjectCustomUserDefaultsWrapper<[OnboardingScreenModel]>(key: Appearance().keyUserDefaults)
  static private var models: [OnboardingScreenModel]?
  
  // MARK: - Internal func
  
  static func returnCurrentModels() -> [OnboardingScreenModel] {
    guard let models = OnboardingScreenInteractor.models else {
      return []
    }
    return models
  }
  
  static func getActualScreens() -> [OnboardingScreenModel] {
    let savedScreens = OnboardingScreenInteractor.returnCurrentModels().map {
      return $0.page
    }
    let newScreens = OnboardingScreenFactory.createOnboardingModels()
    var actualScreens: [OnboardingScreenModel] = []
    
    newScreens.forEach {
      if !savedScreens.contains($0.page) {
        actualScreens.append($0)
      }
    }
    return actualScreens
  }
  
  func viewedPages() {
    guard let models = OnboardingScreenInteractor.models else {
      return
    }
    
    let newModel = models.map {
      return OnboardingScreenModel(
        title: $0.title,
        description: $0.description,
        image: $0.image,
        page: $0.page,
        isViewed: true
      )
    }
    OnboardingScreenInteractor.models = newModel
  }
  
  func getContent(_ screens: [OnboardingScreenModel]) {
    let appearance = Appearance()
    
    if let savedScreens = OnboardingScreenInteractor.models {
      var actualScreens = OnboardingScreenInteractor.getActualScreens()
      
      if savedScreens.isEmpty {
        actualScreens = screens
      }
      
      if actualScreens.count > 1 {
        output?.didReceiveButton(title: appearance.continueButtonTitle)
      } else {
        output?.didReceiveButton(title: appearance.onboardingDidFinishTitle)
      }
      
      OnboardingScreenInteractor.models = savedScreens + actualScreens
      output?.didReceiveScreens(actualScreens)
    } else {
      let newScreens = screens.filter { !$0.isViewed }
      
      if newScreens.count > 1 {
        output?.didReceiveButton(title: appearance.continueButtonTitle)
      } else {
        output?.didReceiveButton(title: appearance.onboardingDidFinishTitle)
      }
      
      OnboardingScreenInteractor.models = newScreens
      output?.didReceiveScreens(newScreens)
    }
    output?.didReceiveCurrent(screen: .zero)
  }
  
  func changePage(to page: Int) {
    guard let screens = OnboardingScreenInteractor.models, !screens.isEmpty else {
      return
    }
    
    let appearance = Appearance()
    let newScreens = screens.filter { !$0.isViewed }
    
    if page == newScreens.count - 1 {
      output?.didReceiveButton(title: appearance.onboardingDidFinishTitle)
    } else {
      output?.didReceiveButton(title: appearance.continueButtonTitle)
    }
  }
  
  func didPressButton(to page: Int) {
    guard let screens = OnboardingScreenInteractor.models, !screens.isEmpty else {
      return
    }
    let newScreens = screens.filter { !$0.isViewed }
    
    if page == newScreens.count - 1 {
      viewedPages()
      output?.onboardingDidFinish()
    } else {
      nextPageAction(page: page)
    }
  }
}

// MARK: - Private

private extension OnboardingScreenInteractor {
  func nextPageAction(page: Int) {
    guard
      let screens = OnboardingScreenInteractor.models,
      !screens.filter({ !$0.isViewed }).isEmpty
    else {
      return
    }
    
    output?.didReceiveCurrent(screen: page + 1)
  }
}

// MARK: - Appearance

private extension OnboardingScreenInteractor {
  struct Appearance {
    let keyUserDefaults = "onboarding_screen_user_defaults_key"
    let continueButtonTitle = NSLocalizedString("Продолжить", comment: "")
    let onboardingDidFinishTitle = NSLocalizedString("Завершить", comment: "")
  }
}
