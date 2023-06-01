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
  let resultTextView = TextView()
  
  let uppercaseLettersSwitch = UISwitch()
  let lowercaseLettersSwitch = UISwitch()
  let numbersSwitch = UISwitch()
  let symbolsSwitch = UISwitch()
  var resultLabelAction: (() -> Void)?
  
  var crackTimeStrengthValue: Float = .zero {
    didSet {
      crackTimeSlider.setValue(crackTimeStrengthValue, animated: true)
      switch crackTimeStrengthValue {
      case 0.0...0.2:
        crackTimeSlider.minimumTrackTintColor = RandomColor.only.primaryRed
      case 0.2...0.4:
        crackTimeSlider.minimumTrackTintColor = RandomColor.only.primaryOrange
      case 0.4...0.7:
        crackTimeSlider.minimumTrackTintColor = RandomColor.only.primaryYellow
      case 0.7...1.0:
        crackTimeSlider.minimumTrackTintColor = RandomColor.only.primaryGreen
      default:
        crackTimeSlider.minimumTrackTintColor = RandomColor.only.primaryGray
      }
    }
  }
  
  var crackTimeisHidden: Bool = true {
    didSet {
      crackTimeLabel.isHidden = crackTimeisHidden
      crackTimeSlider.isHidden = crackTimeisHidden
    }
  }
  
  var crackTimeTitle: String? {
    didSet {
      crackTimeLabel.text = crackTimeTitle
    }
  }
  
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
  
  private let crackTimeLabel = UILabel()
  private let crackTimeSlider = ColorSlider()
  
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
}

// MARK: - Private

private extension PasswordGeneratorView {
  func configureLayout() {
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
    
    [settingOptionsLabel, labelsStackView, switchersStackView, passwordLengthLabel, textFieldStackView,
     generalStackView, crackTimeLabel, crackTimeSlider, resultTextView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    [labelsStackView, switchersStackView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      generalStackView.addArrangedSubview($0)
    }
    
    NSLayoutConstraint.activate([
      settingOptionsLabel.topAnchor.constraint(equalTo: topAnchor,
                                               constant: appearance.defaultSpacing),
      settingOptionsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      
      labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: appearance.defaultSpacing),
      labelsStackView.topAnchor.constraint(equalTo: settingOptionsLabel.bottomAnchor,
                                           constant: appearance.defaultSpacing),
      labelsStackView.widthAnchor.constraint(equalTo: switchersStackView.widthAnchor),
      
      switchersStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: -appearance.defaultSpacing),
      switchersStackView.topAnchor.constraint(equalTo: settingOptionsLabel.bottomAnchor,
                                              constant: appearance.defaultSpacing),
      
      generalStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: appearance.defaultSpacing),
      generalStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -appearance.defaultSpacing),
      generalStackView.topAnchor.constraint(equalTo: settingOptionsLabel.bottomAnchor,
                                            constant: appearance.defaultSpacing),
      
