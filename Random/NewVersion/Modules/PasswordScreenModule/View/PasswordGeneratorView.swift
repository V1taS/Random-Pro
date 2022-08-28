//
//  PasswordGeneratorView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 04.08.2022.
//

import UIKit
import RandomUIKit

final class PasswordGeneratorView: UIView {
  
  // MARK: - Internal properties
  
  let passwordLengthTextField = TextFieldView()
  let resultTextView = UITextView()
  
  let uppercaseLettersSwitch = UISwitch()
  let lowercaseLettersSwitch = UISwitch()
  let numbersSwitch = UISwitch()
  let symbolsSwitch = UISwitch()
  
  // MARK: - Private properties
  
  private let settingOptionsLabel = UILabel()
  private let uppercaseLettersLabel = UILabel()
  private let lowercaseLettersLabel = UILabel()
  private let numbersLabel = UILabel()
  private let symbolsLabel = UILabel()
  
  private let passwordLengthLabel = UILabel()
  
  private let labelsStackView = UIStackView()
  private let switchersStackView = UIStackView()
  private let textFieldStackView = UIStackView()
  private let generalStackView = UIStackView()
  
  private var uppercaseSwitchAction: ((Bool) -> Void)?
  private var lowercaseSwitchAction: ((Bool) -> Void)?
  private var numbersSwitchAction: ((Bool) -> Void)?
  private var symbolsSwitchAction: ((Bool) -> Void)?
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  /// Конфигурируем ячейку
  /// - Parameters:
  ///  - uppercaseSwitchAction: Переключатель прописных букв
  ///  - lowercaseSwitchAction: Переключатель строчных букв
  ///  - numbersSwitchAction: Переключатель цифр
  ///  - symbolsSwitchAction: Переключатель Символов
  func configureViewWith(uppercaseSwitchAction: ((Bool) -> Void)?,
                         lowercaseSwitchAction: ((Bool) -> Void)?,
                         numbersSwitchAction: ((Bool) -> Void)?,
                         symbolsSwitchAction: ((Bool) -> Void)?) {
    self.uppercaseSwitchAction = uppercaseSwitchAction
    self.lowercaseSwitchAction = lowercaseSwitchAction
    self.numbersSwitchAction = numbersSwitchAction
    self.symbolsSwitchAction = symbolsSwitchAction
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [uppercaseLettersLabel, lowercaseLettersLabel, numbersLabel, symbolsLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      labelsStackView.addArrangedSubview($0)
    }
    
    [uppercaseLettersSwitch, lowercaseLettersSwitch, numbersSwitch, symbolsSwitch].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      switchersStackView.addArrangedSubview($0)
    }
    
