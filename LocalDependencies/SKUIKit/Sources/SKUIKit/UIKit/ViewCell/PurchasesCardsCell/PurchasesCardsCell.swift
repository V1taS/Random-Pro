//
//  PurchasesCardsCell.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import UIKit
import SKStyle

// MARK: - PurchasesCardsCell

public final class PurchasesCardsCell: UITableViewCell {
  
  // MARK: - Public properties
  
  /// Identifier для ячейки
  public static let reuseIdentifier = PurchasesCardsCell.description()
  
  // MARK: - Private properties
  
  private let leftSideButton = PurchasesCardView()
  private let centerButton = PurchasesCardView()
  private let rightSideButton = PurchasesCardView()
  private let stackButtons = UIStackView()
  private var leftSideButtonAction: (() -> Void)?
  private var centerButtonAction: (() -> Void)?
  private var rightSideButtonAction: (() -> Void)?
  
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
  /// - Parameter models: Модельки с карточками
  public func configureCellWith(models: [PurchasesCardsCellModel]) {
    models.enumerated().forEach { model in
      if model.offset == .zero {
        leftSideButton.configureWith(header: model.element.header,
                                     title: model.element.title,
                                     description: model.element.description,
                                     amount: model.element.amount,
                                     isSelected: false,
                                     action: { [weak self] in
          model.element.action?()
          self?.leftSideButtonAction?()
        })
      } else if model.offset == 1  {
        centerButton.configureWith(header: model.element.header,
                                   title: model.element.title,
                                   description: model.element.description,
                                   amount: model.element.amount,
                                   isSelected: true,
                                   action: { [weak self] in
          model.element.action?()
          self?.centerButtonAction?()
        })
      } else if model.offset == 2 {
        rightSideButton.configureWith(header: model.element.header,
                                      title: model.element.title,
                                      description: model.element.description,
                                      amount: model.element.amount,
                                      isSelected: false,
                                      action: { [weak self] in
          model.element.action?()
          self?.rightSideButtonAction?()
        })
      }
    }
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    [leftSideButton, centerButton, rightSideButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      stackButtons.addArrangedSubview($0)
    }
    
    [stackButtons].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      stackButtons.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                            constant: appearance.midInset),
      stackButtons.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                             constant: -appearance.midInset),
      stackButtons.topAnchor.constraint(equalTo: contentView.topAnchor,
                                        constant: appearance.minInset),
      stackButtons.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                           constant: -appearance.minInset)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = SKStyleAsset.onyx.color
    contentView.backgroundColor = SKStyleAsset.onyx.color
    selectionStyle = .none
    
    stackButtons.distribution = .fillEqually
    stackButtons.axis = .horizontal
    stackButtons.spacing = Appearance().minInset
    
    leftSideButtonAction = { [weak self] in
      UIView.animate(withDuration: 0.2) { [weak self] in
        guard let self else {
          return
        }
        
        self.leftSideButton.setIsSelected(true)
        self.centerButton.setIsSelected(false)
        self.rightSideButton.setIsSelected(false)
      }
    }
    
    centerButtonAction = { [weak self] in
      UIView.animate(withDuration: 0.2) { [weak self] in
        guard let self else {
          return
        }
        
        self.leftSideButton.setIsSelected(false)
        self.centerButton.setIsSelected(true)
        self.rightSideButton.setIsSelected(false)
      }
    }
    
    rightSideButtonAction = { [weak self] in
      UIView.animate(withDuration: 0.2) { [weak self] in
        guard let self else {
          return
        }
        
        self.leftSideButton.setIsSelected(false)
        self.centerButton.setIsSelected(false)
        self.rightSideButton.setIsSelected(true)
      }
    }
  }
}

// MARK: - Appearance

private extension PurchasesCardsCell {
  struct Appearance {
    let minInset: CGFloat = 4
    let midInset: CGFloat = 8
    let defaultInsets: CGFloat = 16
  }
}

