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
    guard let section = cacheCreatedSection, let object else {
      return
    }
    
    var objects = section.objects
    if let index = objects.firstIndex(of: object) {
      objects.remove(at: index)
    }
    cacheCreatedSection?.objects = objects
    
    guard let newSection = cacheCreatedSection else {
      return
    }
    
    var sections = model.sections
    
    let sectionFilter = model.sections.filter { $0.id == section.id }.first
    if let sectionFilter {
      if let index = sections.firstIndex(of: section) {
        sections.remove(at: index)
        sections.insert(section, at: index)
      }
    } else {
      sections.append(section)
    }
    
    let newModel = FortuneWheelModel(
      result: model.result,
      listResult: model.listResult,
      style: model.style,
      sections: sections,
      isEnabledSound: model.isEnabledSound,
      isEnabledFeedback: model.isEnabledFeedback
    )
    output?.didReceiveNew(model: newModel)
  }
  
  func createObject(_ emoticon: Character?,
                    _ titleSection: String?,
                    _ textObject: String?,
                    _ model: FortuneWheelModel) {
    var section: FortuneWheelModel.Section
    if let cacheCreatedSection = cacheCreatedSection {
      section = cacheCreatedSection
      section.icon = String(emoticon ?? "😍")
      section.title = titleSection ?? ""
    } else {
      section = FortuneWheelModel.Section(
        isSelected: false,
        title: titleSection ?? "",
        icon: String(emoticon ?? "😍"),
        objects: []
      )
    }
    section.objects.append(textObject ?? "")
    cacheCreatedSection = section
    
    var sections = model.sections
    
    let sectionFilter = model.sections.filter { $0.id == section.id }.first
    
    if let sectionFilter {
      if let index = sections.firstIndex(of: section) {
        sections.remove(at: index)
        sections.insert(section, at: index)
      }
    } else {
      sections.append(section)
    }
    
    let newModel = FortuneWheelModel(
      result: model.result,
      listResult: model.listResult,
      style: model.style,
      sections: sections,
      isEnabledSound: model.isEnabledSound,
      isEnabledFeedback: model.isEnabledFeedback
    )
    output?.didReceiveNew(model: newModel)
  }
}

// MARK: - Appearance

private extension FortuneWheelEditSectionInteractor {
  struct Appearance {}
}
