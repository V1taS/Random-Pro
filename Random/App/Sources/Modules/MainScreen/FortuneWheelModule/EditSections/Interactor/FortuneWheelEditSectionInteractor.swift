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
  
  /// Удалить все объекты
  func removeAllObjects()
  
  /// Смайлик в заголовка был изменен
  /// - Parameters:
  ///  - emoticon: Смайлик
  func editEmoticon(_ emoticon: Character?)
  
  /// Заголовок был изменен
  /// - Parameters:
  ///  - title: Заголовок
  ///  - model: Модель данных
  func editSection(title: String?)
  
  /// Создать секцию
  /// - Parameters:
  ///  - emoticon: Смайлик
  ///  - titleSection: Название секции
  ///  - textSection: Название объекта
  func createObject(_ emoticon: Character?,
                    _ titleSection: String?,
                    _ textObject: String?)
  
  /// Удалить объект
  /// - Parameters:
  ///  - object: Объект (текст)
  ///  - model: Модель данных
  func deleteObject(_ object: String?)
  
  /// Редактируем текущую секцию
  ///  - Parameters:
  ///   - section: Секция
  func editCurrentSection(_ section: FortuneWheelModel.Section, _ model: FortuneWheelModel)
  
  /// Обновить модель данных и секцию
  ///  - Parameters:
  ///   - model: Модель
  ///   - section: Секция
  func update(model: FortuneWheelModel?, section: FortuneWheelModel.Section?)
  
  /// Получить текущую секцию
  func returnSection() -> FortuneWheelModel.Section?
}

/// Интерактор
final class FortuneWheelEditSectionInteractor: FortuneWheelEditSectionInteractorInput {
  
  // MARK: - Private properties
  
  private var cacheModel: FortuneWheelModel?
  private var cacheCreatedSection: FortuneWheelModel.Section?
  
  // MARK: - Internal properties
  
  weak var output: FortuneWheelEditSectionInteractorOutput?
  
  // MARK: - Internal func
  
  func returnSection() -> FortuneWheelModel.Section? {
    return cacheCreatedSection
  }
  
  func update(model: FortuneWheelModel?, section: FortuneWheelModel.Section?) {
    cacheModel = model
    cacheCreatedSection = section
  }
  
  func removeAllObjects() {
    guard var section = cacheCreatedSection,
          let cacheModel else {
      return
    }
    
    section.objects = []
    cacheCreatedSection = section
    output?.didReceive(model: updateSectionsAndCreateModel(from: cacheModel, with: section))
  }
  
  func editSection(title: String?) {
    guard var section = cacheCreatedSection,
          let cacheModel else {
      return
    }
    
    section.title = title ?? "-"
    cacheCreatedSection = section
    output?.didReceiveNew(model: updateSectionsAndCreateModel(from: cacheModel, with: section))
  }
  
  func editEmoticon(_ emoticon: Character?) {
    guard let newEmoticon = emoticon,
          var section = cacheCreatedSection,
          let cacheModel else {
      return
    }
    
    section.icon = String(newEmoticon)
    cacheCreatedSection = section
    output?.didReceiveNew(model: updateSectionsAndCreateModel(from: cacheModel, with: section))
  }
  
  func editCurrentSection(_ section: FortuneWheelModel.Section, _ model: FortuneWheelModel) {
    cacheCreatedSection = section
    cacheModel = model
    output?.didReceive(model: model)
  }
  
  func deleteObject(_ object: String?) {
    guard let object = object,
          var section = cacheCreatedSection,
          let objectIndex = section.objects.firstIndex(of: object),
          let cacheModel else {
      return
    }
    
    section.objects.remove(at: objectIndex)
    cacheCreatedSection = section
    let updatedModel = updateSectionsAndCreateModel(from: cacheModel, with: section)
    
    output?.didReceive(model: updatedModel)
  }
  
  func createObject(_ emoticon: Character?,
                    _ titleSection: String?,
                    _ textObject: String?) {
    guard let cacheModel else {
      return
    }
    
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
    
    let updatedModel = updateSectionsAndCreateModel(from: cacheModel, with: section)
    output?.didReceive(model: updatedModel)
  }
}

// MARK: - Private

private extension FortuneWheelEditSectionInteractor {
  func updateSectionsAndCreateModel(from model: FortuneWheelModel,
                                    with section: FortuneWheelModel.Section) -> FortuneWheelModel {
    var sections = model.sections
    
    if let index = sections.firstIndex(where: { $0.id == section.id }) {
      sections[index] = section
    } else {
      sections.append(section)
    }
    
    let updatedModel = FortuneWheelModel(
      result: model.result,
      listResult: model.listResult,
      style: model.style,
      sections: sections,
      isEnabledFeedback: model.isEnabledFeedback
    )
    self.cacheModel = updatedModel
    return updatedModel
  }
}

// MARK: - Appearance

private extension FortuneWheelEditSectionInteractor {
  struct Appearance {}
}
