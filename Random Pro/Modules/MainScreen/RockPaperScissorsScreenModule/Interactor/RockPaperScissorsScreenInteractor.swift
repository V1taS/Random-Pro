//
//  RockPaperScissorsScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol RockPaperScissorsScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameters:
  ///   - displayingGenerationResultOnLeft: отображение результата генерации слева
  ///   - displayingGenerationResultOnRight: отображение результата генерации справа
  func didReceive(displayingGenerationResultOnLeft: RockPaperScissorsScreenModel,
                  displayingGenerationResultOnRight: RockPaperScissorsScreenModel)
}

/// События которые отправляем от Presenter к Interactor
protocol RockPaperScissorsScreenInteractorInput {
  
  /// Получить данные
  func getContent()
}

final class RockPaperScissorsScreenInteractor: RockPaperScissorsScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: RockPaperScissorsScreenInteractorOutput?

  // MARK: - Internal func
  
  func getContent() {
    output?.didReceive(displayingGenerationResultOnLeft: getLeftSideModel(),
                       displayingGenerationResultOnRight: getRightSideModel())
  }
}

// MARK: - Private

private extension RockPaperScissorsScreenInteractor {
  
  func getLeftSideModel() -> RockPaperScissorsScreenModel {
    RockPaperScissorsScreenModel.allCases.shuffled().first ?? .paper
  }
  
  func getRightSideModel() -> RockPaperScissorsScreenModel {
    RockPaperScissorsScreenModel.allCases.shuffled().first ?? .scissors
  }
}
