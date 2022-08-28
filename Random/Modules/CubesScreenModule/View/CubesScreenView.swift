//
//  CubesScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 15.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol CubesScreenViewOutput: AnyObject {
  
  /// Пользователь нажал на кнопку генерации
  func generateButtonAction()
  
  /// Обновить количество кубиков
  ///  - Parameter count: Количество кубиков
  func updateSelectedCountCubes(_ count: Int)
}

/// События которые отправляем от Presenter ко View
protocol CubesScreenViewInput {
  
  /// Обновить контент
  ///  - Parameters:
  ///   - selectedCountCubes: Количество кубиков
  ///   - cubesType: Тип кубиков
  ///   - listResult: Список результатов
  ///   - plagIsShow: Заглушка
  func updateContentWith(selectedCountCubes: Int,
                         cubesType: CubesScreenModel.CubesType,
                         listResult: [String],
                         plagIsShow: Bool)
}

typealias CubesScreenViewProtocol = UIView & CubesScreenViewInput

final class CubesScreenView: CubesScreenViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: CubesScreenViewOutput?
  
  // MARK: - Private property
  
  private let cubesSegmentedControl = UISegmentedControl()
  private let scrollResultView = ScrollLabelGradientView()
  private let resultLabel = UILabel()
  private let generateButton = ButtonView()
  private let cubesView = CubesView()
  
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
  
  func updateContentWith(selectedCountCubes: Int,
                         cubesType: CubesScreenModel.CubesType,
                         listResult: [String],
                         plagIsShow: Bool) {
    cubesSegmentedControl.selectedSegmentIndex = selectedCountCubes - 1
    cubesView.updateCubesWith(type: cubesType)
    scrollResultView.listLabels = listResult
    
    resultLabel.isHidden = !plagIsShow
    cubesView.isHidden = plagIsShow
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
    
    cubesSegmentedControl.addTarget(self,
                                    action: #selector(cubesSegmentedAction),
                                    for: .valueChanged)
    
    resultLabel.text = appearance.result
    resultLabel.font = RandomFont.primaryBold70
    resultLabel.textColor = RandomColor.primaryGray
    resultLabel.textAlignment = .center
    
    generateButton.setTitle(appearance.titleButton, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
  }
  
  @objc
  private func generateButtonAction() {
    output?.generateButtonAction()
  }
  
  @objc
  private func cubesSegmentedAction() {
    output?.updateSelectedCountCubes(cubesSegmentedControl.selectedSegmentIndex + 1)
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

