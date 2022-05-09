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
    
    private let firstTextField = TextFieldView()
    private let secondTextField = TextFieldView()
    private let textFieldStackView = UIStackView()
    private let resultLabel = UILabel()
    private let scrollResultView = ScrollLabelGradientView()
    private let generateButton = ButtonView()
    
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
        
        secondTextField.placeholder = appearance.secondTextFieldValue
        secondTextField.text = appearance.secondTextFieldValue
    }
    
    private func setupConstraints() {
        let appearance = Appearance()
        
        [textFieldStackView, resultLabel, scrollResultView, generateButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        [firstTextField, secondTextField].forEach {
            textFieldStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                    constant: appearance.middleHorizontalSpacing),
            generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: -appearance.middleHorizontalSpacing),
            generateButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                   constant: -appearance.largeVerticalSpacing),
            
            scrollResultView.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                                     constant: -appearance.lessVerticalSpacing),
            scrollResultView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                      constant: appearance.middleHorizontalSpacing),
            scrollResultView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                       constant: -appearance.middleHorizontalSpacing),
            
            textFieldStackView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                        constant: appearance.largeHorizontalSpacing),
            textFieldStackView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                         constant: -appearance.largeHorizontalSpacing),
            textFieldStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                    constant: appearance.middleVirticalSpacing)
        ])
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