    [passwordLengthTextField].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      textFieldStackView.addArrangedSubview($0)
    }
    
    [settingOptionsLabel, labelsStackView, switchersStackView,
     passwordLengthLabel, textFieldStackView, resultTextView, generalStackView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    [labelsStackView, switchersStackView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      generalStackView.addArrangedSubview($0)
    }
    
    NSLayoutConstraint.activate([
      settingOptionsLabel.topAnchor.constraint(equalTo: topAnchor,
                                               constant: appearance.middleHorizontalSpacing),
      settingOptionsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      
      labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: appearance.middleVirticalSpacing),
      labelsStackView.topAnchor.constraint(equalTo: settingOptionsLabel.bottomAnchor,
                                           constant: appearance.middleHorizontalSpacing),
      labelsStackView.widthAnchor.constraint(equalToConstant: appearance.widthAnchorSpacing),
      
      switchersStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: -appearance.middleVirticalSpacing),
      switchersStackView.topAnchor.constraint(equalTo:  settingOptionsLabel.bottomAnchor,
                                              constant: appearance.middleHorizontalSpacing),
      switchersStackView.widthAnchor.constraint(equalToConstant: appearance.widthAnchor),
      
      generalStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: appearance.middleHorizontalSpacing),
      generalStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -appearance.middleHorizontalSpacing),
      generalStackView.topAnchor.constraint(equalTo: settingOptionsLabel.bottomAnchor,
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
      
      resultTextView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor,
                                          constant: appearance.lessVerticalSpacing),
      resultTextView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.middleHorizontalSpacing),
      resultTextView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.middleHorizontalSpacing),
      resultTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.lessVerticalSpacing)
    ])
  }
  
  private func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.primaryWhite
    
    settingOptionsLabel.text = appearance.parameters + ":"
    settingOptionsLabel.textColor = RandomColor.primaryGray
    settingOptionsLabel.font = RandomFont.primaryBold18
    settingOptionsLabel.numberOfLines = 1
    
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
    
    switchersStackView.axis = .vertical
    switchersStackView.distribution = .fillEqually
    switchersStackView.spacing = appearance.lessVerticalSpacing
    
    uppercaseLettersSwitch.isOn = true
    uppercaseLettersSwitch.addTarget(self, action: #selector(uppercaseSwitchValueDidChange(_:)), for: .valueChanged)
    
    lowercaseLettersSwitch.isOn = true
    lowercaseLettersSwitch.addTarget(self, action:#selector(lowercaseSwitchValueDidChange(_:)), for: .valueChanged)
    
    numbersSwitch.isOn = true
    numbersSwitch.addTarget(self, action: #selector(numbersSwitchValueDidChange(_:)), for: .valueChanged)
    
    symbolsSwitch.isOn = true
    symbolsSwitch.addTarget(self, action: #selector(symbolsSwitchValueDidChange(_:)), for: .valueChanged)
    
    passwordLengthLabel.text = appearance.longPassword + ":"
    passwordLengthLabel.textColor = RandomColor.primaryGray
    passwordLengthLabel.font = RandomFont.primaryBold18
    
    textFieldStackView.axis = .horizontal
    textFieldStackView.spacing = appearance.middleHorizontalSpacing
    textFieldStackView.distribution = .fillEqually
    
    generalStackView.axis = .horizontal
    
    passwordLengthTextField.placeholder = appearance.rangeStartValue
    passwordLengthTextField.keyboardType = .numberPad
    
    resultTextView.textColor = RandomColor.primaryGray
    resultTextView.font = RandomFont.primaryMedium24
    resultTextView.textAlignment = .center
    resultTextView.isEditable = false
    
    let padding = resultTextView.textContainer.lineFragmentPadding
    resultTextView.textContainerInset =  UIEdgeInsets(top: .zero,
                                                      left: -padding,
                                                      bottom: .zero,
                                                      right: -padding)
  }
  
  @objc
  private func uppercaseSwitchValueDidChange(_ sender: UISwitch) {
    uppercaseSwitchAction?(sender.isOn)
  }
  
  @objc
  private func lowercaseSwitchValueDidChange(_ sender: UISwitch) {
    lowercaseSwitchAction?(sender.isOn)
  }
  
  @objc
  private func numbersSwitchValueDidChange(_ sender: UISwitch) {
    numbersSwitchAction?(sender.isOn)
  }
  
  @objc
  private func symbolsSwitchValueDidChange(_ sender: UISwitch) {
    symbolsSwitchAction?(sender.isOn)
  }
}

// MARK: - Appearance

private extension PasswordGeneratorView {
  struct Appearance {
    let parameters = NSLocalizedString("Параметры", comment: "")
    let longPassword = NSLocalizedString("Длина пароля", comment: "")
    let uppercase = NSLocalizedString("Прописные буквы", comment: "")
    let lovercase = NSLocalizedString("Строчные буквы", comment: "")
    let numbers = NSLocalizedString("Цифры", comment: "")
    let symbols = NSLocalizedString("Символы", comment: "")
    let spacing: CGFloat = 18
    let rangeStartValue = "9 999"
    let middleHorizontalSpacing: CGFloat = 16
    let lessVerticalSpacing: CGFloat = 8
    let middleVirticalSpacing: CGFloat = 40
    let largeVerticalSpacing: CGFloat = 26
    let widthAnchor: CGFloat = 60
    let widthAnchorSpacing: CGFloat = 200
  }
}
