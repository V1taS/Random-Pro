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
  
  private var storageService: StorageService
  private var appIconScreenModel: SelecteAppIconScreenModel? {
    get {
      storageService.getData(from: SelecteAppIconScreenModel.self)
    } set {
      storageService.saveData(newValue)
    }
  }
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
  }
  
  // MARK: - Internal properties
  
  weak var output: SelecteAppIconScreenInteractorOutput?
  
  // MARK: - Internal func
  
  func updateAppIcon(type: SelecteAppIconType) {
    let newModel = SelecteAppIconScreenModel(selecteAppIconType: type)
    appIconScreenModel = newModel
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
    output?.didReceive(selecteIconType: appIconScreenModel?.selecteAppIconType ?? .defaultIcon,
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
    let defaultIcon = RandomAsset.selecteAppIconDefault.name
    let blueRaspberryIcon = RandomAsset.selecteAppIconBlueRaspberry.name
    let crimsonTideIcon = RandomAsset.selecteAppIconCrimsonTide.name
    let eveningNightIcon = RandomAsset.selecteAppIconEveningNight.name
    let gradeGreyIcon = RandomAsset.selecteAppIconGradeGrey.name
    let harveyIcon = RandomAsset.selecteAppIconHarvey.name
    let lithiumIcon = RandomAsset.selecteAppIconLithium.name
    let midnightCityIcon = RandomAsset.selecteAppIconMidnightCity.name
    let moonPurpleIcon = RandomAsset.selecteAppIconMoonPurple.name
    let moonlitAsteroidIcon = RandomAsset.selecteAppIconMoonlitAsteroid.name
    let orangeFunIcon = RandomAsset.selecteAppIconOrangeFun.name
    let pureLustIcon = RandomAsset.selecteAppIconPureLust.name
    let seleniumIcon = RandomAsset.selecteAppIconSelenium.name
    let terminalIcon = RandomAsset.selecteAppIconTerminal.name
    let summerDogIcon = RandomAsset.selecteAppIconSummerDog.name
    let sinCityRedIcon = RandomAsset.selecteAppIconSinCityRed.name
    let queensNecklaceIcon = RandomAsset.selecteAppIconQueenNecklace.name
    let marineFuchsiaIcon = RandomAsset.selecteAppIconMarineFuchsia.name
    let sandyDesertIcon = RandomAsset.selecteAppIconSandyDesert.name
    let redLimeIcon = RandomAsset.selecteAppIconRedLime.name
    let heliotropeIcon = RandomAsset.selecteAppIconHeliotrope.name
    let violetLemonIcon = RandomAsset.selecteAppIconVioletLemon.name
    let avocadoIcon = RandomAsset.selecteAppIconAvocado.name
    let frostySkyIcon = RandomAsset.selecteAppIconFrostySky.name
  }
}
