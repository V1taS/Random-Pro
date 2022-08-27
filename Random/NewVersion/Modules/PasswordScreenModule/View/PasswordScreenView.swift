//
//  PasswordScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 04.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol PasswordScreenViewOutput: AnyObject {
  
  /// Результат генерации пароля скопирован
  func resultClassicCopied()
  
  /// Результат генерации пароля скопирован
  func resultPhraseCopied()
  
  /// Текст в текстовом поле был изменен
  /// - Parameters:
  ///  - text: Значение для текстового поля
  func rangePhraseDidChange(_ text: String?)
  
  /// Текст в текстовом поле был изменен
  /// - Parameters:
  ///  - text: Значение для текстового поля
  func passwordLengthDidChange(_ text: String?)
  
  /// Переключатель прописных букв
  ///  - Parameter status: Статус прописных букв
  func uppercaseSwitchAction(status: Bool)
  
  /// Переключатель строчных букв
  ///  - Parameter status: Статус строчных букв
  func lowercaseSwitchAction(status: Bool)
  
  /// Переключатель цифр
  ///  - Parameter status: Статус цифр
  func numbersSwitchAction(status: Bool)
  
  /// Переключатель символов
  ///  - Parameter status: Статус символов
  func symbolsSwitchAction(status: Bool)
  
  /// Кнопка нажата пользователем
  /// - Parameter passwordLength: Длина пароля
  func generateButtonAction(passwordLength: String?)
}

/// События которые отправляем от Presenter ко View
protocol PasswordScreenViewInput {
  
  /// Устанавливает значение в текстовое поле
  ///  - Parameter text: Значение для текстового поля
  func setPasswordLength(_ text: String?)
  
  /// Устанавливаем данные в result
  ///  - Parameters:
  ///   - resultClassic: Результат генерации
  ///   - resultPhrase: Результат генерации
  ///   - switchState: Состояние тумблеров
  func set(resultClassic: String?,
           resultPhrase: String?,
           switchState: PasswordScreenModel.SwitchState)
}

typealias PasswordScreenViewProtocol = UIView & PasswordScreenViewInput

final class PasswordScreenView: PasswordScreenViewProtocol {
  
  // MARK: - Internal property
  
  weak var output: PasswordScreenViewOutput?
  
  // MARK: - Private property
  
  private let passwordSegmentedControl = UISegmentedControl()
  private let passwordGeneratorView = PasswordGeneratorView()
  private let phrasePasswordView = PhrasePasswordView()
  private let genarateButton = ButtonView()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupDefaultSettings()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  func setPasswordLength(_ text: String?) {
    passwordGeneratorView.passwordLengthTextField.text = text
  }
  
  func set(resultClassic: String?,
           resultPhrase: String?,
           switchState: PasswordScreenModel.SwitchState) {
    let appearance = Appearance()
    setColorFor(password: resultClassic ?? appearance.resultLabel) { [weak self] result in
      guard let self = self else {
        return
      }
      
      self.passwordGeneratorView.resultTextView.attributedText = result
      self.passwordGeneratorView.uppercaseLettersSwitch.isOn = switchState.uppercase
      self.passwordGeneratorView.lowercaseLettersSwitch.isOn = switchState.lowercase
      self.passwordGeneratorView.numbersSwitch.isOn = switchState.numbers
      self.passwordGeneratorView.symbolsSwitch.isOn = switchState.symbols
    }
    
    setColorFor(password: resultPhrase ?? appearance.resultLabel) { [weak self] result in
      guard let self = self else {
        return
      }
      
      self.phrasePasswordView.resultTextView.attributedText = result
    }
  }
}

// MARK: - UITextFieldDelegate

extension PasswordScreenView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    if passwordGeneratorView.passwordLengthTextField == textField {
      if range.location >= 6 {
        return false
      }
      return true
    } else {
      return true
    }
  }
  
  func textFieldDidChangeSelection(_ textField: UITextField) {
    if passwordGeneratorView.passwordLengthTextField == textField {
      output?.passwordLengthDidChange(textField.text)
    } else {
      output?.rangePhraseDidChange(textField.text)
    }
  }
}

// MARK: - Private

private extension PasswordScreenView {
  func setColorFor(password: String, completion: @escaping (NSMutableAttributedString) -> Void) {
    DispatchQueue.main.async {
      let passwordAttributed = NSMutableAttributedString(
        string: password,
        attributes: [NSAttributedString.Key.font: RandomFont.primaryMedium24])
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center
      passwordAttributed.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: .zero,
                                                                                         length: password.count))
      
      for (index, character) in password.enumerated() {
        let characterStr = String(character)
        
        if characterStr.isNumber {
          passwordAttributed.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: RandomColor.primaryBlue,
            range: NSRange(location: index, length: 1)
          )
          continue
        }
        
