//
//  NumberScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 09.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
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
}

/// События которые отправляем от Presenter ко View
protocol NumberScreenViewInput {
  
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
  
  private let rangeStartTextField = TextFieldView()
  private let rangeEndTextField = TextFieldView()
  private let textFieldStackView = UIStackView()
  
  private let rangeStartLabel = UILabel()
  private let rangeEndLabel = UILabel()
  
  private let resultLabel = UILabel()
  private let scrollResultView = ScrollLabelGradientView()
  private let generateButton = ButtonView()
  
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
  
  func set(result: String?) {
    resultLabel.text = result
    resultLabel.zoomIn(duration: Appearance().resultDuration,
                       transformScale: CGAffineTransform(scaleX: .zero, y: .zero))
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

// MARK: - Private

private extension NumberScreenView {
  func setupDefaultSettings() {
    let appearance = Appearance()
    rangeStartTextField.layer.borderColor = RandomColor.secondaryGray.cgColor
    rangeEndTextField.layer.borderColor = RandomColor.secondaryGray.cgColor
    backgroundColor = RandomColor.primaryWhite
    
    resultLabel.font = RandomFont.primaryBold70
    resultLabel.textColor = RandomColor.primaryGray
    resultLabel.textAlignment = .center
    resultLabel.numberOfLines = .zero
    
    generateButton.setTitle(appearance.buttonTitle, for: .normal)
    generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
    
    textFieldStackView.axis = .horizontal
    textFieldStackView.spacing = appearance.stackInset
    textFieldStackView.distribution = .fillEqually
    
    rangeStartTextField.placeholder = appearance.rangeStartValue
    rangeStartTextField.delegate = self
    rangeStartTextField.keyboardType = .numberPad
    
    rangeEndTextField.placeholder = appearance.rangeEndValue
    rangeEndTextField.delegate = self
    rangeEndTextField.keyboardType = .numberPad
    
    rangeStartLabel.text = appearance.min
    rangeStartLabel.textColor = RandomColor.primaryGray
    rangeStartLabel.font = RandomFont.primaryMedium18
    
    rangeEndLabel.text = appearance.max
    rangeEndLabel.textColor = RandomColor.primaryGray
    rangeEndLabel.font = RandomFont.primaryMedium18
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
    tap.cancelsTouchesInView = false
    addGestureRecognizer(tap)
    isUserInteractionEnabled = true
  }
  
  func setupConstraints() {
    let appearance = Appearance()
    
    [textFieldStackView, resultLabel, scrollResultView, generateButton, rangeStartLabel, rangeEndLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    [rangeStartTextField, rangeEndTextField].forEach {
      textFieldStackView.addArrangedSubview($0)
    }
    
    NSLayoutConstraint.activate([
      rangeStartLabel.centerXAnchor.constraint(equalTo: rangeStartTextField.centerXAnchor),
      rangeStartLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                           constant: appearance.defaultInset),
      
      rangeEndLabel.centerXAnchor.constraint(equalTo: rangeEndTextField.centerXAnchor),
      rangeEndLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                         constant: appearance.defaultInset),
      
      textFieldStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                  constant: appearance.defaultInset),
      textFieldStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: -appearance.defaultInset),
      textFieldStackView.topAnchor.constraint(equalTo: rangeStartLabel.bottomAnchor,
                                              constant: appearance.minInset),
      
      resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.defaultInset),
      resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.defaultInset),
      
      scrollResultView.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                               constant: -appearance.minInset),
      scrollResultView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollResultView.trailingAnchor.constraint(equalTo: trailingAnchor),
      
      generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.defaultInset),
      generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.defaultInset),
      generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.defaultInset)
    ])
  }
  
  @objc
  func generateButtonAction() {
    output?.generateButtonAction(rangeStartValue: rangeStartTextField.text,
                                 rangeEndValue: rangeEndTextField.text)
  }
}

// MARK: - Appearance

private extension NumberScreenView {
  struct Appearance {
    let rangeStartValue = "1"
    let rangeEndValue = "999 999 999"
    
    let stackInset: CGFloat = 28
    let defaultInset: CGFloat = 16
    let minInset: CGFloat = 8
    let midInset: CGFloat = 12
    let maxInset: CGFloat = 24
    let resultDuration: CGFloat = 0.2
    
    let buttonTitle = NSLocalizedString("Сгенерировать", comment: "")
    let min = NSLocalizedString("Мин", comment: "")
    let max = NSLocalizedString("Макс", comment: "")
  }
}
