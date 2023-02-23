//
//  MainScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit
import ApplicationInterface

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
  func saveDarkModeStatus(_ isEnabled: Bool)
  
  /// Убрать лайбл с секции
  /// - Parameter type: Тип сеции
  func removeLabelFromSection(type: MainScreenModel.SectionType)
  
  /// Добавить лайбл к секции
  /// - Parameters:
  ///  - label: Лайбл
  ///  - for: Тип сеции
  func addLabel(_ label: MainScreenModel.ADVLabel,
                for sectionType: MainScreenModel.SectionType)
  
  /// Обновить модель с фича тогглами
  func updatesSectionsIsHiddenFT(completion: @escaping () -> Void)
  
  /// Обновить лайблы у секций на главном экране
  func updatesLabelsFeatureToggle(completion: @escaping () -> Void)
  
  /// Проверка Премиум покупок у пользователя
  func validatePurchase(completion: @escaping () -> Void)
  
  /// Обновить Premium для пользователя у секций на главном экране (Feature Toggle)
  func updatesPremiumFeatureToggle(completion: @escaping () -> Void)
  
  /// Обновить главный экран
  /// - Parameter isPremium: Премиум включен
  func updateMainScreenWith(isPremium: Bool)
}

/// Интерактор
final class MainScreenInteractor: MainScreenInteractorInput {
  
  // MARK: - Private properties
  
  private var storageService: StorageServiceProtocol
  private let featureToggleServices: FeatureToggleServicesProtocol
  private let appPurchasesService: AppPurchasesServiceProtocol
  
  // MARK: - Internal properties
  
  weak var output: MainScreenInteractorOutput?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - featureToggleServices: Сервис фича тогглов
  ///   - storageService: Сервис хранения данных
  ///   - appPurchasesService: Сервис покупок
  init(featureToggleServices: FeatureToggleServicesProtocol,
       storageService: StorageServiceProtocol,
       appPurchasesService: AppPurchasesServiceProtocol) {
    self.featureToggleServices = featureToggleServices
    self.storageService = storageService
    self.appPurchasesService = appPurchasesService
  }
  
  // MARK: - Internal func
  
  func updateMainScreenWith(isPremium: Bool) {
    guard let model = storageService.mainScreenModel?.toCodable() else {
      return
    }
    MainScreenFactory.updateModelWith(oldModel: model,
                                      isPremium: isPremium) { [weak self] newModel in
      self?.storageService.mainScreenModel = newModel
      self?.output?.didReceive(model: newModel)
    }
  }
  
  func updateSectionsWith(model: MainScreenModel) {
    MainScreenFactory.updateModelWith(oldModel: model) { [weak self] updateModel in
      self?.storageService.mainScreenModel = updateModel
      self?.output?.didReceive(model: updateModel)
    }
  }
  
  func getContent(completion: @escaping () -> Void) {
    if let model = storageService.mainScreenModel?.toCodable() {
      MainScreenFactory.updateModelWith(oldModel: model) { [weak self] newModel in
        self?.storageService.mainScreenModel = newModel
        self?.output?.didReceive(model: newModel)
        completion()
      }
    } else {
      MainScreenFactory.createBaseModel { [weak self] newModel in
        self?.storageService.mainScreenModel = newModel
        self?.output?.didReceive(model: newModel)
        completion()
      }
    }
  }
  
  func returnModel(completion: @escaping (MainScreenModel) -> Void) {
    if let model = storageService.mainScreenModel?.toCodable() {
      completion(model)
    } else {
      MainScreenFactory.createBaseModel { newModel in
        completion(newModel)
      }
    }
  }
  
  func saveDarkModeStatus(_ isEnabled: Bool) {
    guard let model = storageService.mainScreenModel else {
      return
    }
    let newModel = MainScreenModel(
      isDarkMode: isEnabled,
      isPremium: model.isPremium,
      allSections: (model.allSections as? [MainScreenModel.Section]) ?? []
    )
    storageService.mainScreenModel = newModel
  }
  
