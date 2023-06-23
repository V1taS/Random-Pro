//
//  FortuneWheelSelectedSectionInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 18.06.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol FortuneWheelSelectedSectionInteractorOutput: AnyObject {
  
  /// Была полученна новая модель данных
  ///  - Parameter model: Модель данных
  func didReceiveNew(model: FortuneWheelModel)
  
  /// Была полученна  модель данных
  ///  - Parameter model: Модель данных
  func didReceive(model: FortuneWheelModel)
}

/// События которые отправляем от Presenter к Interactor
protocol FortuneWheelSelectedSectionInteractorInput {
  
  /// Выбрана секция
  func sectionSelected(_ section: FortuneWheelModel.Section)
  
  /// Удалить секцию
  /// - Parameters:
  ///  - section: Секция
  func deleteSection(_ section: FortuneWheelModel.Section)
  
  /// Обновить модель данных
  ///  - Parameters:
  ///   - model: Модель
  func update(model: FortuneWheelModel?)
  
  /// Получить модель данных
  func returnModel() -> FortuneWheelModel?
}

/// Интерактор
final class FortuneWheelSelectedSectionInteractor: FortuneWheelSelectedSectionInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: FortuneWheelSelectedSectionInteractorOutput?
  
  // MARK: - Private properties
  
  private var cacheModel: FortuneWheelModel?
  
  // MARK: - Internal func
  
  func update(model: FortuneWheelModel?) {
    cacheModel = model
  }
  
  func returnModel() -> FortuneWheelModel? {
    return cacheModel
  }
  
  func deleteSection(_ section: FortuneWheelModel.Section) {
    let sections = cacheModel?.sections.filter { $0.id != section.id } ?? []
    updateModel(with: sections) { [weak self] newModel in
      self?.output?.didReceive(model: newModel)
    }
  }
  
  func sectionSelected(_ section: FortuneWheelModel.Section) {
    let sections = cacheModel?.sections.map {
      FortuneWheelModel.Section(
        isSelected: $0.id == section.id,
        title: $0.title,
        icon: $0.icon,
        objects: $0.objects
      )
    } ?? []
    updateModel(with: sections) { [weak self] newModel in
      self?.output?.didReceiveNew(model: newModel)
    }
  }
}

// MARK: - Private

private extension FortuneWheelSelectedSectionInteractor {
  func updateModel(with sections: [FortuneWheelModel.Section],
                   completion: ((FortuneWheelModel) -> Void)?) {
    guard let cacheModel = cacheModel else {
      return
    }
    let newModel = FortuneWheelModel(
      result: cacheModel.result,
      listResult: cacheModel.listResult,
      style: cacheModel.style,
      sections: sections,
      isEnabledSound: cacheModel.isEnabledSound,
      isEnabledFeedback: cacheModel.isEnabledFeedback
    )
    self.cacheModel = newModel
    completion?(newModel)
  }
}

// MARK: - Appearance

private extension FortuneWheelSelectedSectionInteractor {
  struct Appearance {}
}
