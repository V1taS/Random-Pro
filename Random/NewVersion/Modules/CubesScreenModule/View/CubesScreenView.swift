//
//  CubesScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 15.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

protocol CubesScreenViewOutput: AnyObject {
  
  /// Пользователь нажал на кнопку генерации
  func generateButtonAction()
}

protocol CubesScreenViewInput {}

typealias CubesScreenViewProtocol = UIView & CubesScreenViewInput

final class CubesScreenView: CubesScreenViewProtocol {
  
  weak var output: CubesScreenViewOutput?
  
  private let cubesSegmentedControl = UISegmentedControl()
  private let scrollResultView = ScrollLabelGradientView()
  private let resultLabel = UILabel()
  private let generateButton = ButtonView()
  private let cubesView = CubesView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupDefaultSettings()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private func
  
  private func setupDefaultSettings() {
    let appearance = Appearance()
    backgroundColor = RandomColor.primaryWhite
    
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
    cubesSegmentedControl.selectedSegmentIndex = .zero
    
    
    cubesSegmentedControl.addTarget(self,
                                    action: #selector(cubesSegmentedAction),
                                    for: .valueChanged)
    
    
    resultLabel.isHidden = true
    resultLabel.text = appearance.result
    resultLabel.font = RandomFont.primaryBold70
    resultLabel.textColor = RandomColor.primaryGray
    resultLabel.textAlignment = .center
    
    generateButton.setTitle(appearance.titleButton, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .valueChanged)
  }
  
  @objc private func generateButtonAction() {}
  
  @objc
  private func cubesSegmentedAction() {
    if cubesSegmentedControl.selectedSegmentIndex == .zero {
      cubesView.updateCubesWith(type: .cubesOne(3))
    } else if cubesSegmentedControl.selectedSegmentIndex == 1 {
      cubesView.updateCubesWith(type: .cubesTwo(cubesOne: 5, cubesTwo: 6))
    } else if cubesSegmentedControl.selectedSegmentIndex == 2 {
      cubesView.updateCubesWith(type: .cubesThree(cubesOne: 2, cubesTwo: 6, cubesThree: 4))
    } else if cubesSegmentedControl.selectedSegmentIndex == 3 {
      cubesView.updateCubesWith(type: .cubesFour(cubesOne: 3, cubesTwo: 3, cubesThree: 1, cubesFour: 5))
    } else if cubesSegmentedControl.selectedSegmentIndex == 4 {
      cubesView.updateCubesWith(type: .cubesFive(cubesOne: 1, cubesTwo: 2, cubesThree: 5,
                                                 cubesFour: 6, cubesFive: 3))
    } else if cubesSegmentedControl.selectedSegmentIndex == 5 {
      cubesView.updateCubesWith(type: .cubesSix(cubesOne: 5, cubesTwo: 3, cubesThree: 2,
                                                cubesFour: 1, cubesFive: 4, cubesSix: 6))
    }
  }
  
  private func setupConstraints() {
    let appearance = Appearance()
    
    [cubesSegmentedControl, resultLabel, cubesView, scrollResultView, generateButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      cubesSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                     constant: appearance.middleHorizontalSize),
      cubesSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                      constant: -appearance.middleHorizontalSize),
      cubesSegmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                 constant: appearance.lessVirticalSize),
      
      cubesView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                         constant: appearance.middleHorizontalSize),
      cubesView.topAnchor.constraint(equalTo: cubesSegmentedControl.bottomAnchor,
                                     constant: appearance.middleHorizontalSize),
      cubesView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                          constant: -appearance.middleHorizontalSize),
      cubesView.bottomAnchor.constraint(equalTo: scrollResultView.topAnchor,
                                        constant: -appearance.middleHorizontalSize),
      
      resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.middleHorizontalSize),
      resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.middleHorizontalSize),
      resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.middleHorizontalSize),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.middleHorizontalSize),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.middleHorizontalSize),
      
      scrollResultView.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                               constant: -appearance.lessVirticalSize),
      scrollResultView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollResultView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }
}


extension CubesScreenView {
  struct Appearance {
    let middleHorizontalSize: CGFloat = 16
    let lessVirticalSize: CGFloat = 8
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
    let titleButton = NSLocalizedString("Бросить кубик(и)", comment: "")
    let result = "?"
  }
}

