//
//  DividerTableViewCell.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import UIKit
import SKStyle

// MARK: - DividerTableViewCell

public final class DividerTableViewCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Identifier для ячейки
  public static let reuseIdentifier = DividerTableViewCell.description()
  
  // MARK: - Private property
  
  private let dividerView = UIView()
  
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
  /// - Parameter isHidden: Скрыть разделитель
  public func configureCellWith(isHidden: Bool = false) {
    dividerView.isHidden = isHidden
  }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    layer.cornerRadius = .zero
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    [dividerView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      dividerView.heightAnchor.constraint(equalToConstant: Appearance().heightDividerView),
      
      dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                           constant: appearance.insets.left),
      dividerView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                       constant: appearance.insets.top),
      dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                            constant: -appearance.insets.right),
      dividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                          constant: -appearance.insets.bottom)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = SKStyleAsset.onyx.color
    contentView.backgroundColor = SKStyleAsset.onyx.color
    selectionStyle = .none
    
    dividerView.backgroundColor = SKStyleAsset.constantSlate.color.withAlphaComponent(0.5)
  }
}

// MARK: - Appearance

private extension DividerTableViewCell {
  struct Appearance {
    let insets = UIEdgeInsets(top: .zero, left: 16, bottom: .zero, right: .zero)
    let heightDividerView: CGFloat = 1
  }
}

