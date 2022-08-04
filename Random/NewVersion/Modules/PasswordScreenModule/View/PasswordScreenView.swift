//
//  PasswordScreenView.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 04.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

protocol PasswordScreenViewOutput: AnyObject {
  
}

protocol PasswordScreenViewInput: AnyObject {
  
}

typealias PasswordScreenViewProtocol = UIView & PasswordScreenViewInput

final class PasswordScreenView: PasswordScreenViewProtocol {
  
  weak var output: PasswordScreenViewOutput?
  
  private let passwordSegmentedControl = UISegmentedControl()
  
  private let optionsLabel = UILabel()
  private let uppercaseLettersLabel = UILabel()
  private let lowercaseLettersLabel = UILabel()
  private let numbersLabel = UILabel()
  private let symbolsLabel = UILabel()
  
  private let uppercaseLettersSwitch = UISwitch()
  private let lowercaseLettersSwitch = UISwitch()
  private let numbersSwitch = UISwitch()
  private let symbolsSwitch = UISwitch()
  
  private let passwordLengthLabel = UILabel()
  private let rangeStartTextField = TextFieldView()
  private let rangeEndTextField = TextFieldView()
  
  private let labelsStackView = UIStackView()
  private let switcherStackView = UIStackView()
  private let textFieldStackView = UIStackView()
  
