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
  func didReceive(models: [MainScreenModel.Section])
  
  /// Данные были изменены
  ///  - Parameter models: результат генерации
  func didChanged(models: [MainScreenModel.Section])
  
  /// Получена ошибка
  func didReceiveError()
}

/// События которые отправляем от Presenter к Interactor
protocol CustomMainSectionsInteractorInput {
  
  /// Сформировать контент в табличке
  /// - Parameter models: Моделька секций
  func getContent(models: [MainScreenModel.Section])
  
  /// Секция была изменена
  /// - Parameters:
  ///  - isEnabled: Включена секция
  ///  - type: Тип секции
  func sectionChanged(_ isEnabled: Bool, type: MainScreenModel.Section)
  
  /// Секция была изменена
  /// - Parameters:
  ///  - index: Место по порядку
  ///  - type: Тип секции
  func sectionChanged(_ index: Int, type: MainScreenModel.Section)
}

/// Интерактор
final class CustomMainSectionsInteractor: CustomMainSectionsInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: CustomMainSectionsInteractorOutput?
  
  // MARK: - Private properties
  
  private var models: [MainScreenModel.Section] = []
  
  // MARK: - Internal func
  
  func getContent(models: [MainScreenModel.Section]) {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      let newModel = models.filter { !$0.isHidden }
      self?.models =  newModel
      
      DispatchQueue.main.async { [weak self] in
        self?.output?.didReceive(models: newModel)
      }
    }
  }
  
  func sectionChanged(_ index: Int, type: MainScreenModel.Section) {
    guard !models.isEmpty else {
      output?.didReceiveError()
      return
    }
    
    var newModel: [MainScreenModel.Section] = models
    models.enumerated().forEach { currentIndex, section in
      if section == type {
        newModel.remove(at: currentIndex)
        newModel.insert(MainScreenModel.Section(
          type: section.type,
          isEnabled: section.isEnabled,
          isHidden: section.isHidden,
          isPremium: section.isPremium,
          advLabel: section.advLabel
        ), at: index
        )
      }
    }
    
    models = newModel
    output?.didChanged(models: newModel)
  }
  
  func sectionChanged(_ isEnabled: Bool, type: MainScreenModel.Section) {
    guard !models.isEmpty else {
      output?.didReceiveError()
      return
    }
    
    var newModel: [MainScreenModel.Section] = models
    
    models.enumerated().forEach { index, section in
      if section == type {
        newModel.remove(at: index)
        newModel.insert(MainScreenModel.Section(
          type: section.type,
          isEnabled: isEnabled,
          isHidden: section.isHidden,
          isPremium: section.isPremium,
          advLabel: section.advLabel
        ), at: index
        )
      }
    }
    models = newModel
    output?.didChanged(models: newModel)
  }
}

// MARK: - Appearance

private extension CustomMainSectionsInteractor {
  struct Appearance {}
}
