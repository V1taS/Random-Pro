//
//  SquircleImageAndLabelWithSwitchCell.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 25.01.2023.
//

import UIKit
import FancyStyle

// MARK: - SquircleImageAndLabelWithSwitchCell

public final class SquircleImageAndLabelWithSwitchCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Action на изменение переключателя
  public var switchAction: ((Bool) -> Void)?
  
  /// Identifier для ячейки
  public static let reuseIdentifier = SquircleImageAndLabelWithSwitchCell.description()
  
  // MARK: - Private property
  
  private let titleLabel = UILabel()
  private let resultSwitch = UISwitch()
  private let leftSideImageView = UIImageView()
  private let leftSideSquircleView = SquircleView()
  
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
  ///  - squircleBGColors: Squircle цвет фона
  ///  - squircleBGAlpha: Squircle прозрачность
  ///  - leftSideImage: Картинка слева в squircle
  ///  - leftSideImageColor: Цвет картинки слева
  ///  - titleText: Заголовок у ячейки
  ///  - isResultSwitch: Значение у переключателя
  public func configureCellWith(squircleBGColors: [UIColor],
                                squircleBGAlpha: CGFloat = 1,
                                leftSideImage: UIImage?,
                                leftSideImageColor: UIColor?,
                                titleText: String?,
                                isResultSwitch: Bool) {
    titleLabel.text = titleText
    resultSwitch.isOn = isResultSwitch
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
    
    [titleLabel, resultSwitch, leftSideSquircleView].forEach {
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
      
      titleLabel.leadingAnchor.constraint(equalTo: leftSideSquircleView.trailingAnchor,
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
    
    resultSwitch.addTarget(self, action: #selector(resultSwitchAction(_:)), for: .valueChanged)
    resultSwitch.setContentHuggingPriority(.required, for: .horizontal)
  }
  
  @objc private func resultSwitchAction(_ sender: UISwitch) {
    switchAction?(sender.isOn)
  }
}

// MARK: - Appearance

private extension SquircleImageAndLabelWithSwitchCell {
  struct Appearance {
    let minInset: CGFloat = 3
    let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    let imageSize: CGFloat = 32
  }
}
