//
//  MoviesImageScreenView.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 09.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

final class MoviesImageScreenView: UIView {
  
  // MARK: - Private property
  
  private let moviesImageView = UIView()
  private let ratingImageView = LabelGradientView()
  private let moviesTitleLabel = UILabel()
  
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
  
  private func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.primaryWhite

    moviesImageView.layer.borderWidth = appearance.borderWidthView
    moviesImageView.layer.cornerRadius = appearance.middleSpacing
    
    moviesTitleLabel.text = appearance.setTextNameFilm
    moviesTitleLabel.font = RandomFont.primaryRegular18
    moviesTitleLabel.textColor = RandomColor.primaryGray
    moviesTitleLabel.textAlignment = .center
    
    ratingImageView.configureWith(
      titleText: appearance.setTextRetingLabel,
      font: RandomFont.primaryBold24,
      textColor: nil,
      borderWidth: appearance.borderWidthView,
      borderColor: RandomColor.primaryBlack,
      gradientDVLabel: [RandomColor.primaryGreen,
                        RandomColor.secondaryGreen]
    )
  }
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [moviesImageView, ratingImageView, moviesTitleLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      moviesImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: appearance.averageSpasing),
      moviesImageView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -appearance.averageSpasing),
      moviesImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                              constant: -appearance.heightView),
      moviesImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                           constant: appearance.middleSpacing),
      
      ratingImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: appearance.intermediateSpasing),
      ratingImageView.topAnchor.constraint(equalTo: moviesImageView.topAnchor,
                                           constant: appearance.averageSpasing),
      
      moviesTitleLabel.topAnchor.constraint(equalTo: moviesImageView.bottomAnchor,
                                            constant: appearance.middleSpacing),
      moviesTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: appearance.middleSpacing),
      moviesTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -appearance.middleSpacing)
    ])
  }
}

// MARK: - Appearance

extension MoviesImageScreenView {
  struct Appearance {
    let setTextNameFilm = NSLocalizedString("Name movie", comment: "")
    let setTextRetingLabel = NSLocalizedString("10.0", comment: "")
    let middleSpacing: CGFloat = 16
    let intermediateSpasing: CGFloat = 24
    let averageSpasing: CGFloat = 40
    let heightView: CGFloat = 140
    let borderWidthView: CGFloat = 0.2
  }
}
