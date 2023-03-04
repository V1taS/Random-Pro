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
  
  private var storageService: StorageServiceProtocol
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - storageService: Сервис хранения данных
  init(storageService: StorageServiceProtocol) {
    self.storageService = storageService
  }
  
  // MARK: - Internal properties
  
  weak var output: SelecteAppIconScreenInteractorOutput?
  
  // MARK: - Internal func
  
  func updateAppIcon(type: SelecteAppIconType) {
    let newModel = SelecteAppIconScreenModel(selecteAppIconType: type)
    storageService.appIconScreenModel = newModel
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
    case .queensNecklace:
      setIconWith(name: appearance.queensNecklaceIcon)
    case .marineFuchsia:
      setIconWith(name: appearance.marineFuchsiaIcon)
    case .sandyDesert:
      setIconWith(name: appearance.sandyDesertIcon)
    case .redLime:
      setIconWith(name: appearance.redLimeIcon)
    case .heliotrope:
      setIconWith(name: appearance.heliotropeIcon)
    case .violetLemon:
      setIconWith(name: appearance.violetLemonIcon)
    case .avocado:
      setIconWith(name: appearance.avocadoIcon)
    case .frostySky:
      setIconWith(name: appearance.frostySkyIcon)
    }
  }
  
  func returnIsPremium() -> Bool {
    return storageService.isPremium
  }
  
  /// Получить данные
  func getContent() {
    let selecteAppIconType = (storageService.appIconScreenModel?.selecteAppIconType as? SelecteAppIconType) ?? .defaultIcon
    output?.didReceive(selecteIconType: selecteAppIconType,
                       isPremium: storageService.isPremium)
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
    let queensNecklaceIcon = "selecte_app_icon_queen_necklace"
    let marineFuchsiaIcon = "selecte_app_icon_marine_fuchsia"
    let sandyDesertIcon = "selecte_app_icon_sandy_desert"
    let redLimeIcon = "selecte_app_icon_red_lime"
    let heliotropeIcon = "selecte_app_icon_heliotrope"
    let violetLemonIcon = "selecte_app_icon_violet_lemon"
    let avocadoIcon = "selecte_app_icon_avocado"
    let frostySkyIcon = "selecte_app_icon_frosty_sky"
  }
}
