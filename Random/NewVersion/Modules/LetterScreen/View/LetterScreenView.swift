//
//  LetterScreenView.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 16.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit
import RandomUIKit

protocol LetterScreenViewOutput: AnyObject {
    
    /// Пользователь нажал на кнопку и происходит генерация 'Английских букв'
    func generateEngButtonAction()
    
    /// Пользователь нажал на кнопку и происходит генерация  'Русских букв'
    func generateRusButtonAction()
}

protocol LetterScreenViewInput: AnyObject {
    
    /// Устанавливает результат генерации
    /// - Parameter result: результат генерации
    func set(result: String?)
    
    /// Устанавливает список результатов
    /// - Parameter listResult: массив генераций
    func set(listResult: [String])
}

typealias LetterScreenViewProtocol = UIView & LetterScreenViewInput

final class LetterScreenView: LetterScreenViewProtocol {
    
    // MARK: - Internal property
    
    weak var output: LetterScreenViewOutput?
    
    // MARK: - Private property
    
    private let resultLabel = UILabel()
    private let scrollResult = ScrollLabelGradientView()
    private let generateButton = ButtonView()
    private let letterSegmentedControl = UISegmentedControl()
    private var letterContent: LetterScreenContent = .rus
    
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
    
    func set(result: String?) {
        resultLabel.text = result
    }
    
    func set(listResult: [String]) {
        scrollResult.listLabels = listResult
    }
    
    // MARK: - Private func
    
    private func setupDefaultSettings() {
        let appearance = Appearance()

        resultLabel.font = RandomFont.primaryBold70
        resultLabel.textColor = RandomColor.primaryGray
        
        generateButton.setTitle(appearance.textButton, for: .normal)
        generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
        
        letterSegmentedControl.frame = CGRect(x: appearance.frameSize, y: appearance.frameSize,
                                              width: appearance.width, height: appearance.height)
        
        letterSegmentedControl.insertSegment(withTitle: appearance.russionText,
                                             at: appearance.rusControl, animated: true)
        letterSegmentedControl.insertSegment(withTitle: appearance.englishText,
                                             at: appearance.engControl, animated: true)
        
        letterSegmentedControl.selectedSegmentIndex = appearance.rusControl
        letterSegmentedControl.addTarget(self, action: #selector(segmentedControlAction(_:)), for: .valueChanged)
    }
    
    @objc private func generateButtonAction() {
        switch letterContent {
        case .rus:
            output?.generateRusButtonAction()
        case .eng:
            output?.generateEngButtonAction()
        }
    }
    
    @objc private func segmentedControlAction(_ segmentedControl: UISegmentedControl) {
        let appearance = Appearance()
        
        if segmentedControl.selectedSegmentIndex == appearance.rusControl {
            letterContent = .rus
            return
        }
        
        if segmentedControl.selectedSegmentIndex == appearance.engControl {
            letterContent = .eng
            return
        }
    }
    
    private func setupConstraints() {
        let appearance = Appearance()
        
        [resultLabel, scrollResult, generateButton, letterSegmentedControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                    constant: appearance.middleHorizontalSize),
            generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: -appearance.middleHorizontalSize),
            generateButton.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                   constant: -appearance.highVirticalSize),
            
            letterSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                            constant: appearance.middleHorizontalSize),
            letterSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                             constant: -appearance.middleHorizontalSize),
            letterSegmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            
            scrollResult.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollResult.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollResult.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                                 constant: -appearance.lessVerticalSpacing)
        ])
    }
}

// MARK: - private LetterScreenView

private extension LetterScreenView {
    struct Appearance {
        let textButton = "Сгенерировать букву"
        let russionText = "Русские буквы"
        let englishText = "Английские буквы"
        let lessVerticalSpacing: CGFloat = 8
        let middleHorizontalSize: CGFloat = 16
        let highVirticalSize: CGFloat = 28
        let frameSize: Double = 0.0
        let width: CGFloat = 300
        let height: CGFloat = 50
        let engControl: Int = 1
        let rusControl: Int = 0
    }
}
