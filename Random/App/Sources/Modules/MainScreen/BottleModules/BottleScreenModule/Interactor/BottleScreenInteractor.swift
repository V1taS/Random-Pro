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

  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didReceive(model: BottleScreenModel)
}

/// События которые отправляем от Presenter к Interactor
protocol BottleScreenInteractorInput {
  
  /// Пользователь нажал на кнопку
  func generatesBottleRotationTimeAction()
  
  /// Запустить обратную связь от моторчика
  func playHapticFeedback()
  
  /// Остановить обратную связь от моторчика
  func stopHapticFeedback()

  /// Обновить стиль
  func updateStyle()
}

final class BottleScreenInteractor: BottleScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: BottleScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private let bottleImageView = UIImageView()
  private let services: ApplicationServices
  private var bottleStyle: BottleStyleSelectionScreenModel.BottleStyle {
    let models = services.storageService.getData(from: [BottleStyleSelectionScreenModel].self)
    return models?.filter { $0.bottleStyleSelection}.first?.bottleStyle ?? .defaultStyle
  }

//  private var bottleScreenModel: BottleScreenModel? {
//    get {
//      services.storageService.getData(from: BottleScreenModel.self)
//    } set {
//      services.storageService.saveData(newValue)
//    }
//  }
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(_ services: ApplicationServices) {
    self.services = services
  }
  
  // MARK: - Internal fun

  func updateStyle() {
    let newModel = BottleScreenModel(bottleStyle: bottleStyle)
    output?.didReceive(model: newModel)
  }

  func generatesBottleRotationTimeAction() {
    let appearance = Appearance()
    let requiredNumberOfLaps = generateNumberOfLaps(appearance.laps)
    let totalRandomTime = generateRandomTime(requiredNumberOfLaps)
    
    services.timerService.startTimerWith(seconds: totalRandomTime,
                                         timerTickAction: nil,
                                         timerFinishedAction: { [weak self] in
      self?.output?.stopBottleRotation()
      self?.services.buttonCounterService.onButtonClick()
    })
  }
  
  func playHapticFeedback() {
    services.hapticService.play(isRepeat: true,
                                patternType: .feedingCrocodile) { _ in }
  }
  
  func stopHapticFeedback() {
    services.hapticService.stop()
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
