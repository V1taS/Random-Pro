//
//  DateTimeView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 13.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

protocol DateTimeViewOutput: AnyObject {
  
  /// Пользователь нажал на кнопку День
  func generateButtonDayAction()
  
  /// Пользователь нажал на кнопку Дата
  func generateButtonDateAction()
  
  /// Пользователь нажал на кнопку Время
  func generateButtonTimeAction()
  
  /// Пользователь нажал на кнопку Месяц
  func generateButtonMonthAction()
  
  /// Было нажатие на результат генерации
  func resultLabelAction()
}

protocol DateTimeViewInput: AnyObject {
  
  /// Обновить контент
  /// - Parameter model: Модель
  func updateContentWith(model: DateTimeScreenModel)
}

typealias DateTimeViewProtocol = UIView & DateTimeViewInput

final class DateTimeView: DateTimeViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: DateTimeViewOutput?
  
  // MARK: - Private property
  
  private let resultLabel = UILabel()
  private let scrollResult = ScrollLabelGradientView()
  
  private let buttonStackViewOne = UIStackView()
  private let buttonStackViewTwo = UIStackView()
  private let generateButtonDay = ButtonView()
  private let generateButtonDate = ButtonView()
  private let generateButtonTime = ButtonView()
  private let generateButtonMonth = ButtonView()
  
  // MARK: - Internal func
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupConstraints()
    setupDefaultSettings()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateContentWith(model: DateTimeScreenModel) {
    resultLabel.text = model.result
    scrollResult.listLabels = model.listResult
  }
  
  // MARK: - Private func
  
  private func setupDefaultSettings() {
    let appearance = Appearance()
    
    backgroundColor = RandomColor.secondaryWhite
    isUserInteractionEnabled = true
    
    resultLabel.font = RandomFont.primaryBold50
    resultLabel.textColor = RandomColor.primaryGray
    resultLabel.textAlignment = .center
    
    generateButtonDay.setTitle(appearance.textButtonDay, for: .normal)
    generateButtonDay.addTarget(self, action: #selector(generateButtonDayAction), for: .touchUpInside)
    
    generateButtonDate.setTitle(appearance.textButtonDate, for: .normal)
    generateButtonDate.addTarget(self, action: #selector(generateButtonDateAction), for: .touchUpInside)
    
    generateButtonTime.setTitle(appearance.textButtomTime, for: .normal)
    generateButtonTime.addTarget(self, action: #selector(generateButtonTimeAction), for: .touchUpInside)
    
    generateButtonMonth.setTitle(appearance.textButtonMonth, for: .normal)
    generateButtonMonth.addTarget(self, action: #selector(generateButtonMonthAction), for: .touchUpInside)
    
    buttonStackViewOne.axis = .horizontal
    buttonStackViewOne.distribution = .fillEqually
    buttonStackViewOne.spacing = appearance.lessHorizontalSpacing
    
    buttonStackViewTwo.axis = .horizontal
    buttonStackViewTwo.distribution = .fillEqually
    buttonStackViewTwo.spacing = appearance.lessHorizontalSpacing
    
    let resultLabelTap = UITapGestureRecognizer(target: self, action: #selector(resultLabelAction))
    resultLabelTap.cancelsTouchesInView = false
    resultLabel.isUserInteractionEnabled = true
    resultLabel.addGestureRecognizer(resultLabelTap)
  }
  
  @objc
  private func resultLabelAction() {
    output?.resultLabelAction()
  }
  
  @objc
  private func generateButtonDayAction() {
    output?.generateButtonDayAction()
  }
  
  @objc
  private func generateButtonDateAction() {
    output?.generateButtonDateAction()
  }
  
  @objc
  private func generateButtonTimeAction() {
    output?.generateButtonTimeAction()
  }
  
  @objc
  private func generateButtonMonthAction() {
    output?.generateButtonMonthAction()
  }
  
  private func setupConstraints() {
    let appearance = Appearance()
    
    [generateButtonDay, generateButtonTime].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      buttonStackViewOne.addArrangedSubview($0)
    }
    
    [generateButtonDate, generateButtonMonth].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      buttonStackViewTwo.addArrangedSubview($0)
    }
    
    [resultLabel, scrollResult, buttonStackViewOne, buttonStackViewTwo].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.middleHorizontalSpacing),
      resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.middleHorizontalSpacing),
      
      buttonStackViewOne.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                  constant: appearance.middleHorizontalSpacing),
      buttonStackViewOne.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: -appearance.middleHorizontalSpacing),
      buttonStackViewOne.bottomAnchor.constraint(equalTo: buttonStackViewTwo.topAnchor,
                                                 constant: -appearance.lessHorizontalSpacing),
      
      buttonStackViewTwo.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                  constant: appearance.middleHorizontalSpacing),
      buttonStackViewTwo.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: -appearance.middleHorizontalSpacing),
      buttonStackViewTwo.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                 constant: -appearance.middleHorizontalSpacing),
      
      scrollResult.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollResult.trailingAnchor.constraint(equalTo: trailingAnchor),
      scrollResult.bottomAnchor.constraint(equalTo: buttonStackViewOne.topAnchor,
                                           constant: -appearance.spasing)
    ])
  }
}

// MARK: - Private Appearance

extension DateTimeView {
  struct Appearance {
    let textButtonDay = NSLocalizedString("День", comment: "")
    let textButtonDate = NSLocalizedString("Дата", comment: "")
    let textButtomTime = NSLocalizedString("Время", comment: "")
    let textButtonMonth = NSLocalizedString("Месяц", comment: "")
    let middleHorizontalSpacing: CGFloat = 16
    let lessHorizontalSpacing: CGFloat = 16
    let spasing: CGFloat = 8
  }
}
