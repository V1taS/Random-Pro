//
//  YesNoScreenView.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 12.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit
import RandomUIKit

protocol YesNoScreenViewOutput: AnyObject {
    
    /// Пользователь нажал на кнопку
    func generateButtonAction()
}

protocol YesNoScreenViewInput: AnyObject {
    
    /// Устанавливаем данные в result
    ///  - Parameter result: результат генерации
    func set(result: String?)
    
    /// Устанавливает список результатов
    ///  - Parameter listResult: массив результатов
    func set(listResult: [String])
}

typealias YesNoScreenProtocol = UIView & YesNoScreenViewInput

final class YesNoScreenView: YesNoScreenProtocol {
    
    // MARK: - Internal property
    
    weak var output: YesNoScreenViewOutput?
    
    // MARK: - Private property
    
    private let resultLabel = UILabel()
    private let scrollResult = ScrollLabelGradientView()
    private let generateButton = ButtonView()
    
    // MARK: - Internal func
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = RandomColor.secondaryWhite
        
        setupDefaultSettings()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(result: String?) {
        resultLabel.text = result
    }
    
    func set(listResult: [String]) {
        scrollResult.listLabels = listResult
    }
    
    // MARK: - Private func
    
    private func setupDefaultSettings() {
        
        resultLabel.font = RandomFont.primaryBold70
        resultLabel.textColor = RandomColor.primaryGray
        resultLabel.textAlignment = .center
        
        generateButton.setTitle(Appearance().setTextButton, for: .normal)
        generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
    }
    
    @objc private func generateButtonAction() {
        output?.generateButtonAction()
    }
    
    private func setupConstraints() {
        let appearance = Appearance()
        
        [resultLabel, scrollResult, generateButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                    constant: appearance.middleHorizontalSpacing),
            generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: -appearance.middleHorizontalSpacing),
            generateButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -appearance.largeVerticalSpacing),
            
            scrollResult.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollResult.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollResult.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                                 constant: -appearance.lessVerticalSpacing)
        ])
    }
}

// MARK: - Private Appearance

private extension YesNoScreenView {
    struct Appearance {
        let setTextButton = NSLocalizedString("Да или Нет", comment: "")
        let middleHorizontalSpacing: CGFloat = 16
        let largeVerticalSpacing: CGFloat = 28
        let lessVerticalSpacing: CGFloat = 8
    }
}