  private let resultLabel = UILabel()
  private let genarateButton = ButtonView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupDefaultSettings()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupDefaultSettings() {
    let appearance = Appearance()
    backgroundColor = RandomColor.secondaryWhite
    
    passwordSegmentedControl.insertSegment(withTitle: "Генератор паролей", at: 0, animated: false)
    passwordSegmentedControl.insertSegment(withTitle: "Фраза пароль", at: 1, animated: false)
    passwordSegmentedControl.selectedSegmentIndex = 0
    
    optionsLabel.text = "Параметры:"
    optionsLabel.textColor = RandomColor.primaryGray
    optionsLabel.font = RandomFont.primaryBold18
    
    labelsStackView.axis = .vertical
    labelsStackView.distribution = .fillEqually
    labelsStackView.spacing = 18
    
    uppercaseLettersLabel.text = "Прописные буквы"
    uppercaseLettersLabel.textColor = RandomColor.primaryGray
    uppercaseLettersLabel.font = RandomFont.primaryMedium18
    
    lowercaseLettersLabel.text = "Строчные буквы"
    lowercaseLettersLabel.textColor = RandomColor.primaryGray
    lowercaseLettersLabel.font = RandomFont.primaryMedium18
    
    numbersLabel.text = "Цифры"
    numbersLabel.textColor = RandomColor.primaryGray
    numbersLabel.font = RandomFont.primaryMedium18
    
    symbolsLabel.text = "Символы"
    symbolsLabel.textColor = RandomColor.primaryGray
    symbolsLabel.font = RandomFont.primaryMedium18
    
    switcherStackView.axis = .vertical
    switcherStackView.distribution = .fillEqually
    switcherStackView.spacing = 8
    
    uppercaseLettersSwitch.isOn = true
    uppercaseLettersSwitch.addTarget(self, action: #selector(uppercaseSwitchValueDidChange(_:)), for: .valueChanged)
    
    lowercaseLettersSwitch.isOn = true
    lowercaseLettersSwitch.addTarget(self, action:#selector(lowercaseSwitchValueDidChange(_:)), for: .valueChanged)
    
    numbersSwitch.isOn = true
    numbersSwitch.addTarget(self, action: #selector(numbersSwitchValueDidChange(_:)), for: .valueChanged)
    
    symbolsSwitch.isOn = true
    symbolsSwitch.addTarget(self, action: #selector(symbolsSwitchValueDidChange(_:)), for: .valueChanged)
    
    passwordLengthLabel.text = "Длина пароля:"
    passwordLengthLabel.textColor = RandomColor.primaryGray
    passwordLengthLabel.font = RandomFont.primaryBold18
    
    textFieldStackView.axis = .horizontal
    textFieldStackView.spacing = 16
    textFieldStackView.distribution = .fillEqually
    
    rangeStartTextField.placeholder = appearance.rangeStartValue
    rangeStartTextField.delegate = self
    
    rangeEndTextField.placeholder = appearance.rangeEndValue
    rangeEndTextField.delegate = self
    
    resultLabel.text = "?"
    resultLabel.textColor = RandomColor.primaryGray
    resultLabel.font = RandomFont.primaryBold50
    
    genarateButton.setTitle("Сгенерировать", for: .normal)
    genarateButton.addTarget(self, action: #selector(genarateButtonAction), for: .touchUpInside)
  }
  
  @objc private func uppercaseSwitchValueDidChange(_ sender: UISwitch) {
 
  }
  
  @objc private func lowercaseSwitchValueDidChange(_ sender: UISwitch) {
    
  }
  
  @objc private func numbersSwitchValueDidChange(_ sender: UISwitch) {
    
  }
  
  @objc private func symbolsSwitchValueDidChange(_ sender: UISwitch) {
    
  }
  
  @objc private func genarateButtonAction() {
    
  }
  
  private func setupConstraints() {
    [passwordSegmentedControl, optionsLabel, labelsStackView, switcherStackView,
     passwordLengthLabel, textFieldStackView, resultLabel, genarateButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    [uppercaseLettersLabel, lowercaseLettersLabel, numbersLabel, symbolsLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      labelsStackView.addArrangedSubview($0)
    }
    
    [uppercaseLettersSwitch, lowercaseLettersSwitch, numbersSwitch, symbolsSwitch].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      switcherStackView.addArrangedSubview($0)
    }
    
    [rangeStartTextField, rangeEndTextField].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      textFieldStackView.addArrangedSubview($0)
    
    NSLayoutConstraint.activate([
      passwordSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      passwordSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      passwordSegmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      
      optionsLabel.topAnchor.constraint(equalTo: passwordSegmentedControl.bottomAnchor, constant: 16),
      optionsLabel.heightAnchor.constraint(equalToConstant: 26),
      optionsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      
      labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
      labelsStackView.topAnchor.constraint(equalTo: optionsLabel.bottomAnchor, constant: 16),
      labelsStackView.widthAnchor.constraint(equalToConstant: 200),
      
      switcherStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      switcherStackView.topAnchor.constraint(equalTo:  optionsLabel.bottomAnchor, constant: 16),
      switcherStackView.widthAnchor.constraint(equalToConstant: 100),
      
      passwordLengthLabel.topAnchor.constraint(equalTo: labelsStackView.bottomAnchor, constant: 16),
      passwordLengthLabel.heightAnchor.constraint(equalToConstant: 26),
      passwordLengthLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      
      textFieldStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      textFieldStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      textFieldStackView.topAnchor.constraint(equalTo: passwordLengthLabel.bottomAnchor, constant: 16),
      
      resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      resultLabel.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 16),
      
      genarateButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      genarateButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      genarateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
     
    ])
  }
  }
}

extension PasswordScreenView: UITextFieldDelegate {
//  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//    rangeStartTextField.resignFirstResponder()
//    rangeEndTextField.resignFirstResponder()
//    return true
  }
  
//  func textField(_ textField: UITextField,
//                 shouldChangeCharactersIn range: NSRange,
//                 replacementString string: String) -> Bool {
//
//    if range.location >= 11 {
//      return false
//    }
//    return true
//  }
  
//  func textFieldDidChangeSelection(_ textField: UITextField) {
//    if rangeStartTextField == textField {
//      output?.rangeStartDidChange(textField.text)
//    } else {
//      output?.rangeEndDidChange(textField.text)
//    }
//  }


// MARK: - Appearance

private extension PasswordScreenView {
  struct Appearance {
    let setTextButton = NSLocalizedString("Сгенерировать", comment: "")
    let spacing: CGFloat = 28
    let rangeStartValue = "1"
    let rangeEndValue = "60"
    let middleHorizontalSpacing: CGFloat = 16
    let lessVerticalSpacing: CGFloat = 8
    let middleVirticalSpacing: CGFloat = 12
    let largeVerticalSpacing: CGFloat = 24
  }
}
