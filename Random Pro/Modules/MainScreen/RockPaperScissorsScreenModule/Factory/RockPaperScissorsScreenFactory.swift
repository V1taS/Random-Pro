//
//  RockPaperScissorsScreenFactory.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol RockPaperScissorsScreenFactoryOutput: AnyObject {
  
  /// Получен результат генерации модели
  /// - Parameter model: модель с данными
  func didReceiveGenerate(model: RockPaperScissorsScreenModel)
}

/// Cобытия которые отправляем от Presenter к Factory
protocol RockPaperScissorsScreenFactoryInput {
  
  /// Сгенерировать пустую модель
  func generateEmptyModel()
  
  /// Сгенерировать модель RockPaperScissorsScreenModel
  /// - Parameter model: модель с данными
  func generate(model: RockPaperScissorsScreenModel)
}

final class RockPaperScissorsScreenFactory: RockPaperScissorsScreenFactoryInput {
  
  // MARK: - Internal property
  
  weak var output: RockPaperScissorsScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func generateEmptyModel() {
    let appearance = Appearance()
    let model = RockPaperScissorsScreenModel(
      resultTitle: appearance.totalEmptyResult,
      resultType: .initial,
      leftSide: .init(handsType: .rock,
                      score: .zero),
      rightSide: .init(handsType: .rock,
                       score: .zero)
    )
    output?.didReceiveGenerate(model: model)
  }
  
  func generate(model: RockPaperScissorsScreenModel) {
    let newModel = generateScore(model: model)
    output?.didReceiveGenerate(model: newModel)
  }
}

// MARK: - Private

private extension RockPaperScissorsScreenFactory {
  func generateScore(model: RockPaperScissorsScreenModel) -> RockPaperScissorsScreenModel {
    let randomLeftSideList: [RockPaperScissorsScreenModel.HandsType] = [.paper, .rock, .scissors].shuffled()
    let randomLeftSide = randomLeftSideList.first ?? .rock
    let randomRightSideList: [RockPaperScissorsScreenModel.HandsType] = [.paper, .rock, .scissors].shuffled()
    let randomRightSide = randomRightSideList.first ?? .rock
    
    var leftScore = model.leftSide.score
    var rightScore = model.rightSide.score
    var resultType: RockPaperScissorsScreenModel.ResultType = .initial
    
    switch randomLeftSide {
    case .rock:
      switch randomRightSide {
      case .rock:
        resultType = .draw
      case .paper:
        resultType = .winRightSide
        rightScore += 1
      case .scissors:
        resultType = .winLeftSide
        leftScore += 1
      }
    case .paper:
      switch randomRightSide {
      case .rock:
        resultType = .winLeftSide
        leftScore += 1
      case .paper:
        resultType = .draw
      case .scissors:
        resultType = .winRightSide
        rightScore += 1
      }
    case .scissors:
      switch randomRightSide {
      case .rock:
        resultType = .winRightSide
        rightScore += 1
      case .paper:
        resultType = .winLeftSide
        leftScore += 1
      case .scissors:
        resultType = .draw
      }
    }
    
    let totalScore = "\(leftScore) : \(rightScore)"
    let newModel = RockPaperScissorsScreenModel(
      resultTitle: totalScore,
      resultType: resultType,
      leftSide: .init(handsType: randomLeftSide,
                      score: leftScore),
      rightSide: .init(handsType: randomRightSide,
                       score: rightScore)
    )
    return newModel
  }
}

// MARK: - Appearance

private extension RockPaperScissorsScreenFactory {
  struct Appearance {
    let totalEmptyResult = "0 : 0"
    let scoreOne = 1
  }
}
