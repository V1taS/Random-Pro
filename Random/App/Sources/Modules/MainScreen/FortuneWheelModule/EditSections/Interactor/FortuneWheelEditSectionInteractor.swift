//
//  FortuneWheelEditSectionInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 18.06.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol FortuneWheelEditSectionInteractorOutput: AnyObject {
  
  /// Была полученна новая модель данных
  ///  - Parameter model: Модель данных
  func didReceiveNew(model: FortuneWheelModel)
  
  /// Была полученна  модель данных
  ///  - Parameter model: Модель данных
  func didReceive(model: FortuneWheelModel)
}

/// События которые отправляем от Presenter к Interactor
protocol FortuneWheelEditSectionInteractorInput {
  
  /// Создать секцию
  /// - Parameters:
  ///  - emoticon: Смайлик
  ///  - titleSection: Название секции
  ///  - textSection: Название объекта
  ///  - model: Модель данных
  func createObject(_ emoticon: Character?,
                    _ titleSection: String?,
                    _ textObject: String?,
                    _ model: FortuneWheelModel)
  
  /// Удалить объект
  /// - Parameters:
  ///  - object: Объект (текст)
  ///  - model: Модель данных
  func deleteObject(_ object: String?, _ model: FortuneWheelModel)
  
  /// Редактируем текущую секцию
  ///  - Parameters:
  ///   - section: Секция
  func editCurrentSection(_ section: FortuneWheelModel.Section, _ model: FortuneWheelModel)
}

/// Интерактор
final class FortuneWheelEditSectionInteractor: FortuneWheelEditSectionInteractorInput {
  
  // MARK: - Private properties
  
  private var cacheCreatedSection: FortuneWheelModel.Section?
  
  // MARK: - Internal properties
  
  weak var output: FortuneWheelEditSectionInteractorOutput?
  
  // MARK: - Internal func
  
  func editCurrentSection(_ section: FortuneWheelModel.Section, _ model: FortuneWheelModel) {
    cacheCreatedSection = section
    output?.didReceive(model: model)
  }
  
  func deleteObject(_ object: String?, _ model: FortuneWheelModel) {
    guard let object = object,
          var section = cacheCreatedSection,
          let objectIndex = section.objects.firstIndex(of: object)
    else {
      return
    }
    
    section.objects.remove(at: objectIndex)
    cacheCreatedSection = section
    let updatedModel = updateSectionsAndCreateModel(from: model, with: section)
    
    output?.didReceiveNew(model: updatedModel)
  }
  
  func createObject(_ emoticon: Character?,
                    _ titleSection: String?,
                    _ textObject: String?,
                    _ model: FortuneWheelModel) {
    let newEmoticon = emoticon ?? "😍"
    let newTitle = titleSection ?? ""
    let newText = textObject ?? ""
    
    var section: FortuneWheelModel.Section
    
    if let cachedSection = cacheCreatedSection {
      section = cachedSection
      section.icon = String(newEmoticon)
      section.title = newTitle
    } else {
      section = FortuneWheelModel.Section(
        isSelected: false,
        title: newTitle,
        icon: String(newEmoticon),
        objects: []
      )
    }
    
    section.objects.append(newText)
    cacheCreatedSection = section
    
    let updatedModel = updateSectionsAndCreateModel(from: model, with: section)
    output?.didReceiveNew(model: updatedModel)
  }
}

// MARK: - Private

private extension FortuneWheelEditSectionInteractor {
  func updateSectionsAndCreateModel(from model: FortuneWheelModel,
                                    with section: FortuneWheelModel.Section) -> FortuneWheelModel {
    let sections = model.sections.map { $0.id == section.id ? section : $0 }
    
    let updatedModel = FortuneWheelModel(
      result: model.result,
      listResult: model.listResult,
      style: model.style,
      sections: sections,
      isEnabledSound: model.isEnabledSound,
      isEnabledFeedback: model.isEnabledFeedback
    )
    return updatedModel
  }
}

// MARK: - Appearance

private extension FortuneWheelEditSectionInteractor {
  struct Appearance {}
}
