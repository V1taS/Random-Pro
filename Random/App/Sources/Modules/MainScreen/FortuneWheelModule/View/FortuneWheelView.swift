//
//  FortuneWheelView.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//

import UIKit
import RandomUIKit
import RandomWheel

/// События которые отправляем из View в Presenter
protocol FortuneWheelViewOutput: AnyObject {}

/// События которые отправляем от Presenter ко View
protocol FortuneWheelViewInput {
  
  /// Установить колесо фортуны
  /// - Parameters:
  ///  - model: Модель данных
  func setupFortuneWheelWith(model: FortuneWheelModel)
}

/// Псевдоним протокола UIView & FortuneWheelViewInput
typealias FortuneWheelViewProtocol = UIView & FortuneWheelViewInput

/// View для экрана
final class FortuneWheelView: FortuneWheelViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: FortuneWheelViewOutput?
  
  // MARK: - Private properties
  
  private var fortuneWheel: SwiftFortuneWheel?
  
  // MARK: - Internal func
  
  func setupFortuneWheelWith(model: FortuneWheelModel) {
    let fortuneWheel = SwiftFortuneWheel(
      frame: Appearance().frame,
      slices: model.slices,
      configuration: model.configuration
    )
    self.fortuneWheel = fortuneWheel
    fortuneWheel.resetRotationPosition()
    fortuneWheel.isSpinEnabled = true
    fortuneWheel.spinImage = model.spinImageName
    
    fortuneWheel.pinImage = model.pinImageName
    fortuneWheel.pinImageViewCollisionEffect = CollisionEffect(force: 8, angle: 20)
    fortuneWheel.edgeCollisionDetectionOn = true
    
    configureLayout(fortuneWheel: fortuneWheel)
    applyDefaultBehavior()
    
    var finishIndex = Int.random(in: 0..<model.slices.count)
    
    fortuneWheel.onSpinButtonTap = { [weak self] in
      self?.fortuneWheel?.startRotationAnimation(
        finishIndex: finishIndex,
        continuousRotationTime: 1,
        continuousRotationSpeed: 4) { (finished) in
          if finished {
            finishIndex = Int.random(in: 0..<model.slices.count)
          }
        }
    }
  }
}

// MARK: - Private

private extension FortuneWheelView {
  func configureLayout(fortuneWheel: SwiftFortuneWheel) {
    let appearance = Appearance()
    subviews.forEach {
      $0.removeFromSuperview()
    }
    
    [fortuneWheel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      fortuneWheel.widthAnchor.constraint(equalToConstant: appearance.frame.width),
      fortuneWheel.heightAnchor.constraint(equalToConstant: appearance.frame.height),
      
      fortuneWheel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      fortuneWheel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    
    fortuneWheel?.layer.shadowColor = UIColor.black.cgColor
    fortuneWheel?.layer.shadowOpacity = 0.3
    fortuneWheel?.layer.shadowOffset = CGSize(width: 0, height: 4)
    fortuneWheel?.layer.shadowRadius = 10
    fortuneWheel?.layer.shouldRasterize = true
    fortuneWheel?.layer.rasterizationScale = UIScreen.main.scale
  }
}

// MARK: - Appearance

private extension FortuneWheelView {
  struct Appearance {
    let frame = CGRect(
      x: .zero,
      y: .zero,
      width: UIScreen.main.bounds.width - 32,
      height: UIScreen.main.bounds.width - 32
    )
  }
}
