//
//  PasswordGeneratorView.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 04.08.2022.
//

import UIKit
import RandomUIKit

/// View для экрана
final class PasswordGeneratorView: UIView {
  
  // MARK: - Private properties
  
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
  private let generalStackView = UIStackView()
  
  private let resultLabel = UILabel()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public func
  
  // MARK: - Internal func
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
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
    }
    
    [optionsLabel, labelsStackView, switcherStackView,
     passwordLengthLabel, textFieldStackView, resultLabel, generalStackView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    [labelsStackView, switcherStackView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      generalStackView.addArrangedSubview($0)
    }
    
    NSLayoutConstraint.activate([
      optionsLabel.topAnchor.constraint(equalTo: topAnchor,
                                        constant: appearance.middleHorizontalSpacing),
      optionsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      
      labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: appearance.middleVirticalSpacing),
      labelsStackView.topAnchor.constraint(equalTo: optionsLabel.bottomAnchor,
                                           constant: appearance.middleHorizontalSpacing),
      labelsStackView.widthAnchor.constraint(equalToConstant: appearance.widthAnchorSpacing),
      
      switcherStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                  constant: -appearance.middleHorizontalSpacing),
      switcherStackView.topAnchor.constraint(equalTo:  optionsLabel.bottomAnchor,
                                             constant: appearance.middleHorizontalSpacing),
      switcherStackView.widthAnchor.constraint(equalToConstant: appearance.widthAnchor),
      
      generalStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: appearance.middleHorizontalSpacing),
      generalStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -appearance.middleHorizontalSpacing),
      generalStackView.topAnchor.constraint(equalTo: optionsLabel.bottomAnchor,
                                            constant: appearance.middleHorizontalSpacing),
      
      passwordLengthLabel.topAnchor.constraint(equalTo: generalStackView.bottomAnchor,
                                               constant: appearance.middleHorizontalSpacing),
      passwordLengthLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      
      textFieldStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                  constant: appearance.middleHorizontalSpacing),
      textFieldStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: -appearance.middleHorizontalSpacing),
      textFieldStackView.topAnchor.constraint(equalTo: passwordLengthLabel.bottomAnchor,
                                              constant: appearance.middleHorizontalSpacing),
      
      resultLabel.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor,
                                       constant: appearance.middleHorizontalSpacing),
      resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.middleHorizontalSpacing),
      resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.middleHorizontalSpacing)
    ])
  }
  
  private func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.secondaryWhite
    
    optionsLabel.text = appearance.parameters
    optionsLabel.textColor = RandomColor.primaryGray
    optionsLabel.font = RandomFont.primaryBold18
    
    labelsStackView.axis = .vertical
    labelsStackView.distribution = .fillEqually
    labelsStackView.spacing = appearance.spacing
    
    uppercaseLettersLabel.text = appearance.uppercase
    uppercaseLettersLabel.textColor = RandomColor.primaryGray
    uppercaseLettersLabel.font = RandomFont.primaryMedium18
    
    lowercaseLettersLabel.text = appearance.lovercase
    lowercaseLettersLabel.textColor = RandomColor.primaryGray
    lowercaseLettersLabel.font = RandomFont.primaryMedium18
    
    numbersLabel.text = appearance.numbers
    numbersLabel.textColor = RandomColor.primaryGray
    numbersLabel.font = RandomFont.primaryMedium18
    
    symbolsLabel.text = appearance.symbols
    symbolsLabel.textColor = RandomColor.primaryGray
    symbolsLabel.font = RandomFont.primaryMedium18
    
    switcherStackView.axis = .vertical
    switcherStackView.distribution = .fillEqually
    switcherStackView.spacing = appearance.lessVerticalSpacing
    
    uppercaseLettersSwitch.isOn = true
    uppercaseLettersSwitch.addTarget(self, action: #selector(uppercaseSwitchValueDidChange(_:)), for: .valueChanged)
    
    lowercaseLettersSwitch.isOn = true
    lowercaseLettersSwitch.addTarget(self, action:#selector(lowercaseSwitchValueDidChange(_:)), for: .valueChanged)
    
    numbersSwitch.isOn = true
    numbersSwitch.addTarget(self, action: #selector(numbersSwitchValueDidChange(_:)), for: .valueChanged)
    
    symbolsSwitch.isOn = true
    symbolsSwitch.addTarget(self, action: #selector(symbolsSwitchValueDidChange(_:)), for: .valueChanged)
    
    passwordLengthLabel.text = appearance.longPassword
    passwordLengthLabel.textColor = RandomColor.primaryGray
    passwordLengthLabel.font = RandomFont.primaryBold18
    
    textFieldStackView.axis = .horizontal
    textFieldStackView.spacing = appearance.middleHorizontalSpacing
    textFieldStackView.distribution = .fillEqually
    
    generalStackView.axis = .horizontal
    generalStackView.distribution = .fill
    
    rangeStartTextField.placeholder = appearance.rangeStartValue
    rangeStartTextField.delegate = self
    
    rangeEndTextField.placeholder = appearance.rangeEndValue
    rangeEndTextField.delegate = self
    
    resultLabel.text = appearance.resultLabel
    resultLabel.textColor = RandomColor.primaryGray
    resultLabel.font = RandomFont.primaryBold50
    resultLabel.textAlignment = .center
  }
  
  @objc private func uppercaseSwitchValueDidChange(_ sender: UISwitch) {
    
  }
  
  @objc private func lowercaseSwitchValueDidChange(_ sender: UISwitch) {
    
  }
  
  @objc private func numbersSwitchValueDidChange(_ sender: UISwitch) {
    
  }
  
  @objc private func symbolsSwitchValueDidChange(_ sender: UISwitch) {
    
  }
}

// MARK: - UITextFieldDelegate

extension PasswordGeneratorView: UITextFieldDelegate {
  
}

// MARK: - Appearance

private extension PasswordGeneratorView {
  struct Appearance {
    let parameters = NSLocalizedString("Параметры:", comment: "")
    let longPassword = NSLocalizedString("Длина пароля:", comment: "")
    let uppercase = NSLocalizedString("Прописные буквы", comment: "")
    let lovercase = NSLocalizedString("Строчные буквы", comment: "")
    let numbers = NSLocalizedString("Цифры", comment: "")
    let symbols = NSLocalizedString("Символы", comment: "")
    let resultLabel = "?"
    let spacing: CGFloat = 18
    let rangeStartValue = "1"
    let rangeEndValue = "60"
    let middleHorizontalSpacing: CGFloat = 16
    let lessVerticalSpacing: CGFloat = 8
    let middleVirticalSpacing: CGFloat = 40
    let largeVerticalSpacing: CGFloat = 26
    let widthAnchor: CGFloat = 100
    let widthAnchorSpacing: CGFloat = 200
  }
}
