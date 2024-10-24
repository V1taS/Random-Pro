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
  func didReceive(model: MainScreenModel)
}

/// События которые отправляем от Presenter к Interactor
protocol MainScreenInteractorInput {
  
  /// Обновить секции главного экрана
  /// - Parameter model: Модель данных
  func updateSectionsWith(model: MainScreenModel)
  
  /// Получаем список ячеек
  func getContent(completion: @escaping () -> Void)
  
  /// Возвращает модель
  func returnModel(completion: @escaping (MainScreenModel) -> Void)
  
  /// Сохранить темную тему
  /// - Parameter isEnabled: Темная тема включена
  func saveDarkModeStatus(_ isEnabled: Bool?)
  
  /// Сохранить премиум режим
  /// - Parameter isEnabled: Сохранить премиум режим
  func savePremium(_ isEnabled: Bool)
  
  /// Убрать лайбл с секции
  /// - Parameter type: Тип сеции
  func removeLabelFromSection(type: MainScreenModel.SectionType)
  
  /// Добавить лайбл к секции
  /// - Parameters:
  ///  - label: Лайбл
  ///  - for: Тип сеции
  func addLabel(_ label: MainScreenModel.ADVLabel,
                for sectionType: MainScreenModel.SectionType)
}

/// Интерактор
final class MainScreenInteractor: MainScreenInteractorInput {
  
  // MARK: - Private properties
  
  private let services: ApplicationServices
  private var storageService: StorageService
  private var mainScreenModel: MainScreenModel? {
    get {
      storageService.getData(from: MainScreenModel.self)
    } set {
      storageService.saveData(newValue)
    }
  }
  
  // MARK: - Internal properties
  
  weak var output: MainScreenInteractorOutput?
  private let factory: MainScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices,
       factory: MainScreenFactoryInput) {
    self.services = services
    storageService = services.storageService
    self.factory = factory
  }
  
  // MARK: - Internal func
  
  func updateSectionsWith(model: MainScreenModel) {
    factory.updateModelWith(oldModel: model,
                            isPremium: nil) { [weak self] updateModel in
      self?.mainScreenModel = updateModel
      self?.output?.didReceive(model: updateModel)
    }
  }
  
  func getContent(completion: @escaping () -> Void) {
    if let model = mainScreenModel {
      factory.updateModelWith(oldModel: model,
                              isPremium: SecretsAPI.isPremium) { [weak self] newModel in
        self?.mainScreenModel = newModel
        self?.output?.didReceive(model: newModel)
        completion()
      }
    } else {
      factory.createBaseModel { [weak self] newModel in
        var newModel = newModel
        newModel.isPremium = SecretsAPI.isPremium
        self?.mainScreenModel = newModel
        self?.output?.didReceive(model: newModel)
        completion()
      }
    }
  }
  
  func returnModel(completion: @escaping (MainScreenModel) -> Void) {
    if let model = mainScreenModel {
      completion(model)
    } else {
      factory.createBaseModel { newModel in
        completion(newModel)
      }
    }
  }
  
  func saveDarkModeStatus(_ isEnabled: Bool?) {
    guard let model = mainScreenModel else {
      return
    }
    let newModel = MainScreenModel(
      isDarkMode: isEnabled,
      isPremium: model.isPremium,
      allSections: model.allSections
    )
    mainScreenModel = newModel
  }
  
  func savePremium(_ isEnabled: Bool) {
    guard let model = mainScreenModel else {
      return
    }
    let newModel = MainScreenModel(
      isDarkMode: model.isDarkMode,
      isPremium: isEnabled,
      allSections: model.allSections
    )
    mainScreenModel = newModel
    output?.didReceive(model: newModel)
  }
  
  func removeLabelFromSection(type: MainScreenModel.SectionType) {
    guard let model = mainScreenModel,
          let section = model.allSections.filter({ $0.type == type }).first,
          section.advLabel == .new else {
      return
    }
    
    updatesLabelFromSection(type: type,
                            models: model.allSections,
                            advLabel: .none) { [weak self] allSections in
      let newModel = MainScreenModel(
        isDarkMode: model.isDarkMode,
        isPremium: model.isPremium,
        allSections: allSections
      )
      self?.output?.didReceive(model: newModel)
      self?.mainScreenModel = newModel
    }
  }
  
  func addLabel(_ label: MainScreenModel.ADVLabel,
                for sectionType: MainScreenModel.SectionType) {
    guard let model = mainScreenModel else {
      return
    }
    
    updatesLabelFromSection(type: sectionType,
                            models: model.allSections,
                            advLabel: label) { [weak self] allSections in
      let newModel = MainScreenModel(
        isDarkMode: model.isDarkMode,
        isPremium: model.isPremium,
        allSections: allSections
      )
      self?.output?.didReceive(model: newModel)
      self?.mainScreenModel = newModel
    }
  }
}

// MARK: - Private

private extension Date {
  func localUTC() -> Date {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
    let string = dateFormatter.string(from: date)
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    return dateFormatter.date(from: string)!
  }
}

// MARK: - Private

private extension MainScreenInteractor {
  func updatesLabelFromSection(type: MainScreenModel.SectionType,
                               models: [MainScreenModel.Section],
                               advLabel: MainScreenModel.ADVLabel,
                               completion: @escaping ([MainScreenModel.Section]) -> Void) {
    DispatchQueue.global(qos: .userInteractive).async {
      let updatesLabel = models.map {
        if $0.type == type {
          return MainScreenModel.Section(type: $0.type,
                                         isEnabled: $0.isEnabled,
                                         isHidden: $0.isHidden,
                                         isPremium: $0.isPremium,
                                         advLabel: advLabel)
        } else {
          return $0
        }
      }
      DispatchQueue.main.async {
        completion(updatesLabel)
      }
    }
  }
}

// MARK: - Appearance

private extension MainScreenInteractor {
  struct Appearance {
    let isFirstCallReferalPresentationKey = "isAutoShowReferalPresentationAgainCalled"
  }
}
