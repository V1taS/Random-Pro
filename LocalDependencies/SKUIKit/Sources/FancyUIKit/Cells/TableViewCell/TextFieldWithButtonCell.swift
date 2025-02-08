//
//  TextFieldWithButtonCell.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 13.08.2022.
//

import UIKit
import FancyStyle

// MARK: - TextFieldWithButtonCell

public final class TextFieldWithButtonCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Identifier для ячейки
  public static let reuseIdentifier = TextFieldWithButtonCell.description()
  
  // MARK: - Private property
  
  private var textField: TextFieldView?
  private let buttonImageView = UIImageView()
  private var buttonAction: (() -> Void)?
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initilisation
  
  public override init(style: CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    applyDefaultBehavior()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Public func
  
  /// Настраиваем ячейку
  /// - Parameters:
  ///  - textField: Текстовое поле
  ///  - textFieldBorderColor: Цвет оконтовки
  ///  - buttonImage: Иконка кнопки
  ///  - buttonImageColor: Цвет изображения кнопки
  ///  - buttonAction: Действие по нажатию на кнопку
  public func configureCellWith(textField: TextFieldView,
                                textFieldBorderColor: UIColor? = nil,
                                buttonImage: UIImage?,
                                buttonImageColor: UIColor? = .fancy.only.primaryGreen,
                                buttonAction: (() -> Void)? = nil) {
    self.textField = textField
    
    if let textFieldBorderColor = textFieldBorderColor {
      self.textField?.layer.borderColor = textFieldBorderColor.cgColor
    }
    
    self.buttonAction = buttonAction
    buttonImageView.image = buttonImage
    
    if let buttonImageColor = buttonImageColor {
      buttonImageView.setImageColor(color: buttonImageColor)
    }
    configureLayout(textField: textField)
  }

  public override func prepareForReuse() {
    super.prepareForReuse()
    layer.cornerRadius = .zero
  }
  
  // MARK: - Private func
  
  private func configureLayout(textField: TextFieldView) {
    let appearance = Appearance()
    
    [textField, buttonImageView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      buttonImageView.widthAnchor.constraint(equalToConstant: appearance.buttonSize.width),
      buttonImageView.heightAnchor.constraint(equalToConstant: appearance.buttonSize.height),
      
      textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                         constant: appearance.insets.left),
      textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      
      buttonImageView.leadingAnchor.constraint(equalTo: textField.trailingAnchor),
      buttonImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      buttonImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -appearance.insets.right),
      buttonImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    selectionStyle = .none
    
    buttonImageView.contentMode = .right
    
    let buttonImageTap = UITapGestureRecognizer(target: self, action: #selector(buttonTappedAction))
    buttonImageTap.cancelsTouchesInView = false
    buttonImageView.addGestureRecognizer(buttonImageTap)
    buttonImageView.isUserInteractionEnabled = true
  }
  
  @objc
  private func buttonTappedAction() {
    guard buttonAction != nil else {
      return
    }
    buttonAction?()
    impactFeedback.impactOccurred()
    buttonImageView.zoomIn(duration: Appearance().resultDuration,
                           transformScale: CGAffineTransform(scaleX: 0.95, y: 0.95))
  }
}

// MARK: - Appearance

private extension TextFieldWithButtonCell {
  struct Appearance {
    let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    let buttonSize = CGSize(width: 44, height: 44)
    let resultDuration: CGFloat = 0.2
  }
}
