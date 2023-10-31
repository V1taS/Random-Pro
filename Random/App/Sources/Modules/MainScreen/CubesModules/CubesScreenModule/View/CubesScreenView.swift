//
//  CubesScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 15.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из View в Presenter
protocol CubesScreenViewOutput: AnyObject {
  
  /// Обновить количество кубиков
  ///  - Parameter count: Количество кубиков
  func updateSelectedCountCubes(_ cubesType: CubesScreenModel.CubesType)
  
  /// Кубики были подкинуты
  /// - Parameter totalValue: Сумма всех кубиков
  func diceAction(totalValue: Int)

  /// Пользователь нажал на кнопку генерации
  func playHapticFeedbackAction()
}

/// События которые отправляем от Presenter ко View
protocol CubesScreenViewInput {
  
  /// Обновить контент
  ///  - Parameter model: Модель кубиков
  func updateContentWith(model: CubesScreenModel)
  
  /// Обновить контент
  ///  - Parameter listResult: Список результатов
  func updateContentWith(listResult: [String])
  
  /// Показать список генераций результатов
  /// - Parameter isShow: показать  список генераций результатов
  func listGenerated(isShow: Bool)
}

typealias CubesScreenViewProtocol = UIView & CubesScreenViewInput

final class CubesScreenView: CubesScreenViewProtocol {

  // MARK: - Internal property
  
  weak var output: CubesScreenViewOutput?
  
  // MARK: - Private property
  
  private let cubesSegmentedControl = UISegmentedControl()
  private let scrollResultView = ScrollLabelGradientView()
  private let generateButton = ButtonView()
  private let cubesView = CubesView()
  private var totalValueDice: Int = .zero
  private var counter: Int = .zero
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupDefaultSettings()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  func updateContentWith(model: CubesScreenModel) {
    cubesSegmentedControl.selectedSegmentIndex = model.cubesType.rawValue
    cubesView.updateCubesWith(model: model)
    setButtonTitle()
  }
  
  func updateContentWith(listResult: [String]) {
    scrollResultView.listLabels = listResult
  }
  
  func listGenerated(isShow: Bool) {
    scrollResultView.isHidden = !isShow
  }
}

// MARK: - Private

private extension CubesScreenView {
  func setupDefaultSettings() {
    let appearance = Appearance()
    backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    scrollResultView.backgroundColor = .clear
    generateButton.backgroundColor = .clear
    cubesSegmentedControl.backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    
    cubesSegmentedControl.insertSegment(withTitle: appearance.numberOne,
                                        at: appearance.numberIndexZero, animated: false)
    cubesSegmentedControl.insertSegment(withTitle: appearance.numberTwo,
                                        at: appearance.numberIndexOne, animated: false)
    cubesSegmentedControl.insertSegment(withTitle: appearance.numberThree,
                                        at: appearance.numberIndexTwo, animated: false)
    cubesSegmentedControl.insertSegment(withTitle: appearance.numberFour,
                                        at: appearance.numberIndexThree, animated: false)
    cubesSegmentedControl.insertSegment(withTitle: appearance.numberFive,
                                        at: appearance.numberIndexFour, animated: false)
    cubesSegmentedControl.insertSegment(withTitle: appearance.numberSix,
                                        at: appearance.numberIndexFive, animated: false)
    
    cubesSegmentedControl.addTarget(self,
                                    action: #selector(cubesSegmentedAction),
                                    for: .valueChanged)
    
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
    
    cubesView.totalValueDiceAction = { [weak self] valueDice in
      guard let self = self else {
        return
      }
      
      let countCube = self.cubesSegmentedControl.selectedSegmentIndex + 1
      self.totalValueDice += valueDice
      self.counter += 1
      
      if countCube == self.counter {
        self.output?.diceAction(totalValue: self.totalValueDice)
        self.totalValueDice = .zero
        self.counter = .zero
      }
    }

    cubesView.feedbackGeneratorAction = { [weak self] in
      self?.output?.playHapticFeedbackAction()
    }
  }
  
  func setupConstraints() {
    let appearance = Appearance()
    
    [cubesView, scrollResultView, generateButton, cubesSegmentedControl].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      cubesSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                     constant: appearance.defaultInset),
      cubesSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                      constant: -appearance.defaultInset),
      cubesSegmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                 constant: appearance.minInset),
      
      cubesView.leadingAnchor.constraint(equalTo: leadingAnchor),
      cubesView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      cubesView.trailingAnchor.constraint(equalTo: trailingAnchor),
      cubesView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.defaultInset),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.defaultInset),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.defaultInset),
      
      scrollResultView.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                               constant: -appearance.minInset),
      scrollResultView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollResultView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }
  
  func setButtonTitle() {
    let appearance = Appearance()
    let cubeType = CubesScreenModel.CubesType(rawValue: cubesSegmentedControl.selectedSegmentIndex) ?? .cubesTwo
    let buttonTitle = cubeType == .cubesOne ? appearance.buttonOneCubeTitle : appearance.buttonSomeCubeTitle
    generateButton.setTitle(buttonTitle, for: .normal)
  }
  
  @objc
  func generateButtonAction() {
    cubesView.handleTap()
  }
  
  @objc
  func cubesSegmentedAction() {
    let cubeType = CubesScreenModel.CubesType(rawValue: cubesSegmentedControl.selectedSegmentIndex) ?? .cubesTwo
    
    output?.updateSelectedCountCubes(cubeType)
  }
}

// MARK: - Appearance

private extension CubesScreenView {
  struct Appearance {
    let defaultInset: CGFloat = 16
    let minInset: CGFloat = 8
    
    let numberIndexZero: Int = 0
    let numberIndexOne: Int = 1
    let numberIndexTwo: Int = 2
    let numberIndexThree: Int = 3
    let numberIndexFour: Int = 4
    let numberIndexFive: Int = 5
    
    let numberOne = "1"
    let numberTwo = "2"
    let numberThree = "3"
    let numberFour = "4"
    let numberFive = "5"
    let numberSix = "6"

    let buttonOneCubeTitle = RandomStrings.Localizable.rollADice
    let buttonSomeCubeTitle = RandomStrings.Localizable.rollDices
    
    let resultDuration: CGFloat = 0.2
  }
}
