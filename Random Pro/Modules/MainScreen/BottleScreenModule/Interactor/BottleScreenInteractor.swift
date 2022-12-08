//
//  BottleScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 29.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol BottleScreenInteractorOutput: AnyObject {

  /// Остановка анимации бутылочки
  func stopBottleRotation()
  
  /// Вибрация при вращении бутылочки
  func tactileFeedbackBottleRotates()
}

/// События которые отправляем от Presenter к Interactor
protocol BottleScreenInteractorInput {
  
  /// Пользователь нажал на кнопку
 func generatesBottleRotationTimeAction()
}

final class BottleScreenInteractor: BottleScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: BottleScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private let bottleImageView = UIImageView()
  private let timerService: TimerService
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - timerService: время
  init(_ timerService: TimerService) {
    self.timerService = timerService
  }
  
  // MARK: - Internal property
  
  func generatesBottleRotationTimeAction() {
    let appearance = Appearance()
    
    let requiredNumberOfLaps = generateNumberOfLaps(appearance.laps)
    let randomTime =  Double.random(in: 1...5)
    let totalTime = (requiredNumberOfLaps) + randomTime
    timerService.startTimerWith(seconds: totalTime,
                                timerTickAction: { [weak self] _ in
      self?.output?.tactileFeedbackBottleRotates()
    },
                                timerFinishedAction: { [weak self] in
      self?.output?.stopBottleRotation()
    })
  }
  
  // MARK: - Private

  private func generateNumberOfLaps(_ laps: [Double]) -> Double {
      return laps.shuffled().first ?? .zero
  }
}

extension BottleScreenInteractor {
  struct Appearance {
    let laps = [1, 1.5, 2, 2.5]
  }
}
