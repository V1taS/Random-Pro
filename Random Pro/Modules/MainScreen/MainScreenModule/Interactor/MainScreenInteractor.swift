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
  /// - Parameter models: Список секция
  func updateSectionsWith(models: [MainScreenModel.Section])
  
  /// Получаем список ячеек
  func getContent()
  
  /// Возвращает модель
  func returnModel() -> MainScreenModel
  
  /// Сохранить темную тему
  /// - Parameter isEnabled: Темная тема включена
  func saveDarkModeStatus(_ isEnabled: Bool)
}

/// Интерактор
final class MainScreenInteractor: MainScreenInteractorInput {
  
  // MARK: - Private properties
  
  @ObjectCustomUserDefaultsWrapper<MainScreenModel>(key: Appearance().keyUserDefaults)
  private var model: MainScreenModel?
  
  // MARK: - Internal properties
  
  weak var output: MainScreenInteractorOutput?
  
  // MARK: - Internal func
  
  func updateSectionsWith(models: [MainScreenModel.Section]) {
    let models = updatesLocalizationTitleSectionForModel(models: models)
    
    if let model = model {
      let newModel = MainScreenModel(
        isDarkMode: model.isDarkMode,
        allSections: models
      )
      self.model = newModel
      output?.didReceive(model: newModel)
    } else {
      let newModel = MainScreenModel(
        isDarkMode: nil,
        allSections: models
      )
      self.model = newModel
      output?.didReceive(model: newModel)
    }
  }
  
  func getContent() {
    if let model = model {
      let newModel = MainScreenModel(
        isDarkMode: model.isDarkMode,
        allSections: updatesLocalizationTitleSectionForModel(models: model.allSections)
      )
      self.model = newModel
      output?.didReceive(model: newModel)
    } else {
      let newModel = createBaseModel()
      model = newModel
      output?.didReceive(model: newModel)
    }
  }
  
  func returnModel() -> MainScreenModel {
    if let model = model {
      return model
    } else {
      let newModel = createBaseModel()
      return newModel
    }
  }
  
  func saveDarkModeStatus(_ isEnabled: Bool) {
    guard let model = model else {
      return
    }
    let newModel = MainScreenModel(
      isDarkMode: isEnabled,
      allSections: model.allSections
    )
    self.model = newModel
  }
}

// MARK: - Private

private extension MainScreenInteractor {
  func updatesNewSectionForModel(
    models: [MainScreenModel.Section]
  ) -> [MainScreenModel.Section] {
    let allSections = createBaseModel().allSections
    var newModel = models
    
    for section in allSections {
      let oldSections = models.filter { $0.type == section.type }
      if oldSections.isEmpty {
        newModel.append(section)
      }
    }
    return newModel
  }
  
  func updatesLocalizationTitleSectionForModel(
    models: [MainScreenModel.Section]
  ) -> [MainScreenModel.Section] {
    let appearance = Appearance()
    var newModel: [MainScreenModel.Section] = []
    
    updatesNewSectionForModel(models: models).forEach { model in
      switch model.type {
      case .teams:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          titleSection: appearance.titleCardTeam,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .number:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          titleSection: appearance.titleCardNumber,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .yesOrNo:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          titleSection: appearance.titleCardYesOrNot,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .letter:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          titleSection: appearance.titleCardCharacters,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .list:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          titleSection: appearance.titleCardList,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .coin:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          titleSection: appearance.titleCardCoin,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .cube:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          titleSection: appearance.titleCardCube,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .dateAndTime:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          titleSection: appearance.titleCardDateAndTime,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .lottery:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          titleSection: appearance.titleCardLottery,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .contact:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          titleSection: appearance.titleCardContact,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .password:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          titleSection: appearance.titleCardPassword,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      case .colors:
        newModel.append(MainScreenModel.Section(
          type: model.type,
          isEnabled: model.isEnabled,
          titleSection: appearance.titleColors,
          imageSection: model.imageSection,
          advLabel: model.advLabel
        ))
      }
    }
    
    return newModel
  }
  
