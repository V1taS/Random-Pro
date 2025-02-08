//
//  TextFielAddPlayerCell.swift
//
//  Created by Vitalii Sosin on 16.09.2022.
//

import UIKit
import FancyStyle

// MARK: - TextFielAddPlayerCell

public final class TextFielAddPlayerCell: UITableViewCell {
  
  // MARK: - Public properties
  
  /// Identifier для ячейки
  public static let reuseIdentifier = TextFielAddPlayerCell.description()
  
  // MARK: - Private property
  
  private var textField: TextFieldView?
  private let buttonImageView = UIImageView()
  private var buttonAction: (() -> Void)?
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  private let segmentedGender = UISegmentedControl()
  private var genderValueChanged: ((_ selectedSegmentIndex: Int) -> Void)?
  
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
  ///  - listGender: Список Женского и Мужского пола
  ///  - buttonAction: Действие по нажатию на кнопку
  ///  - genderValueChanged: Пол игрока изменился
  public func configureCellWith(textField: TextFieldView,
                                textFieldBorderColor: UIColor? = nil,
                                buttonImage: UIImage?,
                                buttonImageColor: UIColor? = .fancy.only.primaryGreen,
                                listGender: [String],
                                buttonAction: (() -> Void)? = nil,
                                genderValueChanged: ((_ selectedSegmentIndex: Int) -> Void)? = nil) {
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
    
    if segmentedGender.numberOfSegments == .zero {
      listGender.enumerated().forEach { index, title in
        segmentedGender.insertSegment(withTitle: title, at: index, animated: false)
      }
      
      segmentedGender.selectedSegmentIndex = .zero
    }

    self.genderValueChanged = genderValueChanged
  }

  public override func prepareForReuse() {
    super.prepareForReuse()
    layer.cornerRadius = .zero
  }
  
  // MARK: - Private func
  
  private func configureLayout(textField: TextFieldView) {
    let appearance = Appearance()
    
    [textField, buttonImageView, segmentedGender].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      buttonImageView.widthAnchor.constraint(equalToConstant: appearance.buttonSize.width),
      buttonImageView.heightAnchor.constraint(equalToConstant: appearance.buttonSize.height),
      segmentedGender.widthAnchor.constraint(equalToConstant: appearance.segmentedGenderWidth),
      segmentedGender.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      segmentedGender.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: appearance.insets.left),
      
      textField.leadingAnchor.constraint(equalTo: segmentedGender.trailingAnchor,
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
    
    segmentedGender.addTarget(self,
                              action: #selector(segmentedGenderValueChanged),
                              for: .valueChanged)
  }
  
  @objc
  private func segmentedGenderValueChanged() {
    guard genderValueChanged != nil else {
      return
    }
    genderValueChanged?(segmentedGender.selectedSegmentIndex)
    impactFeedback.impactOccurred()
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

private extension TextFielAddPlayerCell {
  struct Appearance {
    let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    let buttonSize = CGSize(width: 44, height: 44)
    let segmentedGenderWidth: CGFloat = 100
    let resultDuration: CGFloat = 0.2
  }
}
