//
//  ImageAndLabelWithChevronCell.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 24.01.2023.
//

import UIKit
import FancyStyle

// MARK: - ImageAndLabelWithChevronCell

public final class ImageAndLabelWithChevronCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Identifier для ячейки
  public static let reuseIdentifier = ImageAndLabelWithChevronCell.description()
  
  // MARK: - Private property
  
  private let titleLabel = UILabel()
  private let chevronImageView = UIImageView()
  private let leftSideImageView = UIImageView()
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

  public override func prepareForReuse() {
    super.prepareForReuse()
    layer.cornerRadius = .zero
  }
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - leftSideImage: Картинка слева
  ///  - leftSideImageColor: Цвет картинки слева
  ///  - titleText: Заголовок
  ///  - isChevron: Шеврон включен
  public func configureCellWith(leftSideImage: UIImage?,
                                leftSideImageColor: UIColor?,
                                titleText: String?,
                                isChevron: Bool) {
    titleLabel.text = titleText
    chevronImageView.isHidden = !isChevron
    chevronImageView.image = Appearance().chevronRight
    chevronImageView.setImageColor(color: .fancy.only.primaryBlue)
    leftSideImageView.image = leftSideImage
    leftSideImageView.setImageColor(color: leftSideImageColor ?? .fancy.darkAndLightTheme.primaryGray)
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [titleLabel, chevronImageView, leftSideImageView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      leftSideImageView.widthAnchor.constraint(equalToConstant: appearance.imageSize),
      leftSideImageView.heightAnchor.constraint(equalToConstant: appearance.imageSize),
      
      leftSideImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                 constant: appearance.insets.left),
      leftSideImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                             constant: appearance.insets.top),
      leftSideImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                constant: -appearance.insets.bottom),
      
      titleLabel.leadingAnchor.constraint(equalTo: leftSideImageView.trailingAnchor,
                                          constant: appearance.insets.left),
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      
      chevronImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
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
    
    titleLabel.font = fancyFont.primaryRegular18
    titleLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
  }
}

// MARK: - Appearance

private extension ImageAndLabelWithChevronCell {
  struct Appearance {
    let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    let imageSize: CGFloat = 24
    let chevronRight = UIImage(named: "chevron_right", in: .module, compatibleWith: nil)
  }
}
