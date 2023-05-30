//
//  ADVGoogleScreenInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 29.05.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol ADVGoogleScreenInteractorOutput: AnyObject {
  
  /// Оставшее время
  func didReceiveEstimatedSeconds(_ seconds: Int)
}

/// События которые отправляем от Presenter к Interactor
protocol ADVGoogleScreenInteractorInput {
  
  /// Оставшееся время (Общее время 5 секунд)
  func estimatedSecondsAction()
}

/// Интерактор
final class ADVGoogleScreenInteractor: ADVGoogleScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: ADVGoogleScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private var timer: Timer?
  private var estimatedSeconds: Double = .zero
  
  // MARK: - Internal func
  
  func estimatedSecondsAction() {
    estimatedSeconds = Appearance().estimatedSeconds
    let timer = Timer(timeInterval: 1,
                      target: self,
                      selector: #selector(startTimer),
                      userInfo: nil,
                      repeats: true)
    self.timer = timer
    RunLoop.current.add(timer, forMode: .common)
  }
}

// MARK: - Private

private extension ADVGoogleScreenInteractor {
  @objc
  func startTimer() {
    if estimatedSeconds == .zero {
      timer?.invalidate()
      timer = nil
    }
    
    output?.didReceiveEstimatedSeconds(Int(estimatedSeconds))
    estimatedSeconds -= 1
  }
}

// MARK: - Appearance

private extension ADVGoogleScreenInteractor {
  struct Appearance {
    let estimatedSeconds: Double = 10
  }
}
