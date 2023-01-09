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
    let model = RockPaperScissorsScreenModel(leftSideScreen: .rock(appearance.rockLeftImage?.pngData()),
                                             leftSideScore: .zero,
                                             rightSideScreen: .rock(appearance.rockRightImage?.pngData()),
                                             rightSideScore: .zero,
                                             result: appearance.totalEmptyResult)
    output?.didReceiveGenerate(model: model)
  }
  
  func generate(model: RockPaperScissorsScreenModel) {
    let appearance = Appearance()
    let randomLeftSideList: [RockPaperScissorsScreenModel.HandsType] = [
      .paper(appearance.paperLeftImage?.pngData()),
      .rock(appearance.rockLeftImage?.pngData()),
      .scissors(appearance.scissorsLeftImage?.pngData())
    ].shuffled()
    let randomLeftSide = randomLeftSideList.first ?? .scissors(nil)
    
    let randomRightSideList: [RockPaperScissorsScreenModel.HandsType] = [
      .paper(appearance.paperRightImage?.pngData()),
      .rock(appearance.rockRightImage?.pngData()),
      .scissors(appearance.scissorsRightImage?.pngData())
    ].shuffled()
    let randomRightSide = randomRightSideList.first ?? .paper(nil)
    
    let newLeftSideScore = model.leftSideScore + generateScore(leftSide: randomLeftSide,
                                                               rightSide: randomRightSide).leftSideScore
    let newRightSideScore = model.rightSideScore + generateScore(leftSide: randomLeftSide,
                                                                 rightSide: randomRightSide).rightSideScore
    let result = generateResult(leftSideScore: newLeftSideScore, rightSideScore: newRightSideScore)
    
    let model = RockPaperScissorsScreenModel(leftSideScreen: randomLeftSide,
                                             leftSideScore: newLeftSideScore,
                                             rightSideScreen: randomRightSide,
                                             rightSideScore: newRightSideScore,
                                             result: result)
    output?.didReceiveGenerate(model: model)
  }
  
  func generateResult(leftSideScore: Int, rightSideScore: Int) -> String {
    return "\(leftSideScore) : \(rightSideScore)"
  }
  
  func generateScore(leftSide: RockPaperScissorsScreenModel.HandsType,
                     rightSide: RockPaperScissorsScreenModel.HandsType) -> (leftSideScore: Int, rightSideScore: Int) {
    let appearance = Appearance()
    
    if case .rock = leftSide {
      if case .rock = rightSide {
        return (.zero, .zero)
      }
    }
    
    if case .rock = leftSide {
      if case .paper = rightSide {
        return (.zero, appearance.scoreOne)
      }
    }
    
    if case .rock = leftSide {
      if case .scissors = rightSide {
        return (appearance.scoreOne, .zero)
      }
    }
    
    if case .paper = leftSide {
      if case .paper = rightSide {
        return (.zero, .zero)
      }
    }
    
    if case .paper = leftSide {
      if case .scissors = rightSide {
        return (.zero, appearance.scoreOne)
      }
    }
    
    if case .paper = leftSide {
      if case .rock = rightSide {
        return (appearance.scoreOne, .zero)
      }
    }
    
    if case .scissors = leftSide {
      if case .scissors = rightSide {
        return (.zero, .zero)
      }
    }
    
    if case .scissors = leftSide {
      if case .rock = rightSide {
        return (.zero, appearance.scoreOne)
      }
    }
    
    if case .scissors = leftSide {
      if case .paper = rightSide {
        return (appearance.scoreOne, .zero)
      }
    }
    return (.zero, .zero)
  }
}

extension RockPaperScissorsScreenFactory {
  struct Appearance {
    let rockLeftImage = UIImage(named: "rock_left_side")
    let paperLeftImage = UIImage(named: "paper_lest_side")
    let scissorsLeftImage = UIImage(named: "scissors_left_side")
    
    let rockRightImage = UIImage(named: "rock_right_side")
    let paperRightImage = UIImage(named: "paper_right_side")
    let scissorsRightImage = UIImage(named: "scissors_right_side")
    let totalEmptyResult = "0 : 0"
    let scoreOne = 1
  }
}