      passwordLengthLabel.topAnchor.constraint(equalTo: generalStackView.bottomAnchor,
                                               constant: appearance.defaultSpacing),
      passwordLengthLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      
      textFieldStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                  constant: appearance.defaultSpacing),
      textFieldStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                   constant: -appearance.defaultSpacing),
      textFieldStackView.topAnchor.constraint(equalTo: passwordLengthLabel.bottomAnchor,
                                              constant: appearance.defaultSpacing),
      
      crackTimeLabel.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor,
                                          constant: appearance.defaultSpacing),
      crackTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.defaultSpacing),
      crackTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.defaultSpacing),
      
      crackTimeSlider.topAnchor.constraint(equalTo: crackTimeLabel.bottomAnchor,
                                           constant: appearance.minSpacing / 2),
      crackTimeSlider.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: appearance.defaultSpacing),
      crackTimeSlider.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -appearance.defaultSpacing),
      
      resultTextView.topAnchor.constraint(equalTo: crackTimeSlider.bottomAnchor),
      resultTextView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.defaultSpacing),
      resultTextView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.defaultSpacing),
      resultTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.minSpacing)
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    
    crackTimeLabel.font = RandomFont.primaryBold18
    crackTimeLabel.numberOfLines = 2
    crackTimeLabel.textAlignment = .center
    crackTimeLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
    crackTimeisHidden = true
    
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    passwordLengthTextField.layer.borderColor = RandomColor.darkAndLightTheme.secondaryGray.cgColor
    
    settingOptionsLabel.text = appearance.parameters + ":"
    settingOptionsLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
    settingOptionsLabel.font = RandomFont.primaryBold18
    settingOptionsLabel.numberOfLines = 1
    
    labelsStackView.axis = .vertical
    labelsStackView.distribution = .fillEqually
    labelsStackView.spacing = appearance.defaultSpacing
    
    uppercaseLettersLabel.text = appearance.uppercase
    uppercaseLettersLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
    uppercaseLettersLabel.font = RandomFont.primaryMedium18
    
    lowercaseLettersLabel.text = appearance.lovercase
    lowercaseLettersLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
    lowercaseLettersLabel.font = RandomFont.primaryMedium18
    
    numbersLabel.text = appearance.numbers
    numbersLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
    numbersLabel.font = RandomFont.primaryMedium18
    
    symbolsLabel.text = appearance.symbols
    symbolsLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
    symbolsLabel.font = RandomFont.primaryMedium18
    
    switchersStackView.axis = .vertical
    switchersStackView.alignment = .trailing
    switchersStackView.spacing = appearance.minSpacing
    
    uppercaseLettersSwitch.isOn = true
    uppercaseLettersSwitch.addTarget(self,
                                     action: #selector(uppercaseSwitchValueDidChange(_:)),
                                     for: .valueChanged)
    
    lowercaseLettersSwitch.isOn = true
    lowercaseLettersSwitch.addTarget(self,
                                     action: #selector(lowercaseSwitchValueDidChange(_:)),
                                     for: .valueChanged)
    
    numbersSwitch.isOn = true
    numbersSwitch.addTarget(self,
                            action: #selector(numbersSwitchValueDidChange(_:)),
                            for: .valueChanged)
    
    symbolsSwitch.isOn = true
    symbolsSwitch.addTarget(self,
                            action: #selector(symbolsSwitchValueDidChange(_:)),
                            for: .valueChanged)
    
    passwordLengthLabel.text = appearance.longPassword + ":"
    passwordLengthLabel.textColor = RandomColor.darkAndLightTheme.primaryGray
    passwordLengthLabel.font = RandomFont.primaryBold18
    
    textFieldStackView.axis = .horizontal
    textFieldStackView.spacing = appearance.defaultSpacing
    textFieldStackView.distribution = .fillEqually
    
    generalStackView.axis = .horizontal
    
    passwordLengthTextField.placeholder = appearance.rangeStartValue
    passwordLengthTextField.keyboardType = .numberPad
    
    resultTextView.backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    resultTextView.font = RandomFont.primaryMedium24
    resultTextView.textAlignment = .center
    resultTextView.isEditable = false
    resultTextView.isSelectable = false
    
    resultTextView.onTextTap = { [weak self] in
      self?.resultLabelAction?()
    }
  }
  
  @objc
  func uppercaseSwitchValueDidChange(_ sender: UISwitch) {
    uppercaseSwitchAction?(sender.isOn)
  }
  
  @objc
  func lowercaseSwitchValueDidChange(_ sender: UISwitch) {
    lowercaseSwitchAction?(sender.isOn)
  }
  
  @objc
  func numbersSwitchValueDidChange(_ sender: UISwitch) {
    numbersSwitchAction?(sender.isOn)
  }
  
  @objc
  func symbolsSwitchValueDidChange(_ sender: UISwitch) {
    symbolsSwitchAction?(sender.isOn)
  }
}

// MARK: - Appearance

private extension PasswordGeneratorView {
  struct Appearance {
    let parameters = RandomStrings.Localizable.parameters
    let longPassword = RandomStrings.Localizable.passwordLength
    let uppercase = RandomStrings.Localizable.uppercaseLetters
    let lovercase = RandomStrings.Localizable.lowercaseLetters
    let numbers = RandomStrings.Localizable.numbers
    let symbols = RandomStrings.Localizable.symbols
    let rangeStartValue = "9 999"
    let defaultSpacing: CGFloat = 16
    let minSpacing: CGFloat = 8
    let largeSpacing: CGFloat = 40
    let midSpacing: CGFloat = 26
    let widthAnchorSpacing: CGFloat = 200
  }
}