        if characterStr.isSymbols {
          passwordAttributed.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: RandomColor.primaryRed,
            range: NSRange(location: index, length: 1)
          )
          continue
        }
        
        if characterStr.isLowercaseLetters {
          passwordAttributed.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: RandomColor.primaryGreen,
            range: NSRange(location: index, length: 1)
          )
          continue
        }
        passwordAttributed.addAttribute(
          NSAttributedString.Key.foregroundColor,
          value: RandomColor.primaryGray,
          range: NSRange(location: index, length: 1)
        )
      }
      completion(passwordAttributed)
    }
  }
  
  func setupDefaultSettings() {
    let appearance = Appearance()
    backgroundColor = RandomColor.primaryWhite
    
    phrasePasswordView.phraseTextField.delegate = self
    phrasePasswordView.resultTextAction = { [weak self] in
      self?.output?.resultPhraseCopied()
    }
    
    passwordGeneratorView.passwordLengthTextField.delegate = self
    passwordGeneratorView.configureViewWith(
      uppercaseSwitchAction: { [weak self] status in
        self?.output?.uppercaseSwitchAction(status: status)
      },
      lowercaseSwitchAction: { [weak self] status in
        self?.output?.lowercaseSwitchAction(status: status)
      },
      numbersSwitchAction: { [weak self] status in
        self?.output?.numbersSwitchAction(status: status)
      },
      symbolsSwitchAction: { [weak self] status in
        self?.output?.symbolsSwitchAction(status: status)
      },
      resultTextAction: { [weak self] in
        self?.output?.resultClassicCopied()
      }
    )
    
    passwordSegmentedControl.insertSegment(withTitle: appearance.generatePassword,
                                           at: appearance.passwordIndex,
                                           animated: false)
    passwordSegmentedControl.insertSegment(withTitle: appearance.phrasePassword,
                                           at: appearance.phraseIndex,
                                           animated: false)
    passwordSegmentedControl.selectedSegmentIndex = appearance.passwordIndex
    passwordSegmentedControl.addTarget(self, action: #selector(passwordSegmentedControlAction), for: .valueChanged)
    
    phrasePasswordView.isHidden = true
    
    genarateButton.setTitle(appearance.setTextButton, for: .normal)
    genarateButton.addTarget(self, action: #selector(genarateButtonAction), for: .touchUpInside)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
    tap.cancelsTouchesInView = false
    addGestureRecognizer(tap)
    isUserInteractionEnabled = true
  }
  
  @objc
  func passwordSegmentedControlAction() {
    if passwordSegmentedControl.selectedSegmentIndex == Appearance().passwordIndex {
      passwordGeneratorView.isHidden = false
      phrasePasswordView.isHidden = true
      genarateButton.isHidden = false
    } else {
      passwordGeneratorView.isHidden = true
      phrasePasswordView.isHidden = false
      genarateButton.isHidden = true
    }
  }
  
  @objc
  func genarateButtonAction() {
    output?.generateButtonAction(passwordLength: passwordGeneratorView.passwordLengthTextField.text)
  }
  
  func setupConstraints() {
    let appearance = Appearance()
    [passwordSegmentedControl, passwordGeneratorView, phrasePasswordView, genarateButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      passwordSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                        constant: appearance.middleHorizontalSpacing),
      passwordSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                         constant: -appearance.middleHorizontalSpacing),
      passwordSegmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      passwordSegmentedControl.heightAnchor.constraint(equalToConstant: appearance.passwordHeightSpacing),
      
      passwordGeneratorView.leadingAnchor.constraint(equalTo: leadingAnchor),
      passwordGeneratorView.trailingAnchor.constraint(equalTo: trailingAnchor),
      passwordGeneratorView.topAnchor.constraint(equalTo: passwordSegmentedControl.bottomAnchor),
      passwordGeneratorView.bottomAnchor.constraint(equalTo: genarateButton.topAnchor),
      
      phrasePasswordView.leadingAnchor.constraint(equalTo: leadingAnchor),
      phrasePasswordView.trailingAnchor.constraint(equalTo: trailingAnchor),
      phrasePasswordView.topAnchor.constraint(equalTo: passwordSegmentedControl.bottomAnchor),
      phrasePasswordView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      
      genarateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                              constant: appearance.middleHorizontalSpacing),
      genarateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -appearance.middleHorizontalSpacing),
      genarateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -appearance.middleHorizontalSpacing)
    ])
  }
}

// MARK: - Appearance

private extension PasswordScreenView {
  struct Appearance {
    let setTextButton = NSLocalizedString("Сгенерировать", comment: "")
    let generatePassword = NSLocalizedString("Генератор паролей", comment: "")
    let phrasePassword = NSLocalizedString("Фраза пароль", comment: "")
    let middleHorizontalSpacing: CGFloat = 16
    let minVerticalInset: CGFloat = 8
    let passwordHeightSpacing: CGFloat = 28
    let passwordIndex: Int = 0
    let phraseIndex: Int = 1
    let resultLabel = "?"
  }
}
