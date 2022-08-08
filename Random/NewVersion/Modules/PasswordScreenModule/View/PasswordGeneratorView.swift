//
//  PasswordGeneratorView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 04.08.2022.
//

import UIKit
import RandomUIKit

final class PasswordGeneratorView: UIView {
  
  // MARK: - Private properties
  
  private let settingOptionsLabel = UILabel()
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
  private let switchersStackView = UIStackView()
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
    
    [rangeStartTextField, rangeEndTextField].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      textFieldStackView.addArrangedSubview($0)
    }
    
    [settingOptionsLabel, labelsStackView, switchersStackView,
     passwordLengthLabel, textFieldStackView, resultLabel, generalStackView].forEach {
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
      
      resultLabel.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor,
                                       constant: appearance.middleHorizontalSpacing),
      resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.middleHorizontalSpacing),
      resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.middleHorizontalSpacing),
      resultLabel.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor)
      
    ])
  }
  
  private func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.secondaryWhite
    
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
    
    rangeStartTextField.placeholder = appearance.rangeStartValue
    rangeStartTextField.delegate = self
    
    rangeEndTextField.placeholder = appearance.rangeEndValue
    rangeEndTextField.delegate = self
    
    resultLabel.text = appearance.resultLabel
    resultLabel.textColor = RandomColor.primaryGray
    resultLabel.font = RandomFont.primaryBold32
    resultLabel.numberOfLines = 0
    resultLabel.textAlignment = .center
    resultLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
  }
  
  @objc private func uppercaseSwitchValueDidChange(_ sender: UISwitch) {}
  
  @objc private func lowercaseSwitchValueDidChange(_ sender: UISwitch) {}
  
  @objc private func numbersSwitchValueDidChange(_ sender: UISwitch) {}
  
  @objc private func symbolsSwitchValueDidChange(_ sender: UISwitch) {}
}

// MARK: - UITextFieldDelegate

extension PasswordGeneratorView: UITextFieldDelegate {}

// MARK: - Appearance

private extension PasswordGeneratorView {
  struct Appearance {
    let parameters = NSLocalizedString("Параметры", comment: "")
    let longPassword = NSLocalizedString("Длина пароля", comment: "")
    let uppercase = NSLocalizedString("Прописные буквы", comment: "")
    let lovercase = NSLocalizedString("Строчные буквы", comment: "")
    let numbers = NSLocalizedString("Цифры", comment: "")
    let symbols = NSLocalizedString("Символы", comment: "")
    let resultLabel = "cgfkswdhalokwffdhgjklyuifgkguytdcfkgytcdk,ytdcgytdfcghjkl;lkijuhygtrdsfghjkl;dnmsklgmslk;gmlyuifgkguytdcfkgytcdk,ytdcgytdfcghjkl;lkijuhygtrdsfghjkl;dnmsklgmslk;gmlyuifgkguytdcfkgytcdk,ytdcgytdfcghjkl;lkijuhygtrdsfghjkl;dnmsklgmslk;gmlyuifgkguytdcfkgytcdk,ytdcgytdfcghjkl;lkijuhygtrdsfghjkl;dnmsklgmslk;gmlyuifgkguytdcfkgytcdk,ytdcgytdfcghjkl;lkijuhygtrdsfghjkl;dnmsklgmslk;gmlyuifgkguytdcfkgytcdk,ytdcgytdfcghjkl;lkijuhygtrdsfghjkl;dnmsklgmslk;gmlyuifgkguytdcfkgytcdk,ytdcgytdfcghjkl;lkijuhygtrdsfghjkl;dnmsklgmslk;gms;lkgmlks;mgckjytdcvclkdfghjklkjhgfdertydfghjkl;'ert"
    let spacing: CGFloat = 18
    let rangeStartValue = "1"
    let rangeEndValue = "60"
    let middleHorizontalSpacing: CGFloat = 16
    let lessVerticalSpacing: CGFloat = 8
    let middleVirticalSpacing: CGFloat = 40
    let largeVerticalSpacing: CGFloat = 26
    let widthAnchor: CGFloat = 60
    let widthAnchorSpacing: CGFloat = 200
  }
}