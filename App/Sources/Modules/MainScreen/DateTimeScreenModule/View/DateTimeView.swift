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

protocol DateTimeViewInput {
  
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
  
  private let buttonsTopStackView = UIStackView()
  private let buttonsBottomStackView = UIStackView()
  private let generateButtonDay = ButtonView()
  private let generateButtonDate = ButtonView()
  private let generateButtonTime = ButtonView()
  private let generateButtonMonth = ButtonView()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupConstraints()
    setupDefaultSettings()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  func updateContentWith(model: DateTimeScreenModel) {
    scrollResult.listLabels = model.listResult
    
    resultLabel.text = model.result
    resultLabel.zoomIn(duration: Appearance().resultDuration,
                       transformScale: CGAffineTransform(scaleX: .zero, y: .zero))
  }
}

// MARK: - Private

private extension DateTimeView {
  func setupDefaultSettings() {
    let appearance = Appearance()
    
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    isUserInteractionEnabled = true
    
    resultLabel.font = RandomFont.primaryBold50
    resultLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
    resultLabel.textAlignment = .center
    
    generateButtonDay.setTitle(appearance.textButtonDayTitle, for: .normal)
    generateButtonDay.addTarget(self, action: #selector(generateButtonDayAction), for: .touchUpInside)
    
    generateButtonDate.setTitle(appearance.textButtonDateTitle, for: .normal)
    generateButtonDate.addTarget(self, action: #selector(generateButtonDateAction), for: .touchUpInside)
    
    generateButtonTime.setTitle(appearance.textButtomTimeTitle, for: .normal)
    generateButtonTime.addTarget(self, action: #selector(generateButtonTimeAction), for: .touchUpInside)
    
    generateButtonMonth.setTitle(appearance.textButtonMonthTitle, for: .normal)
    generateButtonMonth.addTarget(self, action: #selector(generateButtonMonthAction), for: .touchUpInside)
    
    buttonsTopStackView.axis = .horizontal
    buttonsTopStackView.distribution = .fillEqually
    buttonsTopStackView.spacing = appearance.defaultInset
    
    buttonsBottomStackView.axis = .horizontal
    buttonsBottomStackView.distribution = .fillEqually
    buttonsBottomStackView.spacing = appearance.defaultInset
    
    let resultLabelAction = UITapGestureRecognizer(target: self, action: #selector(resultAction))
    resultLabelAction.cancelsTouchesInView = false
    resultLabel.addGestureRecognizer(resultLabelAction)
    resultLabel.isUserInteractionEnabled = true
  }
  
  func setupConstraints() {
    let appearance = Appearance()
    
    [generateButtonDay, generateButtonTime].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      buttonsTopStackView.addArrangedSubview($0)
    }
    
    [generateButtonDate, generateButtonMonth].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      buttonsBottomStackView.addArrangedSubview($0)
    }
    
    [resultLabel, scrollResult, buttonsTopStackView, buttonsBottomStackView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.defaultInset),
      resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.defaultInset),
      
      buttonsTopStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: appearance.defaultInset),
      buttonsTopStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                    constant: -appearance.defaultInset),
      buttonsTopStackView.bottomAnchor.constraint(equalTo: buttonsBottomStackView.topAnchor,
                                                  constant: -appearance.defaultInset),
      
      buttonsBottomStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                      constant: appearance.defaultInset),
      buttonsBottomStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                       constant: -appearance.defaultInset),
      buttonsBottomStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                     constant: -appearance.defaultInset),
      
      scrollResult.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollResult.trailingAnchor.constraint(equalTo: trailingAnchor),
      scrollResult.bottomAnchor.constraint(equalTo: buttonsTopStackView.topAnchor,
                                           constant: -appearance.minInset)
    ])
  }
  
  @objc
  func generateButtonDayAction() {
    output?.generateButtonDayAction()
  }
  
  @objc
  func generateButtonDateAction() {
    output?.generateButtonDateAction()
  }
  
  @objc
  func generateButtonTimeAction() {
    output?.generateButtonTimeAction()
  }
  
  @objc
  func generateButtonMonthAction() {
    output?.generateButtonMonthAction()
  }
  
  @objc
  func resultAction() {
    output?.resultLabelAction()
  }
}

// MARK: - Appearance

private extension DateTimeView {
  struct Appearance {
    let textButtonDayTitle = NSLocalizedString("День", comment: "")
    let textButtonDateTitle = NSLocalizedString("Дата", comment: "")
    let textButtomTimeTitle = NSLocalizedString("Время", comment: "")
    let textButtonMonthTitle = NSLocalizedString("Месяц", comment: "")
    
    let defaultInset: CGFloat = 16
    let minInset: CGFloat = 8
    let resultDuration: CGFloat = 0.2
  }
}