  func removeLabelFromSection(type: MainScreenModel.SectionType) {
    guard let model = storageService.mainScreenModel,
          let allSections = model.allSections as? [MainScreenModel.Section],
          let section = allSections.filter({ $0.type as? MainScreenModel.SectionType == type }).first,
          section.advLabel as? MainScreenModel.ADVLabel == .new else {
      return
    }
    
    updatesLabelFromSection(type: type,
                            models: allSections,
                            advLabel: .none) { [weak self] allSections in
      let newModel = MainScreenModel(
        isDarkMode: model.isDarkMode,
        isPremium: model.isPremium,
        allSections: allSections
      )
      self?.output?.didReceive(model: newModel)
      self?.storageService.mainScreenModel = newModel
    }
  }
  
  func addLabel(_ label: MainScreenModel.ADVLabel,
                for sectionType: MainScreenModel.SectionType) {
    guard let model = storageService.mainScreenModel,
          let allSections = model.allSections as? [MainScreenModel.Section] else {
      return
    }
    
    updatesLabelFromSection(type: sectionType,
                            models: allSections,
                            advLabel: label) { [weak self] allSections in
      let newModel = MainScreenModel(
        isDarkMode: model.isDarkMode,
        isPremium: model.isPremium,
        allSections: allSections
      )
      self?.output?.didReceive(model: newModel)
      self?.storageService.mainScreenModel = newModel
    }
  }
  
  func updatesSectionsIsHiddenFT(completion: @escaping () -> Void) {
    guard let model = storageService.mainScreenModel?.toCodable() else {
      completion()
      return
    }
    
    featureToggleServices.getSectionsIsHiddenFT { [weak self] sectionsIsHiddenFTModel in
      guard let sectionsIsHiddenFTModel else {
        completion()
        return
      }
      
      MainScreenFactory.updateModelWith(oldModel: model,
                                        featureToggleModel: sectionsIsHiddenFTModel) { [weak self] newModel in
        self?.storageService.mainScreenModel = newModel
        self?.output?.didReceive(model: newModel)
        completion()
      }
    }
  }
  
  func updatesLabelsFeatureToggle(completion: @escaping () -> Void) {
    guard let model = storageService.mainScreenModel?.toCodable() else {
      completion()
      return
    }
    
    featureToggleServices.getLabelsFeatureToggle { [weak self] labelsModel in
      guard let labelsModel else {
        completion()
        return
      }
      
      MainScreenFactory.updateModelWith(oldModel: model,
                                        labelsModel: labelsModel) { [weak self] newModel in
        self?.storageService.mainScreenModel = newModel
        self?.output?.didReceive(model: newModel)
        completion()
      }
    }
  }
  
  func updatesPremiumFeatureToggle(completion: @escaping () -> Void) {
    guard let model = storageService.mainScreenModel?.toCodable() else {
      completion()
      return
    }
    
    featureToggleServices.getPremiumFeatureToggle { [weak self] isPremium in
      guard let isPremium else {
        completion()
        return
      }
      
      MainScreenFactory.updateModelWith(oldModel: model,
                                        isPremium: isPremium) { [weak self] newModel in
        self?.storageService.mainScreenModel = newModel
        self?.output?.didReceive(model: newModel)
        completion()
      }
    }
  }
  
  func validatePurchase(completion: @escaping () -> Void) {
    guard let model = storageService.mainScreenModel?.toCodable(),
          let allSections = model.allSections as? [MainScreenModel.Section] else {
      completion()
      return
    }
    
    appPurchasesService.isValidatePurchase { [weak self] isValidate in
      let newModel = MainScreenModel(isDarkMode: model.isDarkMode,
                                     isPremium: isValidate,
                                     allSections: allSections)
      self?.storageService.mainScreenModel = newModel
      self?.output?.didReceive(model: newModel)
      completion()
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
        if $0.type as? MainScreenModel.SectionType == type {
          return MainScreenModel.Section(type: ($0.type as? MainScreenModel.SectionType) ?? .bottle,
                                         imageSectionSystemName: $0.imageSectionSystemName,
                                         titleSection: $0.titleSection,
                                         isEnabled: $0.isEnabled,
                                         isHidden: $0.isHidden,
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
  struct Appearance {}
}
