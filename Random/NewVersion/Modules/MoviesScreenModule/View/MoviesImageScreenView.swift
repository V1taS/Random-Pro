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
  private let ratingImageView = UIView()
  private let moviewTitleLabel = UILabel()
  private let numberRatingLabel = UILabel()
  
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
    backgroundColor = RandomColor.secondaryWhite
    
    moviesImageView.backgroundColor = .white
    moviesImageView.layer.borderWidth = appearance.borderWidth
    moviesImageView.layer.cornerRadius = appearance.moviesLayer
    
    ratingImageView.backgroundColor = .green
    ratingImageView.layer.borderWidth = appearance.borderWidth
    ratingImageView.layer.cornerRadius = appearance.ratingLayer
    
    moviewTitleLabel.text = appearance.setTextNameFilm
    moviewTitleLabel.font = RandomFont.primaryRegular18
    moviewTitleLabel.textColor = RandomColor.primaryGray
    
    numberRatingLabel.text = appearance.ratingLabel
    numberRatingLabel.font = RandomFont.primaryBold16
  }
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [moviesImageView, moviewTitleLabel, ratingImageView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    [ratingImageView, numberRatingLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      moviesImageView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      moviesImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: appearance.averageSpasing),
      moviesImageView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -appearance.averageSpasing),
      moviesImageView.heightAnchor.constraint(equalToConstant: appearance.heightView),
      moviesImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                           constant: appearance.middleSpacing),
      
      ratingImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: appearance.minimumSpasing),
      ratingImageView.topAnchor.constraint(equalTo: moviesImageView.topAnchor,
                                           constant: appearance.averageSpasing),
      ratingImageView.heightAnchor.constraint(equalToConstant: appearance.minimumSpasing),
      ratingImageView.widthAnchor.constraint(equalToConstant: appearance.averageSpasing),
      
      numberRatingLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                 constant: appearance.labelSpasing),
      numberRatingLabel.topAnchor.constraint(equalTo: moviesImageView.topAnchor,
                                             constant: appearance.ratingSpasing),
      
      moviewTitleLabel.topAnchor.constraint(equalTo: moviesImageView.bottomAnchor,
                                            constant: appearance.middleSpacing),
      moviewTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
    ])
  }
}

// MARK: - Appearance

extension MoviesImageScreenView {
  struct Appearance {
    let setTextNameFilm = NSLocalizedString("Name movie", comment: "")
    let middleSpacing: CGFloat = 16
    let minInset: CGFloat = 8
    let averageSpasing: CGFloat = 40
    let ratingSpasing: CGFloat = 42
    let minimumSpasing: CGFloat = 24
    let labelSpasing: CGFloat = 26
    let heightView: CGFloat = 360
    let borderWidth: CGFloat = 1
    let moviesLayer: CGFloat = 16
    let ratingLayer: CGFloat = 8
    let ratingLabel = "10.0"
  }
}
