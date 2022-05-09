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
    
}

protocol NumberScreenViewInput: AnyObject {
    
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
    
    // MARK: - Private func
    
    private func setupDefaultSettings() {
        let appearance = Appearance()
        
        resultLabel.text = appearance.someNumber
        resultLabel.font = RandomFont.primaryBold70
        resultLabel.textColor = RandomColor.primaryGray
        
        generateButton.setTitle(appearance.setTextButton, for: .normal)
        
        textFieldStackView.axis = .horizontal
        textFieldStackView.spacing = appearance.spacing
        textFieldStackView.distribution = .fillEqually
        
        firstTextField.placeholder = appearance.firstTextFieldValue
        firstTextField.text = appearance.firstTextFieldValue
        firstTextField.delegate = self
        
        secondTextField.placeholder = appearance.secondTextFieldValue
        secondTextField.text = appearance.secondTextFieldValue
        secondTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
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
            
            resultLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            resultLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            generateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                    constant: appearance.middleHorizontalSpacing),
            generateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                     constant: -appearance.middleHorizontalSpacing),
            generateButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                   constant: -appearance.largeVerticalSpacing),
            
            scrollResultView.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                                     constant: -appearance.lessVerticalSpacing),
            scrollResultView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                      constant: appearance.middleHorizontalSpacing),
            scrollResultView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                       constant: -appearance.middleHorizontalSpacing),
            
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
        let someNumber = "?"
        let setTextButton = "Сгенерировать"
        let spacing: CGFloat = 28
        let firstTextFieldValue = "1"
        let secondTextFieldValue = "10"
        let middleHorizontalSpacing: CGFloat = 16
        let largeHorizontalSpacing: CGFloat = 56
        let lessVerticalSpacing: CGFloat = 8
        let middleVirticalSpacing: CGFloat = 12
        let largeVerticalSpacing: CGFloat = 28
    }
}
