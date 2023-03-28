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
  
  /// Остановить вращение бутылки
  func stopBottleRotation()
}

/// События которые отправляем от Presenter к Interactor
protocol BottleScreenInteractorInput {
  
  /// Пользователь нажал на кнопку
  func generatesBottleRotationTimeAction()
  
  /// Запустить обратную связь от моторчика
  func playHapticFeedback()
  
  /// Остановить обратную связь от моторчика
  func stopHapticFeedback()
}

final class BottleScreenInteractor: BottleScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: BottleScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private let bottleImageView = UIImageView()
  private let timerService: BottleScreenTimerServiceProtocol
  private let hapticService: BottleScreenHapticServiceProtocol
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - timerService: время
  ///   - hapticService: Обратная связь от моторчика
  init(_ timerService: BottleScreenTimerServiceProtocol, hapticService: BottleScreenHapticServiceProtocol) {
    self.timerService = timerService
    self.hapticService = hapticService
  }
  
  // MARK: - Internal property
  
  func generatesBottleRotationTimeAction() {
    let appearance = Appearance()
    let requiredNumberOfLaps = generateNumberOfLaps(appearance.laps)
    let totalRandomTime = generateRandomTime(requiredNumberOfLaps)
    
    timerService.startTimerWith(seconds: totalRandomTime,
                                timerTickAction: nil,
                                timerFinishedAction: { [weak self] in
      self?.output?.stopBottleRotation()
    })
  }
  
  func playHapticFeedback() {
    hapticService.play(isRepeat: true) { _ in }
  }
  
  func stopHapticFeedback() {
    hapticService.stop()
  }
}

// MARK: - Private

private extension BottleScreenInteractor {
  func generateNumberOfLaps(_ laps: [Double]) -> Double {
    return laps.shuffled().first ?? .zero
  }
  
  func generateRandomTime(_ numberOfLaps: Double) -> Double {
    let randomTime = Double.random(in: 1...5)
    return numberOfLaps + randomTime
  }
}

// MARK: - Appearance

private extension BottleScreenInteractor {
  struct Appearance {
    let laps = [1, 1.5, 2, 2.5]
  }
}
