//
//  CoinScreenView.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 17.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit
import RandomUIKit

protocol CoinScreenViewOutput: AnyObject {
    
    /// Пользователь нажал на кнопку генерации
    func generateButtonAction()
}

protocol CoinScreenViewInput: AnyObject {
    
    /// Устанавливает результат генерации
    /// - Parameter result: результат генерации
    func set(result: String)
    
    /// Устанавливает список результатов генерации
    /// - Parameter listResult: готовый список результатов
    func set(listResult: [String])
    
    /// Устанавливает картинку генерации
    /// - Parameter resultImage: результат генерации
    
    func set(resultImage: UIImage?)
}

typealias CoinScreenViewProtocol = UIView & CoinScreenViewInput

final class CoinScreenView: CoinScreenViewProtocol {
    
    // MARK: - Internal property
    
    weak var output: CoinScreenViewOutput?
    
    // MARK: - Private property
    
    private let resultLabel = UILabel()
    private let scrollResult = ScrollLabelGradientView()
    private let generateButton = ButtonView()
    private let coinImage = UIImageView()
    
    // MARK: - Internal func
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = RandomColor.secondaryWhite
        
        setupDefaultSettings()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(result: String) {
        resultLabel.text = result
    }
    
    func set(listResult: [String]) {
        scrollResult.listLabels = listResult
    }
    
    func set(resultImage: UIImage?) {
        coinImage.image = resultImage
    }
    
    // MARK: - Private func
    
    private func setupDefaultSettings() {
        let appearance = Appearance()
        
        resultLabel.font = RandomFont.primaryBold50
        resultLabel.textColor = RandomColor.primaryGray
        
        generateButton.setTitle(appearance.textButton, for: .normal)
        generateButton.addTarget(self, action: #selector(generateButtonAction), for: .touchUpInside)
        
        coinImage.layer.cornerRadius = appearance.cornerRadius
    }
    
    @objc private func generateButtonAction() {
        output?.generateButtonAction()
    }
    
    private func setupConstraints() {
        let appearance = Appearance()
        
        [resultLabel, generateButton, coinImage, scrollResult].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -appearance.centerConstant),
            resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            coinImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            coinImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            coinImage.heightAnchor.constraint(equalToConstant: appearance.height),
            coinImage.widthAnchor.constraint(equalToConstant: appearance.width),
            
            generateButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                    constant: appearance.middleHorizontalSize),
            generateButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: -appearance.middleHorizontalSize),
            generateButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -appearance.hightVirticalSize),
            
            scrollResult.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollResult.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollResult.bottomAnchor.constraint(equalTo: generateButton.topAnchor,
                                                 constant: -appearance.lessVirticalSize)
        ])
    }
}

// MARK: - Private Appearance

private extension CoinScreenView {
    struct Appearance {
        let textButton = NSLocalizedString("Сгенерировать", comment: "")
        let cornerRadius: CGFloat = 100
        let centerConstant: CGFloat = 240
        let middleHorizontalSize: CGFloat = 16
        let hightVirticalSize: CGFloat = 28
        let lessVirticalSize: CGFloat = 8
        let height: CGFloat = 200
        let width: CGFloat = 200
    }
}
