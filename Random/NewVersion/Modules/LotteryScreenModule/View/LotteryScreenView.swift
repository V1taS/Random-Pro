//
//  LotteryScreenView.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 18.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

protocol LotteryScreenViewOutput: AnyObject {
  
  /// Кнопка нажата пользователем
  /// - Parameters:
  ///  - rangeStartValue: стартовый textField диапазона
  ///  - rangeEndValue: финальный textField диапазона
  ///  - amountNumberValue: количественный textField
  func generateButtonAction(rangeStartValue: String?, rangeEndValue: String?,amountNumberValue: String?)
}

protocol LotteryScreenViewInput: AnyObject {
  
  /// Устанавливаем данные для количественного textField и диапазонов 
  /// - Parameters:
  ///  - rangeStartValue: стартовый textField диапазона
  ///  - rangeEndValue: финальный textField диапазона
  ///  - amountNumberValue: количественный textField
  func set(rangeStartValue: String?, rangeEndValue: String?,amountNumberValue: String?)
  
  /// Устанавливаем данные в result
  ///  - Parameter result: результат генерации
  func set(result: String?)
}

typealias LotteryScreenViewProtocol = UIView & LotteryScreenViewInput

final class LotteryScreenView: LotteryScreenViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: LotteryScreenViewOutput?
  
  // MARK: - Private property
  
  private let rangeStartTextField = TextFieldView()
  private let rangeEndTextField = TextFieldView()
  private let amountNumberTextField = TextFieldView()
  
  private let rangeTextFieldStackView = UIStackView()
  private let amountNumberTextFieldStackView = UIStackView()
  
  private let resultLabel = UILabel()
  private let generateButton = ButtonView()
  
  private let betweenRangeLabel = UILabel()
  private let rangeNumberLabel = UILabel()
  private let amountNumberLabel = UILabel()
  
  // MARK: - Internal func
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = RandomColor.secondaryWhite
    
    setupConstraints()
    setupDefaultSettings()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func set(result: String?) {
    resultLabel.text = result
  }
  
  func set(rangeStartValue: String?, rangeEndValue: String?,amountNumberValue: String?) {
    rangeStartTextField.text = rangeStartValue
    rangeEndTextField.text = rangeEndValue
    amountNumberTextField.text = amountNumberValue
  }
  
  // MARK: - Private func
  
  private func setupDefaultSettings() {
    let appearance = Appearance()
    
    resultLabel.font = RandomFont.primaryBold50
    resultLabel.textColor = RandomColor.primaryGray
    resultLabel.textAlignment = .center
    resultLabel.numberOfLines = appearance.numberOfLines
    resultLabel.adjustsFontSizeToFitWidth = true
    resultLabel.minimumScaleFactor = appearance.minimumScaleFactor
    
    rangeStartTextField.placeholder = appearance.startPlaceholder
    rangeStartTextField.keyboardType = .numberPad
    rangeStartTextField.delegate = self
    
    rangeEndTextField.placeholder = appearance.endPlaceholder
    rangeEndTextField.keyboardType = .numberPad
    rangeEndTextField.delegate = self
    
    rangeTextFieldStackView.axis = .horizontal
    rangeTextFieldStackView.spacing = appearance.spasing
    rangeTextFieldStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    
    amountNumberTextFieldStackView.axis = .horizontal
    amountNumberTextFieldStackView.spacing = appearance.spasing
    
    amountNumberTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    amountNumberLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    
    generateButton.setTitle(appearance.textButton, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
    
    amountNumberLabel.textColor = RandomColor.primaryGray
    amountNumberLabel.font = RandomFont.primaryRegular18
    amountNumberLabel.text = appearance.textAmountLabel
    
    amountNumberTextField.placeholder = appearance.startPlaceholder
    amountNumberTextField.keyboardType = .numberPad
    amountNumberTextField.delegate = self
    
    rangeNumberLabel.font = RandomFont.primaryRegular18
    rangeNumberLabel.textColor = RandomColor.primaryGray
    rangeNumberLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    rangeNumberLabel.text = appearance.textRangeLabel
    
    betweenRangeLabel.font = RandomFont.primaryMedium18
    betweenRangeLabel.textColor = RandomColor.primaryGray
    betweenRangeLabel.text = appearance.dashBetween
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
    tap.cancelsTouchesInView = false
    addGestureRecognizer(tap)
  }
  
  @objc private func generateButtonAction() {
    output?.generateButtonAction(rangeStartValue: rangeStartTextField.text,
                                 rangeEndValue: rangeEndTextField.text,
                                 amountNumberValue: amountNumberTextField.text)
  }
  
  private func setupConstraints() {
    let appearance = Appearance()
    
    [amountNumberTextFieldStackView, rangeTextFieldStackView, resultLabel, generateButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    [amountNumberLabel, amountNumberTextField].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      amountNumberTextFieldStackView.addArrangedSubview($0)
    }
    
    [rangeNumberLabel, rangeStartTextField, betweenRangeLabel, rangeEndTextField].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      rangeTextFieldStackView.addArrangedSubview($0)
    }
    
    NSLayoutConstraint.activate([
      resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: appearance.middleHorizontalSize),
      resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -appearance.middleHorizontalSize),
      resultLabel.topAnchor.constraint(equalTo: rangeTextFieldStackView.bottomAnchor,
                                       constant: appearance.middleHorizontalSize),
      resultLabel.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                          constant: -appearance.middleHorizontalSize),
      
      rangeStartTextField.widthAnchor.constraint(equalTo: rangeEndTextField.widthAnchor),
      betweenRangeLabel.widthAnchor.constraint(equalToConstant: appearance.lesswidthAnchorSize),
      amountNumberLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: appearance.widthAnchorSize),
      rangeNumberLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: appearance.widthAnchorSize),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: appearance.middleHorizontalSize),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.middleHorizontalSize),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.middleHorizontalSize),
      
      amountNumberTextFieldStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                              constant: appearance.middleHorizontalSize),
      amountNumberTextFieldStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                          constant: appearance.middleHorizontalSize),
      amountNumberTextFieldStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                               constant: -appearance.middleHorizontalSize),
      
      rangeTextFieldStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                       constant: appearance.middleHorizontalSize),
      rangeTextFieldStackView.topAnchor.constraint(equalTo: amountNumberTextFieldStackView.bottomAnchor,
                                                   constant: appearance.middleHorizontalSize),
      rangeTextFieldStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                        constant: -appearance.middleHorizontalSize)
    ])
  }
}

// MARK: - UITextFieldDelegate

extension LotteryScreenView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    rangeStartTextField.resignFirstResponder()
    rangeEndTextField.resignFirstResponder()
    amountNumberTextField.resignFirstResponder()
    return true
  }
}

// MARK: - Appearance

private extension LotteryScreenView {
  struct Appearance {
    let startPlaceholder = "1"
    let endPlaceholder = "100"
    let spasing: CGFloat = 8
    let textButton = NSLocalizedString("Сгенерировать", comment: "")
    let textRangeLabel = NSLocalizedString("Диапазон", comment: "") + ":"
    let textAmountLabel = NSLocalizedString("Количество", comment: "") + ":"
    let dashBetween = " - "
    let middleHorizontalSize: CGFloat = 16
    let largeVerticalSpacing: CGFloat = 24
    let widthAnchorSize: CGFloat = 112
    let lesswidthAnchorSize: CGFloat = 12
    let numberOfLines: Int = 5
    let minimumScaleFactor: CGFloat = 0.3
  }
}
