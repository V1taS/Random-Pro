//
//  MainScreenCollectionViewCell.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit
import FancyStyle
import SKAbstractions

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
  
  func configureCellWith(section: MainScreenModel.Section, isPremium: Bool) {
    let isShowADVLabel: Bool
    var gradientDVLabel: [UIColor] = []

    switch section.advLabel {
    case .adv:
      isShowADVLabel = true
      gradientDVLabel = [.blue.withAlphaComponent(0.3), .blue.withAlphaComponent(0.1)]
    case .ai:
      isShowADVLabel = true
      gradientDVLabel = [.purple.withAlphaComponent(0.9), .purple.withAlphaComponent(0.5)]
    case .none:
      isShowADVLabel = false
      gradientDVLabel = []
    default:
      isShowADVLabel = true
      gradientDVLabel = [.fancy.only.primaryRed, .fancy.only.primaryPink]
    }

    let imageCardConfig = UIImage.SymbolConfiguration(pointSize: Appearance().imageCardSize, weight: .regular)
    let imageCard = UIImage(systemName: section.type.imageSectionSystemName,
                            withConfiguration: imageCardConfig)
    
    let isDisabled: Bool
    switch isPremium {
    case true:
      isDisabled = false
    case false:
      isDisabled = section.isPremium
    }
    
    mainCardView.configureWith(
      imageCard: imageCard,
      titleCard: section.type.isADV ? section.advDescription ?? "" : section.type.titleSection,
      isShowADVLabel: isShowADVLabel,
      titleADVText: section.advLabel.title,
      isDisabled: isDisabled,
      gradientColors: nil,
      gradientDVLabel: gradientDVLabel
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
    backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
  }
}

// MARK: - Appearance

private extension MainScreenCollectionViewCell {
  struct Appearance {
    let imageCardSize: CGFloat = 32
  }
}
