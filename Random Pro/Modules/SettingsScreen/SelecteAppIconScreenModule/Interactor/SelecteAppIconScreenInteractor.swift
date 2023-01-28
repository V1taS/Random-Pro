//
//  SelecteAppIconScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 25.01.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol SelecteAppIconScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameters:
  ///   - selecteIconType: Тип изображения
  ///   - isPremium: Премиум активирован
  func didReceive(selecteIconType: SelecteAppIconType, isPremium: Bool)
  
  /// Икнока успешно выбрана
  func iconSelectedSuccessfully()
  
  /// Что-то пошло не так
  func somethingWentWrong()
}

/// События которые отправляем от Presenter к Interactor
protocol SelecteAppIconScreenInteractorInput {
  
  /// Получить данные
  func getContent()
  
  /// Возвращает статус премиум
  func returnIsPremium() -> Bool
  
  /// Обновить иконку у приложения
  /// - Parameter type: Тип иконки
  func updateAppIcon(type: SelecteAppIconType)
}

/// Интерактор
final class SelecteAppIconScreenInteractor: SelecteAppIconScreenInteractorInput {
  
  // MARK: - Private properties
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().keyUserDefaults)
  private var model: SelecteAppIconScreenModel?
  private var isPremium: Bool {
    @ObjectCustomUserDefaultsWrapper(key: Appearance().mainScreenModelKeyUserDefaults)
    var mainScreenModel: MainScreenModel?
    guard let mainScreenModel else {
      return false
    }
    return mainScreenModel.isPremium
  }
  
  // MARK: - Internal properties
  
  weak var output: SelecteAppIconScreenInteractorOutput?
  
  // MARK: - Internal func
  
  func updateAppIcon(type: SelecteAppIconType) {
    let newModel = SelecteAppIconScreenModel(selecteAppIconType: type)
    self.model = newModel
    let appearance = Appearance()
    guard UIApplication.shared.supportsAlternateIcons else {
      output?.somethingWentWrong()
      return
    }
    
    switch type {
    case .defaultIcon:
      setIconWith(name: nil)
    case .crimsonTide:
      setIconWith(name: appearance.crimsonTideIcon)
    case .lithium:
      setIconWith(name: appearance.lithiumIcon)
    case .orangeFun:
      setIconWith(name: appearance.orangeFunIcon)
    case .midnightCity:
      setIconWith(name: appearance.midnightCityIcon)
    case .terminal:
      setIconWith(name: appearance.terminalIcon)
    case .harvey:
      setIconWith(name: appearance.harveyIcon)
    case .moonlitAsteroid:
      setIconWith(name: appearance.moonlitAsteroidIcon)
    case .gradeGrey:
      setIconWith(name: appearance.gradeGreyIcon)
    case .summerDog:
      setIconWith(name: appearance.summerDogIcon)
    case .sinCityRed:
      setIconWith(name: appearance.sinCityRedIcon)
    case .blueRaspberry:
      setIconWith(name: appearance.blueRaspberryIcon)
    case .eveningNight:
      setIconWith(name: appearance.eveningNightIcon)
    case .pureLust:
      setIconWith(name: appearance.pureLustIcon)
    case .moonPurple:
      setIconWith(name: appearance.moonPurpleIcon)
    case .selenium:
      setIconWith(name: appearance.seleniumIcon)
    }
  }
  
  func returnIsPremium() -> Bool {
    return isPremium
  }
  
  /// Получить данные
  func getContent() {
    if let model {
      output?.didReceive(selecteIconType: model.selecteAppIconType, isPremium: isPremium)
    } else {
      let newModel = SelecteAppIconScreenModel(selecteAppIconType: .defaultIcon)
      self.model = newModel
      output?.didReceive(selecteIconType: newModel.selecteAppIconType, isPremium: isPremium)
    }
  }
}

// MARK: - Private

private extension SelecteAppIconScreenInteractor {
  func setIconWith(name: String?) {
    UIApplication.shared.setAlternateIconName(name) { [weak self] error in
      if error != nil {
        self?.output?.somethingWentWrong()
      } else {
        self?.output?.iconSelectedSuccessfully()
      }
    }
  }
}

// MARK: - Appearance

private extension SelecteAppIconScreenInteractor {
  struct Appearance {
    let keyUserDefaults = "selecte_app_icon_screen_user_defaults_key"
    let mainScreenModelKeyUserDefaults = "main_screen_user_defaults_key"
    
    let defaultIcon = "selecte_app_icon_default"
    let blueRaspberryIcon = "selecte_app_icon_blue_raspberry"
    let crimsonTideIcon = "selecte_app_icon_crimson_tide"
    let eveningNightIcon = "selecte_app_icon_evening_night"
    let gradeGreyIcon = "selecte_app_icon_grade_grey"
    let harveyIcon = "selecte_app_icon_harvey"
    let lithiumIcon = "selecte_app_icon_lithium"
    let midnightCityIcon = "selecte_app_icon_midnight_city"
    let moonPurpleIcon = "selecte_app_icon_moon_purple"
    let moonlitAsteroidIcon = "selecte_app_icon_moonlit_asteroid"
    let orangeFunIcon = "selecte_app_icon_orange_fun"
    let pureLustIcon = "selecte_app_icon_pure_lust"
    let seleniumIcon = "selecte_app_icon_selenium"
    let terminalIcon = "selecte_app_icon_terminal"
    let summerDogIcon = "selecte_app_icon_summer_dog"
    let sinCityRedIcon = "selecte_app_icon_sin_city_red"
  }
}
