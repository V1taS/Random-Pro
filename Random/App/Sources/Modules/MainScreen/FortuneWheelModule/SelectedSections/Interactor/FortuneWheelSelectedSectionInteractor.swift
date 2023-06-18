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
}

/// События которые отправляем от Presenter к Interactor
protocol FortuneWheelSelectedSectionInteractorInput {
  
  /// Выбрана секция
  func sectionSelected(_ section: FortuneWheelModel.Section, model: FortuneWheelModel)
}

/// Интерактор
final class FortuneWheelSelectedSectionInteractor: FortuneWheelSelectedSectionInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: FortuneWheelSelectedSectionInteractorOutput?
  
  // MARK: - Internal func
  
  func sectionSelected(_ section: FortuneWheelModel.Section, model: FortuneWheelModel) {
    let sections = model.sections.map {
      return FortuneWheelModel.Section(
        isSelected: $0.id == section.id,
        title: $0.title,
        icon: $0.icon,
        objects: $0.objects
      )
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

private extension FortuneWheelSelectedSectionInteractor {
  struct Appearance {}
}
