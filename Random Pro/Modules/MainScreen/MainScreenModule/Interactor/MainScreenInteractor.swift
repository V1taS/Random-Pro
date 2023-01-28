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
}

/// Интерактор
final class MainScreenInteractor: MainScreenInteractorInput {
  
  // MARK: - Private properties
  
  @ObjectCustomUserDefaultsWrapper(key: Appearance().keyUserDefaults)
  private var model: MainScreenModel?
  private let services: ApplicationServices
  
  // MARK: - Internal properties
  
  weak var output: MainScreenInteractorOutput?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    self.services = services
  }
  
  // MARK: - Internal func
  
  func updateSectionsWith(model: MainScreenModel) {
    MainScreenFactory.updateModelWith(oldModel: model) { [weak self] updateModel in
      self?.model = updateModel
      self?.output?.didReceive(model: updateModel)
    }
  }
  
  func getContent(completion: @escaping () -> Void) {
    if let model = model {
      MainScreenFactory.updateModelWith(oldModel: model) { [weak self] newModel in
        self?.model = newModel
        self?.output?.didReceive(model: newModel)
        completion()
      }
    } else {
      MainScreenFactory.createBaseModel { [weak self] newModel in
        self?.model = newModel
        self?.output?.didReceive(model: newModel)
        completion()
      }
    }
  }
  
  func returnModel(completion: @escaping (MainScreenModel) -> Void) {
    if let model = model {
      completion(model)
    } else {
      MainScreenFactory.createBaseModel { newModel in
        completion(newModel)
      }
    }
  }
  
  func saveDarkModeStatus(_ isEnabled: Bool) {
    guard let model = model else {
      return
    }
    let newModel = MainScreenModel(
      isDarkMode: isEnabled,
      isPremium: model.isPremium,
      allSections: model.allSections
    )
    self.model = newModel
  }
  
  func removeLabelFromSection(type: MainScreenModel.SectionType) {
    guard let model = model,
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
      self?.model = newModel
    }
  }
  
  func addLabel(_ label: MainScreenModel.ADVLabel,
                for sectionType: MainScreenModel.SectionType) {
    guard let model = model else {
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
      self?.model = newModel
    }
  }
  
  func updatesSectionsIsHiddenFT(completion: @escaping () -> Void) {
    guard let model = model else {
      completion()
      return
    }
    
    services.featureToggleServices.getSectionsIsHiddenFT { [weak self] sectionsIsHiddenFTModel in
      guard let sectionsIsHiddenFTModel else {
        completion()
        return
      }
      
      MainScreenFactory.updateModelWith(oldModel: model,
                                        featureToggleModel: sectionsIsHiddenFTModel) { [weak self] newModel in
        self?.model = newModel
        self?.output?.didReceive(model: newModel)
        completion()
      }
    }
  }
  
  func updatesLabelsFeatureToggle(completion: @escaping () -> Void) {
    guard let model = model else {
      completion()
      return
    }
    
    services.featureToggleServices.getLabelsFeatureToggle { [weak self] labelsModel in
      guard let labelsModel else {
        completion()
        return
      }
      
      MainScreenFactory.updateModelWith(oldModel: model,
                                        labelsModel: labelsModel) { [weak self] newModel in
        self?.model = newModel
        self?.output?.didReceive(model: newModel)
        completion()
      }
    }
  }
  
  func updatesPremiumFeatureToggle(completion: @escaping () -> Void) {
    guard let model = model else {
      completion()
      return
    }
    
    services.featureToggleServices.getPremiumFeatureToggle { [weak self] isPremium in
      guard let isPremium else {
        completion()
        return
      }
      
      MainScreenFactory.updateModelWith(oldModel: model,
                                        isPremium: isPremium) { [weak self] newModel in
        self?.model = newModel
        self?.output?.didReceive(model: newModel)
        completion()
      }
    }
  }
  
  func validatePurchase(completion: @escaping () -> Void) {
    guard let model = model else {
      completion()
      return
    }
    
    services.appPurchasesService.isValidatePurchase { [weak self] isValidate in
      let newModel = MainScreenModel(isDarkMode: model.isDarkMode,
                                     isPremium: isValidate,
                                     allSections: model.allSections)
      self?.model = newModel
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
        if $0.type == type {
          return MainScreenModel.Section(type: $0.type,
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
  struct Appearance {
    let keyUserDefaults = "main_screen_user_defaults_key"
  }
}
