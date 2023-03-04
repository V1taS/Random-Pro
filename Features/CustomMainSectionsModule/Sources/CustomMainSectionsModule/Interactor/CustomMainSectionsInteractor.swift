//
//  CustomMainSectionsInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol CustomMainSectionsInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter models: результат генерации
  func didReceive(models: [MainScreenSectionProtocol])
  
  /// Данные были изменены
  ///  - Parameter models: результат генерации
  func didChanged(models: [MainScreenSectionProtocol])
  
  /// Получена ошибка
  func didReceiveError()
}

/// События которые отправляем от Presenter к Interactor
protocol CustomMainSectionsInteractorInput {
  
  /// Сформировать контент в табличке
  /// - Parameter models: Моделька секций
  func getContent(models: [MainScreenSectionProtocol])
  
  /// Секция была изменена
  /// - Parameters:
  ///  - isEnabled: Включена секция
  ///  - type: Тип секции
  func sectionChanged(_ isEnabled: Bool, type: MainScreenSectionProtocol)
  
  /// Секция была изменена
  /// - Parameters:
  ///  - index: Место по порядку
  ///  - type: Тип секции
  func sectionChanged(_ index: Int, type: MainScreenSectionProtocol)
}

/// Интерактор
final class CustomMainSectionsInteractor: CustomMainSectionsInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: CustomMainSectionsInteractorOutput?
  
  // MARK: - Private properties
  
  private var models: [MainScreenSectionProtocol] = []
  
  // MARK: - Internal func
  
  func getContent(models: [MainScreenSectionProtocol]) {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      let newModel = models.filter { !$0.isHidden }
      self?.models =  newModel
      
      DispatchQueue.main.async { [weak self] in
        self?.output?.didReceive(models: newModel)
      }
    }
  }
  
  func sectionChanged(_ index: Int, type: MainScreenSectionProtocol) {
    guard !models.isEmpty, let type = type as? CustomMainScreenSectionModel else {
      output?.didReceiveError()
      return
    }
    
    let models = models.toCodable()
    var newModel = models
    
    models.enumerated().forEach { currentIndex, section in
      if section == type {
        newModel.remove(at: currentIndex)
        newModel.insert(CustomMainScreenSectionModel(
          type: (section.type as? CustomMainScreenSectionModel.MainScreenSectionType) ?? .bottle,
          imageSectionSystemName: section.imageSectionSystemName,
          titleSection: section.titleSection,
          isEnabled: section.isEnabled,
          isHidden: section.isHidden,
          advLabel: (section.advLabel as? CustomMainScreenSectionModel.MainScreenADVLabelModel) ?? .none
        ), at: index
        )
      }
    }
    
    self.models = newModel
    output?.didChanged(models: newModel)
  }
  
  func sectionChanged(_ isEnabled: Bool, type: MainScreenSectionProtocol) {
    guard !models.isEmpty, let type = type as? CustomMainScreenSectionModel else {
      output?.didReceiveError()
      return
    }
    
    let models = models.toCodable()
    var newModel = models
    
    models.enumerated().forEach { index, section in
      if section == type {
        newModel.remove(at: index)
        newModel.insert(CustomMainScreenSectionModel(
          type: (section.type as? CustomMainScreenSectionModel.MainScreenSectionType) ?? .bottle,
          imageSectionSystemName: section.imageSectionSystemName,
          titleSection: section.titleSection,
          isEnabled: isEnabled,
          isHidden: section.isHidden,
          advLabel: (section.advLabel as? CustomMainScreenSectionModel.MainScreenADVLabelModel) ?? .none
        ), at: index
        )
      }
    }
    self.models = newModel
    output?.didChanged(models: newModel)
  }
}

// MARK: - Appearance

private extension CustomMainSectionsInteractor {
  struct Appearance {}
}
