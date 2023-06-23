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
protocol FortuneWheelViewOutput: AnyObject {
  
  /// Выбрать ячейку было нажато
  func selectedSectionAction()
  
  /// Сохранить результат
  /// - Parameter result: Результат
  func save(result: String)
}

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
  private let selectedSectionView = ImageAndLabelWithButtonBigView()
  private let resultLabel = UILabel()
  private var resultText = ""
  
  // MARK: - Internal func
  
  func setupFortuneWheelWith(model: FortuneWheelModel) {
    guard let selectedSection = model.sections.filter({ $0.isSelected }).first,
          model.slices.count > .zero else {
      return
    }
    
    let fortuneWheel = SwiftFortuneWheel(
      frame: Appearance().frame,
      slices: model.slices,
      configuration: model.configuration
    )
    self.fortuneWheel = fortuneWheel
    fortuneWheel.isSpinEnabled = true
    fortuneWheel.spinImage = model.spinImageName
    
    fortuneWheel.pinImage = model.pinImageName
    fortuneWheel.pinImageViewCollisionEffect = CollisionEffect(force: 8, angle: 20)
    fortuneWheel.edgeCollisionDetectionOn = true
    
    selectedSectionView.configureWith(
      leftSideEmoji: Character(selectedSection.icon ?? " "),
      titleText: selectedSection.title,
      rightButtonImage: nil,
      actionCell: { [weak self] in
        self?.output?.selectedSectionAction()
      },
      actionButton: nil
    )
    selectedSectionView.style = .selected
    
    var finishIndex = Int.random(in: 0..<model.slices.count)
    
    fortuneWheel.onEdgeCollision = { [weak self] progress in
      guard let progress,
            let currentIndex = self?.getIndexFromCollision(
              progress: progress,
              finishIndex: finishIndex
            ),
            progress == 1 else {
        return
      }
      self?.setupResultFrom(index: currentIndex)
    }
    
    if model.isEnabledFeedback {
      fortuneWheel.impactFeedbackOn = true
    }
    
    configureLayout(fortuneWheel: fortuneWheel)
    applyDefaultBehavior()
    
    fortuneWheel.onSpinButtonTap = { [weak self] in
      self?.resultLabel.text = "?"
      self?.fortuneWheel?.startRotationAnimation(
        finishIndex: finishIndex,
        continuousRotationTime: 1,
        continuousRotationSpeed: 4,
        rotationOffset: CGFloat.random(in: -20...20)) { [weak self] finished in
          if finished {
            finishIndex = Int.random(in: 0..<model.slices.count)
            self?.resultLabel.text = self?.resultText
          }
        }
    }
  }
}

// MARK: - Private

private extension FortuneWheelView {
  func setupResultFrom(index: Int) {
    guard let fortuneWheel,
          let contentType = fortuneWheel.slices[index].contents.first,
          case let .text(text, _) = contentType else {
      return
    }
    resultText = text
    output?.save(result: text)
  }
  
  func getIndexFromCollision(progress: Double, finishIndex: Int) -> Int? {
    guard let fortuneWheel else {
      return nil
    }
    
    let startIndex = 0
    let stepsCount = (finishIndex - startIndex + fortuneWheel.slices.count) % fortuneWheel.slices.count
    let stepsMade = Int(round(progress * Double(stepsCount)))
    let currentIndex = (startIndex + stepsMade) % fortuneWheel.slices.count
    return currentIndex
  }
  
  func configureLayout(fortuneWheel: SwiftFortuneWheel) {
    let appearance = Appearance()
    subviews.forEach {
      $0.removeFromSuperview()
    }
    
    [fortuneWheel, resultLabel, selectedSectionView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      fortuneWheel.widthAnchor.constraint(equalToConstant: appearance.frame.width),
      fortuneWheel.heightAnchor.constraint(equalToConstant: appearance.frame.height),
      
      resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      resultLabel.bottomAnchor.constraint(equalTo: fortuneWheel.topAnchor,
                                          constant: -64),
      fortuneWheel.centerYAnchor.constraint(equalTo: centerYAnchor,
                                            constant: 24),
      fortuneWheel.centerXAnchor.constraint(equalTo: centerXAnchor),
      
      selectedSectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
      selectedSectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                  constant: -24)
    ])
  }
  
  func applyDefaultBehavior() {
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    
    fortuneWheel?.layer.shadowColor = UIColor.black.cgColor
    fortuneWheel?.layer.shadowOpacity = 0.3
    fortuneWheel?.layer.shadowOffset = CGSize(width: 0, height: 4)
    fortuneWheel?.layer.shadowRadius = 10
    fortuneWheel?.layer.shouldRasterize = true
    fortuneWheel?.layer.rasterizationScale = UIScreen.main.scale
    
    resultLabel.font = RandomFont.primaryBold32
    resultLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
    resultLabel.text = "?"
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
    let wheelSoundClick = AudioFile(filename: "fortune_wheel_sound_click", extensionName: "mp3")
    let wheelSoundTick = AudioFile(filename: "fortune_wheel_sound_tick", extensionName: "mp3")
    let minInset: CGFloat = 8
    let defaultInset: CGFloat = 16
    let maxInset: CGFloat = 48
  }
}
