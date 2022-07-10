//
//  NumberScreenView.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 09.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

protocol NumberScreenViewOutput: AnyObject {
  
  /// Кнопка нажата пользователем
  /// - Parameters:
  ///  - rangeStartValue: Первый textField
  ///  - rangeEndValue: Второй textField
  func generateButtonAction(rangeStartValue: String?,
                            rangeEndValue: String?)
  
  /// Текст в текстовом поле был изменен
  /// - Parameters:
  ///  - text: Значение для текстового поля
  func rangeStartDidChange(_ text: String?)
  
  /// Текст в текстовом поле был изменен
  /// - Parameters:
  ///  - text: Значение для текстового поля
  func rangeEndDidChange(_ text: String?)
  
  /// Было нажатие на результат генерации
  ///  - Parameter text: Результат генерации
  func resultLabelAction(text: String?)
}

protocol NumberScreenViewInput: AnyObject {
  
  /// Устанавливаем данные для первого и второго поля ввода числа
  /// - Parameters:
  ///  - rangeStartValue: Первый textField
  ///  - rangeEndValue: Второй textField
  func set(rangeStartValue: String?,
           rangeEndValue: String?)
  
  /// Устанавливаем данные в result
  ///  - Parameter result: результат генерации
  func set(result: String?)
  
  /// Устанавливает список результатов
  ///  - Parameter listResult: массив результатов
  func set(listResult: [String])
  
  /// Устанавливает значение в текстовое поле
  ///  - Parameter text: Значение для текстового поля
  func setRangeStart(_ text: String?)
  
  /// Устанавливает значение в текстовое поле
  ///  - Parameter text: Значение для текстового поля
  func setRangeEnd(_ text: String?)
}

typealias NumberScreenViewProtocol = UIView & NumberScreenViewInput

final class NumberScreenView: NumberScreenViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: NumberScreenViewOutput?
  
  var keyboardService: KeyboardService? {
    didSet {
      keyboardService?.keyboardHeightChangeAction = { [weak self] keyboardHeight in
        self?.scrollView.contentInset = UIEdgeInsets(top: .zero,
                                                     left: .zero,
                                                     bottom: keyboardHeight,
                                                     right: .zero)
      }
    }
  }
  
  private let rangeStartTextField = TextFieldView()
  private let rangeEndTextField = TextFieldView()
  private let textFieldStackView = UIStackView()
  private let resultLabel = UILabel()
  private let scrollResultView = ScrollLabelGradientView()
  private let generateButton = ButtonView()
  
  private let scrollView = UIScrollView()
  private let contentView = UIView()
  
  // MARK: - Internal func
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupConstraints()
    setupDefaultSettings()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func set(rangeStartValue: String?,
           rangeEndValue: String?) {
    rangeStartTextField.text = rangeStartValue
    rangeEndTextField.text = rangeEndValue
  }
  
  func set(result: String?) {
    resultLabel.text = result
  }
  
  func set(listResult: [String]) {
    scrollResultView.listLabels = listResult
  }
  
  func setRangeStart(_ text: String?) {
    rangeStartTextField.text = text
  }
  
  func setRangeEnd(_ text: String?) {
    rangeEndTextField.text = text
  }
  
  // MARK: - Private func
  
  private func setupDefaultSettings() {
    let appearance = Appearance()
    
    backgroundColor = RandomColor.secondaryWhite
    
    resultLabel.font = RandomFont.primaryBold70
    resultLabel.textColor = RandomColor.primaryGray
    resultLabel.textAlignment = .center
    resultLabel.numberOfLines = .zero
    
    generateButton.setTitle(appearance.setTextButton, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
    
    textFieldStackView.axis = .horizontal
    textFieldStackView.spacing = appearance.spacing
    textFieldStackView.distribution = .fillEqually
    
    rangeStartTextField.placeholder = appearance.rangeStartValue
    rangeStartTextField.delegate = self
    rangeStartTextField.keyboardType = .numberPad
    
    rangeEndTextField.placeholder = appearance.rangeEndValue
    rangeEndTextField.delegate = self
    rangeEndTextField.keyboardType = .numberPad
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
    tap.cancelsTouchesInView = false
    addGestureRecognizer(tap)
    isUserInteractionEnabled = true
    
    let resultLabelTap = UITapGestureRecognizer(target: self, action: #selector(resultLabelAction))
    resultLabelTap.cancelsTouchesInView = false
    resultLabel.addGestureRecognizer(resultLabelTap)
    resultLabel.isUserInteractionEnabled = true
  }
  
  @objc
  private func generateButtonAction() {
    output?.generateButtonAction(rangeStartValue: rangeStartTextField.text,
                                 rangeEndValue: rangeEndTextField.text)
  }
  
  @objc
  private func resultLabelAction() {
    output?.resultLabelAction(text: resultLabel.text)
  }
  
  private func setupConstraints() {
    let appearance = Appearance()
    
    [scrollView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    [contentView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      scrollView.addSubview($0)
    }
    
    [textFieldStackView, resultLabel, scrollResultView, generateButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    [rangeStartTextField, rangeEndTextField].forEach {
      textFieldStackView.addArrangedSubview($0)
    }
    
    NSLayoutConstraint.activate([
      scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
      
      resultLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.middleHorizontalSpacing),
      resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.middleHorizontalSpacing),
      
      generateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                              constant: appearance.middleHorizontalSpacing),
      generateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                               constant: -appearance.middleHorizontalSpacing),
      generateButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                             constant: -appearance.middleHorizontalSpacing),
      
      scrollResultView.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                               constant: -appearance.lessVerticalSpacing),
      scrollResultView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      scrollResultView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      
      textFieldStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                  constant: appearance.middleHorizontalSpacing),
      textFieldStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                   constant: -appearance.middleHorizontalSpacing),
      textFieldStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                              constant: appearance.middleVirticalSpacing)
    ])
  }
}

// MARK: - UITextFieldDelegate

extension NumberScreenView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    rangeStartTextField.resignFirstResponder()
    rangeEndTextField.resignFirstResponder()
    return true
  }
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    
    if range.location >= 11 {
      return false
    }
    return true
  }
  
  func textFieldDidChangeSelection(_ textField: UITextField) {
    if rangeStartTextField == textField {
      output?.rangeStartDidChange(textField.text)
    } else {
      output?.rangeEndDidChange(textField.text)
    }
  }
}

// MARK: - Appearance

private extension NumberScreenView {
  struct Appearance {
    let setTextButton = NSLocalizedString("Сгенерировать", comment: "")
    let spacing: CGFloat = 28
    let rangeStartValue = "1"
    let rangeEndValue = "999 999 999"
    let middleHorizontalSpacing: CGFloat = 16
    let lessVerticalSpacing: CGFloat = 8
    let middleVirticalSpacing: CGFloat = 12
    let largeVerticalSpacing: CGFloat = 24
  }
}
