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
  func stopAnimation()
  
  /// Вибрация при вращении бутылочки
  func hapticFeedback()
}

/// События которые отправляем от Presenter к Interactor
protocol BottleScreenInteractorInput {
  
  /// Пользователь нажал на кнопку
 func generateButtonAction()
}

final class BottleScreenInteractor: BottleScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: BottleScreenInteractorOutput?
  
  // MARK: - Private property
  
  private let bottleImage = UIImageView()
  private let timerService: TimerService
  
  // MARK: - Initialization
  /// - Parameters:
  ///   - timerService: время
  init(_ timerService: TimerService) {
    self.timerService = timerService
  }
  
  // MARK: - Internal property
  
  func generateButtonAction() {
    let requiredNumberOfLaps = [1, 1.5, 2, 2.5].shuffled().first
    let randomTime = Double.random(in: 1...5)
    let totalTime = (requiredNumberOfLaps ?? 2) + randomTime
    timerService.startTimerWith(seconds: totalTime,
                                timerTickAction: { [weak self] _ in
      self?.output?.hapticFeedback()
    },
                                timerFinishedAction: { [weak self] in
      self?.output?.stopAnimation()
    })
  }
}
