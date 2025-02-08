//
//  MainCardView.swift
//
//  Created by Vitalii Sosin on 01.05.2022.
//

import UIKit
import FancyStyle

/// View для экрана
public final class MainCardView: UIView {
  
  // MARK: - Public properties
  
  public override var intrinsicContentSize: CGSize {
    CGSize(width: 160, height: 90)
  }
  
  public override class var layerClass: AnyClass {
    return CAGradientLayer.self
  }
  
  // MARK: - Private properties
  
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  private let advLabelView = LabelGradientView()
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  private var isDisabledCard = false
  private var gradientColors: [UIColor] = [
    .fancy.only.primaryGreen,
    .fancy.only.secondaryGreen
  ]
  private var gradientDVLabel: [UIColor] = [
    .fancy.only.primaryRed,
    .fancy.only.primaryPink
  ]
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public func
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - imageCard: Иконка на карточке
  ///  - titleCard: Заголовок на карточке
  ///  - isShowADVLabel: Включить рекламный лайбл
  ///  - titleADVText: Заголовок на рекламном лайбле
  ///  - isDisabled: Карточка выключена
  ///  - gradientColors: Градиент фона
  ///  - gradientDVLabel: Градиент рекламного лейбла
  public func configureWith(imageCard: UIImage?,
                            titleCard: String?,
                            isShowADVLabel: Bool,
                            titleADVText: String?,
                            isDisabled: Bool,
                            gradientColors: [UIColor]? = nil,
                            gradientDVLabel: [UIColor]? = nil) {
    let colorWhite = isDisabled ? fancyColor.only.secondaryWhite : fancyColor.darkAndLightTheme.primaryWhite
    imageView.image = imageCard
    titleLabel.text = titleCard
    titleLabel.textColor = colorWhite
    advLabelView.isHidden = !isShowADVLabel
    
    if let gradientDVLabel {
      self.gradientDVLabel = gradientDVLabel
    }
    
    advLabelView.configureWith(titleText: titleADVText,
                               textColor: colorWhite,
                               gradientDVLabel: self.gradientDVLabel)
    imageView.setImageColor(color: colorWhite)
    isDisabledCard = isDisabled
    if let gradientColors {
      self.gradientColors = gradientColors
    }
    applyGradient()
  }
  
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    applyGradient(alpha: Appearance().alphaCard)
  }
  
  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    impactFeedback.impactOccurred()
    applyGradient()
    self.zoomInWithEasing()
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [imageView, titleLabel, advLabelView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      self.widthAnchor.constraint(equalToConstant: appearance.cellWidthConstant),
      self.heightAnchor.constraint(equalToConstant: appearance.cellHeightConstant),
      
      imageView.heightAnchor.constraint(equalToConstant: appearance.imageViewSize.height),
      
      imageView.topAnchor.constraint(equalTo: topAnchor, constant: appearance.inset),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: appearance.inset),
      
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -appearance.inset),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -appearance.inset),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: appearance.inset),
      
      advLabelView.topAnchor.constraint(equalTo: topAnchor, constant: appearance.inset),
      advLabelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -appearance.inset)
    ])
  }
  
  private func applyDefaultBehavior() {
    let appearance = Appearance()
    
    titleLabel.textColor = .fancy.darkAndLightTheme.primaryWhite
    titleLabel.font = fancyFont.primaryMedium18
    titleLabel.numberOfLines = 2
    titleLabel.textAlignment = .right
    imageView.contentMode = .scaleAspectFit
    
    advLabelView.isHidden = true
    
    layer.cornerRadius = appearance.cornerRadius
    applyGradient()
  }
  
  private func applyGradient(alpha: CGFloat = 1) {
    var colors: [UIColor] = []
    
    if isDisabledCard {
      colors = [
        .fancy.only.primaryGray,
        .fancy.only.secondaryGray
      ]
    } else {
      colors = gradientColors
    }
    
    guard let gradientLayer = layer as? CAGradientLayer else { return }
    gradientLayer.colors = colors.map { $0.withAlphaComponent(alpha).cgColor }
  }
}

// MARK: - Appearance

private extension MainCardView {
  struct Appearance {
    let cornerRadius: CGFloat = 8
    let imageViewSize: CGSize = CGSize(width: 32, height: 32)
    let inset: CGFloat = 8
    let alphaCard: CGFloat = 0.9
    
    let cellWidthConstant = (UIScreen.main.bounds.width * 0.45) - 32
    let cellHeightConstant: CGFloat = 90
  }
}
