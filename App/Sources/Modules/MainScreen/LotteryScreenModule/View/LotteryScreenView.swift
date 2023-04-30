//
//  LotteryScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 18.05.2022.
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
  func generateButtonAction(rangeStartValue: String?,
                            rangeEndValue: String?,
                            amountNumberValue: String?)
  
  /// Было нажатие на результат генерации
  func resultLabelAction()
}

protocol LotteryScreenViewInput {
  
  /// Обновить контент
  /// - Parameter model: Модель
  func updateContentWith(model: LotteryScreenModel)
}

typealias LotteryScreenViewProtocol = UIView & LotteryScreenViewInput

final class LotteryScreenView: LotteryScreenViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: LotteryScreenViewOutput?
  
  // MARK: - Private property
  
  private let amountNumberTextField = TextFieldView()
  private let rangeStartTextField = TextFieldView()
  private let rangeEndTextField = TextFieldView()

  private let topTextFieldStackView = UIStackView()
  private let bottomTextFieldStackView = UIStackView()
  
  private let resultTextView = UITextView()
  private let generateButton = ButtonView()
  
  private let betweenRangeLabel = UILabel()
  private let amountNumberLabel = UILabel()
  private let rangeNumberLabel = UILabel()
  
  private let scrollResult = ScrollLabelGradientView()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupConstraints()
    setupDefaultSettings()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    resultTextView.centerVerticalText()
  }
  
  // MARK: - Internal func
  
  func updateContentWith(model: LotteryScreenModel) {
    scrollResult.listLabels = model.listResult
    rangeStartTextField.text = model.rangeStartValue
    rangeEndTextField.text = model.rangeEndValue
    amountNumberTextField.text = model.amountValue
    
    resultTextView.text = model.result
    resultTextView.centerVerticalText()
    resultTextView.zoomIn(duration: Appearance().resultDuration,
                       transformScale: CGAffineTransform(scaleX: .zero, y: .zero))
  }
}

// MARK: - UITextFieldDelegate

extension LotteryScreenView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    if range.location >= 3 {
      return false
    }
    return true
  }
}

// MARK: - Private

private extension LotteryScreenView {
  func setupDefaultSettings() {
    let appearance = Appearance()
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    rangeStartTextField.layer.borderColor = RandomColor.darkAndLightTheme.secondaryGray.cgColor
    rangeEndTextField.layer.borderColor = RandomColor.darkAndLightTheme.secondaryGray.cgColor
    amountNumberTextField.layer.borderColor = RandomColor.darkAndLightTheme.secondaryGray.cgColor
    isUserInteractionEnabled = true
    
    resultTextView.font = RandomFont.primaryBold50
    resultTextView.textColor = RandomColor.darkAndLightTheme.primaryGray
    resultTextView.textAlignment = .center
    resultTextView.isEditable = false
    resultTextView.backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    
    let padding = resultTextView.textContainer.lineFragmentPadding
    resultTextView.textContainerInset =  UIEdgeInsets(top: .zero,
                                                      left: -padding,
                                                      bottom: .zero,
                                                      right: -padding)
    resultTextView.centerVerticalText()
    
    rangeStartTextField.placeholder = appearance.startPlaceholder
    rangeStartTextField.keyboardType = .numberPad
    rangeStartTextField.delegate = self
    
    rangeEndTextField.placeholder = appearance.endPlaceholder
    rangeEndTextField.keyboardType = .numberPad
    rangeEndTextField.delegate = self
    
    bottomTextFieldStackView.axis = .horizontal
    bottomTextFieldStackView.spacing = appearance.minInset
    bottomTextFieldStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    
    topTextFieldStackView.axis = .horizontal
    topTextFieldStackView.spacing = appearance.minInset
    
    amountNumberTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    amountNumberLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
    
    amountNumberLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
    amountNumberLabel.font = RandomFont.primaryRegular18
    amountNumberLabel.text = appearance.textAmountLabel + ":"
    
    amountNumberTextField.placeholder = appearance.startPlaceholder
    amountNumberTextField.keyboardType = .numberPad
    amountNumberTextField.delegate = self
    
    rangeNumberLabel.font = RandomFont.primaryRegular18
    rangeNumberLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
    rangeNumberLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    rangeNumberLabel.text = appearance.textRangeLabel + ":"
    
    betweenRangeLabel.font = RandomFont.primaryMedium18
    betweenRangeLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
    betweenRangeLabel.text = appearance.separatorTitle
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
    tap.cancelsTouchesInView = false
    addGestureRecognizer(tap)
    
    let resultLabelAction = UITapGestureRecognizer(target: self, action: #selector(resultAction))
    resultLabelAction.cancelsTouchesInView = false
    resultTextView.addGestureRecognizer(resultLabelAction)
    resultTextView.isUserInteractionEnabled = true
  }
  
  func setupConstraints() {
    let appearance = Appearance()
    
    [topTextFieldStackView, bottomTextFieldStackView,
     resultTextView, scrollResult, generateButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    [amountNumberLabel, amountNumberTextField].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      topTextFieldStackView.addArrangedSubview($0)
    }
    
    [rangeNumberLabel, rangeStartTextField, betweenRangeLabel, rangeEndTextField].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      bottomTextFieldStackView.addArrangedSubview($0)
    }
    
    NSLayoutConstraint.activate([
      topTextFieldStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                              constant: appearance.defaultInset),
      topTextFieldStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                          constant: appearance.defaultInset),
      topTextFieldStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                               constant: -appearance.defaultInset),
      
      bottomTextFieldStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                       constant: appearance.defaultInset),
      bottomTextFieldStackView.topAnchor.constraint(equalTo: topTextFieldStackView.bottomAnchor,
                                                   constant: appearance.defaultInset),
      bottomTextFieldStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                         constant: -appearance.defaultInset),
      
      resultTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: appearance.defaultInset),
      resultTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -appearance.defaultInset),
      resultTextView.topAnchor.constraint(equalTo: bottomTextFieldStackView.bottomAnchor,
                                       constant: appearance.defaultInset),
      resultTextView.bottomAnchor.constraint(equalTo: scrollResult.topAnchor,
                                          constant: -appearance.defaultInset),
      
      rangeStartTextField.widthAnchor.constraint(equalTo: rangeEndTextField.widthAnchor),
      betweenRangeLabel.widthAnchor.constraint(equalToConstant: appearance.defaultInset),
      amountNumberLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: appearance.minWidthLabel),
      rangeNumberLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: appearance.minWidthLabel),
      
      scrollResult.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollResult.trailingAnchor.constraint(equalTo: trailingAnchor),
      scrollResult.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                           constant: -appearance.minInset),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: appearance.defaultInset),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.defaultInset),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.defaultInset)
    ])
  }
  
  @objc
  func generateButtonAction() {
    output?.generateButtonAction(rangeStartValue: rangeStartTextField.text,
                                 rangeEndValue: rangeEndTextField.text,
                                 amountNumberValue: amountNumberTextField.text)
  }
  
  @objc
  func resultAction() {
    output?.resultLabelAction()
  }
}

// MARK: - Appearance

private extension LotteryScreenView {
  struct Appearance {
    let startPlaceholder = "1"
    let separatorTitle = " - "
    let endPlaceholder = "100"
    
    let minInset: CGFloat = 8
    let defaultInset: CGFloat = 16
    let maxInset: CGFloat = 24
    
    let resultNumberOfLines: Int = 5
    let resultDuration: CGFloat = 0.2
    let minWidthLabel: CGFloat = 112

    let buttonTitle = NSLocalizedString("Сгенерировать", comment: "")
    let textRangeLabel = NSLocalizedString("Диапазон", comment: "")
    let textAmountLabel = NSLocalizedString("Количество", comment: "")
  }
}
