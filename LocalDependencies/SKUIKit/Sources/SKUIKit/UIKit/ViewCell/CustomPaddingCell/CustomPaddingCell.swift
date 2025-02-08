//
//  CustomPaddingCell.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import UIKit
import SKStyle

// MARK: - CustomPaddingCell

public final class CustomPaddingCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Identifier для ячейки
  public static let reuseIdentifier = CustomPaddingCell.description()
  
  // MARK: - Initilisation
  
  public override init(style: CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    applyDefaultBehavior()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Public func

  public override func prepareForReuse() {
    super.prepareForReuse()
    layer.cornerRadius = .zero
  }

  /// Настраиваем ячейку
  /// - Parameter height: Высота ячейки
  public func configureCellWith(height: CGFloat) {
    NSLayoutConstraint.activate([
      contentView.heightAnchor.constraint(equalToConstant: height)
    ])
    setNeedsLayout()
  }
  
  // MARK: - Private func
  
  private func applyDefaultBehavior() {
    backgroundColor = SKStyleAsset.onyx.color
    contentView.backgroundColor = SKStyleAsset.onyx.color
    selectionStyle = .none
  }
}
