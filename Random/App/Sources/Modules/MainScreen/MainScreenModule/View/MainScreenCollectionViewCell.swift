//
//  MainScreenCollectionViewCell.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

/// CollectionViewCell
final class MainScreenCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Internal properties
  
  static let reuseIdentifier = MainScreenCollectionViewCell.description()
  
  // MARK: - Private properties
  
  private let mainCardView = MainCardView()
  
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
  
  func configureCellWith(model: MainScreenModel.Section, isPremium: Bool) {
    let isShowADVLabel: Bool
    
    switch model.advLabel {
    case .hit, .new:
      isShowADVLabel = true
    case .premium, .none:
      isShowADVLabel = false
    }
    
    let imageCardConfig = UIImage.SymbolConfiguration(pointSize: Appearance().imageCardSize, weight: .regular)
    let imageCard = UIImage(systemName: model.type.imageSectionSystemName,
                            withConfiguration: imageCardConfig)
    
    mainCardView.configureWith(
      imageCard: imageCard,
      titleCard: model.type.titleSection,
      isShowADVLabel: isShowADVLabel,
      titleADVText: model.advLabel.title,
      isDisabled: model.advLabel == .premium && !isPremium
    )
  }
}

// MARK: - Private

private extension MainScreenCollectionViewCell {
  func configureLayout() {
    [mainCardView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      mainCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
      mainCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
      mainCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
      mainCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
    ])
  }
  
  func applyDefaultBehavior() {
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
  }
}

// MARK: - Appearance

private extension MainScreenCollectionViewCell {
  struct Appearance {
    let imageCardSize: CGFloat = 32
  }
}