  func createBaseModel() -> MainScreenModel {
    let appearance = Appearance()
    var allSections: [MainScreenModel.Section] = []
    
    MainScreenModel.SectionType.allCases.forEach { section in
      switch section {
      case .teams:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardTeam,
          imageSection: appearance.imageCardTeam.pngData() ?? Data(),
          advLabel: .none
        ))
      case .number:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardNumber,
          imageSection: appearance.imageCardNumber.pngData() ?? Data(),
          advLabel: .none
        ))
      case .yesOrNo:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardYesOrNot,
          imageSection: appearance.imageCardYesOrNot.pngData() ?? Data(),
          advLabel: .none
        ))
      case .letter:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardCharacters,
          imageSection: appearance.imageCardCharacters.pngData() ?? Data(),
          advLabel: .none
        ))
      case .list:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardList,
          imageSection: appearance.imageCardList.pngData() ?? Data(),
          advLabel: .none
        ))
      case .coin:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardCoin,
          imageSection: appearance.imageCardCoin.pngData() ?? Data(),
          advLabel: .none
        ))
      case .cube:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardCube,
          imageSection: appearance.imageCardCube.pngData() ?? Data(),
          advLabel: .none
        ))
      case .dateAndTime:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardDateAndTime,
          imageSection: appearance.imageCardDateAndTime.pngData() ?? Data(),
          advLabel: .none
        ))
      case .lottery:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardLottery,
          imageSection: appearance.imageCardLottery.pngData() ?? Data(),
          advLabel: .none
        ))
      case .contact:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardContact,
          imageSection: appearance.imageCardContact.pngData() ?? Data(),
          advLabel: .none
        ))
      case .password:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleCardPassword,
          imageSection: appearance.imageCardPassword.pngData() ?? Data(),
          advLabel: .none
        ))
      case .colors:
        allSections.append(MainScreenModel.Section(
          type: section,
          isEnabled: true,
          titleSection: appearance.titleColors,
          imageSection: appearance.imageColors.pngData() ?? Data(),
          advLabel: .none
        ))
      }
    }
    return MainScreenModel(isDarkMode: nil,
                           allSections: allSections)
  }
}

// MARK: - Appearance

private extension MainScreenInteractor {
  struct Appearance {
    let keyUserDefaults = "main_screen_user_defaults_key"
    
    let imageCardFilms = UIImage(systemName: "film") ?? UIImage()
    let titleCardFilms = NSLocalizedString("Фильмы", comment: "")
    
    let imageCardTeam = UIImage(systemName: "person.circle") ?? UIImage()
    let titleCardTeam = NSLocalizedString("Команды", comment: "")
    
    let imageCardNumber = UIImage(systemName: "number") ?? UIImage()
    let titleCardNumber = NSLocalizedString("Число", comment: "")
    
    let imageCardYesOrNot = UIImage(systemName: "questionmark.square") ?? UIImage()
    let titleCardYesOrNot = NSLocalizedString("Да или Нет", comment: "")
    
    let imageCardCharacters = UIImage(systemName: "textbox") ?? UIImage()
    let titleCardCharacters = NSLocalizedString("Буква", comment: "")
    
    let imageCardList = UIImage(systemName: "list.bullet.below.rectangle") ?? UIImage()
    let titleCardList = NSLocalizedString("Список", comment: "")
    
    let imageCardCoin = UIImage(systemName: "bitcoinsign.circle") ?? UIImage()
    let titleCardCoin = NSLocalizedString("Монета", comment: "")
    
    let imageCardCube = UIImage(systemName: "cube") ?? UIImage()
    let titleCardCube = NSLocalizedString("Кубики", comment: "")
    
    let imageCardDateAndTime = UIImage(systemName: "calendar") ?? UIImage()
    let titleCardDateAndTime = NSLocalizedString("Дата и время", comment: "")
    
    let imageCardLottery = UIImage(systemName: "tag") ?? UIImage()
    let titleCardLottery = NSLocalizedString("Лотерея", comment: "")
    
    let imageCardContact = UIImage(systemName: "phone.circle") ?? UIImage()
    let titleCardContact = NSLocalizedString("Контакт", comment: "")
    
    let imageCardPassword = UIImage(systemName: "wand.and.stars") ?? UIImage()
    let titleCardPassword = NSLocalizedString("Пароли", comment: "")
    
    let imageColors = UIImage(systemName: "photo.on.rectangle.angled") ?? UIImage()
    let titleColors = NSLocalizedString("Цвета", comment: "")
  }
}
