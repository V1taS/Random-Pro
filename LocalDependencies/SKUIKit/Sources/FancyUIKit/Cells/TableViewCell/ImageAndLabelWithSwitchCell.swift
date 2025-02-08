//
//  ImageAndLabelWithSwitchCell.swift
//  
//
//  Created by Vitalii Sosin on 24.01.2023.
//

import UIKit
import FancyStyle

// MARK: - ImageAndLabelWithSwitchCell

public final class ImageAndLabelWithSwitchCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Action на изменение переключателя
  public var switchAction: ((Bool) -> Void)?
  
  /// Identifier для ячейки
  public static let reuseIdentifier = ImageAndLabelWithSwitchCell.description()
  
  // MARK: - Private property
  
  private let titleLabel = UILabel()
  private let resultSwitch = UISwitch()
  private let leftSideImageView = UIImageView()
  
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
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - leftSideImage: Картинка слева
  ///  - leftSideImageColor: Цвет картинки слева
  ///  - titleText: Заголовок у ячейки
  ///  - isResultSwitch: Значение у переключателя
  public func configureCellWith(leftSideImage: UIImage?,
                                leftSideImageColor: UIColor? = .fancy.darkAndLightTheme.primaryGray,
                                titleText: String?,
                                isResultSwitch: Bool) {
    titleLabel.text = titleText
    resultSwitch.isOn = isResultSwitch
    leftSideImageView.image = leftSideImage
    leftSideImageView.setImageColor(color: leftSideImageColor ?? .fancy.darkAndLightTheme.primaryGray)
  }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    layer.cornerRadius = .zero
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [titleLabel, resultSwitch, leftSideImageView].forEach {
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
      
      resultSwitch.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      resultSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                             constant: -appearance.insets.right),
      resultSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    selectionStyle = .none
    
    titleLabel.font = fancyFont.primaryRegular18
    titleLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

    resultSwitch.setContentHuggingPriority(.required, for: .horizontal)
    resultSwitch.addTarget(self, action: #selector(resultSwitchAction(_:)), for: .valueChanged)
  }
  
  @objc private func resultSwitchAction(_ sender: UISwitch) {
    switchAction?(sender.isOn)
  }
}

// MARK: - Appearance

private extension ImageAndLabelWithSwitchCell {
  struct Appearance {
    let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    let imageSize: CGFloat = 24
  }
}
