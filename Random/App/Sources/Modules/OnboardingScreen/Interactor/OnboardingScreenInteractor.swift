//
//  OnboardingScreenInteractor.swift
//  Random
//
//  Created by Artem Pavlov on 17.06.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol OnboardingScreenInteractorOutput: AnyObject {

  /// Были получены данные
  ///  - Parameter models: Результат генерации для таблички
  func didReceive()

  /// Что-то пошло не так
  func somethingWentWrong()
}

/// События которые отправляем от Presenter к Interactor
protocol OnboardingScreenInteractorInput {

  /// Получить список онбординг экранов
  func getOnbordingScreens()
}

/// Интерактор
final class OnboardingScreenInteractor: OnboardingScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: OnboardingScreenInteractorOutput?

  // MARK: - Private properties

  //завести в сторадж переменную, если пользователь заходит второй раз, то онбординг не показываем
  private var storageService: StorageService

  // MARK: - Initialization

  /// - Parameters:
  ///  - appPurchasesService: Сервис работы с подписками
  ///  - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
  }
  
  // MARK: - Internal func

  //добавить загрузку из бека, если норм - didReceive(), если нет - somethingWentWrong()
  func getOnbordingScreens() {
    output?.didReceive() //
  }
}

// MARK: - Appearance

private extension OnboardingScreenInteractor {
  struct Appearance {}
}
