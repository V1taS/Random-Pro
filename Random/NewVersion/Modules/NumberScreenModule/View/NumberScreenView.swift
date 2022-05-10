//
//  NumberScreenView.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 09.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit
import RandomUIKit

protocol NumberScreenViewOutput: AnyObject {
    
    /// Кнопка нажата пользователем
    /// - Parameters:
    ///  - firstTextFieldValue: Первый textField
    ///  - secondTextFieldValue: Второй textField
    func generateButtonAction(firstTextFieldValue: String?,
                              secondTextFieldValue: String?)
}

protocol NumberScreenViewInput: AnyObject {
    
    /// Устанавливаем данные для первого и второго поля ввода числа
    /// - Parameters:
    ///  - firstTextFieldValue: Первый textField
    ///  - secondTextFieldValue: Второй textField
    func set(firstTextFieldValue: String?,
             secondTextFieldValue: String?)
    
    /// Устанавливаем данные в result
    ///  - Parameter result: результат генерации
    func set(result: String?)
    
    /// Устанавливает список результатов
    ///  - Parameter listResult: массив результатов
    func set(listResult: [String])
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
    
    private let firstTextField = TextFieldView()
    private let secondTextField = TextFieldView()
    private let textFieldStackView = UIStackView()
    private let resultLabel = UILabel()
    private let scrollResultView = ScrollLabelGradientView()
    private let generateButton = ButtonView()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
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
    
    func set(firstTextFieldValue: String?,
             secondTextFieldValue: String?) {
        firstTextField.text = firstTextFieldValue
        secondTextField.text = secondTextFieldValue
    }
    
    func set(result: String?) {
        resultLabel.text = result
    }
    
    func set(listResult: [String]) {
        scrollResultView.listLabels = listResult
    }
    
    // MARK: - Private func
    
    private func setupDefaultSettings() {
        let appearance = Appearance()
        
        resultLabel.font = RandomFont.primaryBold70
        resultLabel.textColor = RandomColor.primaryGray
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 10
        
        generateButton.setTitle(appearance.setTextButton, for: .normal)
        generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
        
        textFieldStackView.axis = .horizontal
        textFieldStackView.spacing = appearance.spacing
        textFieldStackView.distribution = .fillEqually
        
        firstTextField.placeholder = appearance.firstTextFieldPlaceholder
        firstTextField.delegate = self
        firstTextField.keyboardType = .numberPad
        
        secondTextField.placeholder = appearance.secondTextFieldPlaceholder
        secondTextField.delegate = self
        secondTextField.keyboardType = .numberPad
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
    
    @objc private func generateButtonAction() {
        output?.generateButtonAction(firstTextFieldValue: firstTextField.text,
                                     secondTextFieldValue: secondTextField.text)
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
        
        [firstTextField, secondTextField].forEach {
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
                                                   constant: -appearance.largeVerticalSpacing),
            
            scrollResultView.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                                     constant: -appearance.lessVerticalSpacing),
            scrollResultView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollResultView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            textFieldStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                        constant: appearance.largeHorizontalSpacing),
            textFieldStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                         constant: -appearance.largeHorizontalSpacing),
            textFieldStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                    constant: appearance.middleVirticalSpacing)
        ])
    }
}

// MARK: - UITextFieldDelegate

extension NumberScreenView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        firstTextField.resignFirstResponder()
        secondTextField.resignFirstResponder()
        return true
    }
}

// MARK: - Appearance

private extension NumberScreenView {
    struct Appearance {
        let setTextButton = "Сгенерировать"
        let spacing: CGFloat = 28
        let firstTextFieldPlaceholder = "1"
        let secondTextFieldPlaceholder = "10"
        let middleHorizontalSpacing: CGFloat = 16
        let largeHorizontalSpacing: CGFloat = 56
        let lessVerticalSpacing: CGFloat = 8
        let middleVirticalSpacing: CGFloat = 12
        let largeVerticalSpacing: CGFloat = 28
    }
}
