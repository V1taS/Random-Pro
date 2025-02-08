//
//  SquircleImageAndLabelWithChevronCell.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 25.01.2023.
//

import UIKit
import FancyStyle

// MARK: - SquircleImageAndLabelWithChevronCell

public final class SquircleImageAndLabelWithChevronCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Identifier для ячейки
  public static let reuseIdentifier = SquircleImageAndLabelWithChevronCell.description()
  
  // MARK: - Private property
  
  private let titleLable = UILabel()
  private let chevronImageView = UIImageView()
  private let leftSideImageView = UIImageView()
  private let leftSideSquircleView = SquircleView()
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initilisation
  
  public override init(style: CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Public func
  
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    backgroundColor = .fancy.darkAndLightTheme.secondaryGray.withAlphaComponent(0.1)
    contentView.backgroundColor = .fancy.darkAndLightTheme.secondaryGray.withAlphaComponent(0.1)
  }
  
  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    impactFeedback.impactOccurred()
  }
  
  public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
  }
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - squircleBGColors: Squircle цвет фона
  ///  - squircleBGAlpha: Squircle прозрачность
  ///  - leftSideImage: Картинка слева
  ///  - leftSideImageColor: Цвет картинки слева
  ///  - titleText: Заголовок
  ///  - isChevron: Шеврон включен
  public func configureCellWith(squircleBGColors: [UIColor],
                                squircleBGAlpha: CGFloat = 1,
                                leftSideImage: UIImage?,
                                leftSideImageColor: UIColor?,
                                titleText: String?,
                                isChevron: Bool) {
    titleLable.text = titleText
    chevronImageView.isHidden = !isChevron
    chevronImageView.image = Appearance().chevronRight
    chevronImageView.setImageColor(color: .fancy.only.primaryBlue)
    leftSideImageView.image = leftSideImage
    leftSideImageView.setImageColor(color: leftSideImageColor ?? .fancy.darkAndLightTheme.primaryGray)
    leftSideSquircleView.applyGradient(colors: squircleBGColors,
                                       alpha: squircleBGAlpha)
  }

  public override func prepareForReuse() {
    super.prepareForReuse()
    layer.cornerRadius = .zero
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    [leftSideImageView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      leftSideSquircleView.addSubview($0)
    }
    
    [titleLable, chevronImageView, leftSideSquircleView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      leftSideSquircleView.widthAnchor.constraint(equalToConstant: appearance.imageSize),
      leftSideSquircleView.heightAnchor.constraint(equalToConstant: appearance.imageSize),
      
      leftSideSquircleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                    constant: appearance.insets.left),
      leftSideSquircleView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: appearance.insets.top),
      leftSideSquircleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                   constant: -appearance.insets.bottom),
      
      leftSideImageView.leadingAnchor.constraint(equalTo: leftSideSquircleView.leadingAnchor,
                                                 constant: appearance.minInset),
      leftSideImageView.topAnchor.constraint(equalTo: leftSideSquircleView.topAnchor,
                                             constant: appearance.minInset),
      leftSideImageView.trailingAnchor.constraint(equalTo: leftSideSquircleView.trailingAnchor,
                                                  constant: -appearance.minInset),
      leftSideImageView.bottomAnchor.constraint(equalTo: leftSideSquircleView.bottomAnchor,
                                                constant: -appearance.minInset),
      
      titleLable.leadingAnchor.constraint(equalTo: leftSideSquircleView.trailingAnchor,
                                          constant: appearance.insets.left),
      titleLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      
      chevronImageView.leadingAnchor.constraint(equalTo: titleLable.trailingAnchor),
      chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -appearance.insets.right),
      chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    selectionStyle = .none
    
    chevronImageView.contentMode = .right
    chevronImageView.setContentHuggingPriority(.required, for: .horizontal)
    
    titleLable.font = fancyFont.primaryRegular18
    titleLable.textColor = .fancy.darkAndLightTheme.primaryGray
    titleLable.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
  }
}

// MARK: - Appearance

private extension SquircleImageAndLabelWithChevronCell {
  struct Appearance {
    let minInset: CGFloat = 3
    let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    let imageSize: CGFloat = 32
    let chevronRight = UIImage(named: "chevron_right", in: .module, compatibleWith: nil)
  }
}
