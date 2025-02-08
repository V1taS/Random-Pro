//
//  LabelWithSegmentedControlCell.swift
//  
//
//  Created by Vitalii Sosin on 28.05.2023.
//

import UIKit
import FancyStyle

// MARK: - LabelWithSegmentedControlCell

public final class LabelWithSegmentedControlCell: UITableViewCell {
  
  // MARK: - Public property
  
  /// Identifier для ячейки
  public static let reuseIdentifier = LabelWithSegmentedControlCell.description()
  
  // MARK: - Private property
  
  private let titleLabel = UILabel()
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  private let segmentedControl = UISegmentedControl()
  private var segmentControlValueChanged: ((_ selectedSegmentIndex: Int) -> Void)?
  
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
  ///  - titleText: Заголовок у ячейки
  ///  - startSelectedSegmentIndex: Первоначально выбранный элемент у SegmentedControl
  ///  - listOfItemsInSegmentedControl: Список элементов у SegmentedControl
  ///  - segmentControlValueChanged: Выбранный элемент у SegmentedControl изменился
  public func configureCellWith(titleText: String?,
                                startSelectedSegmentIndex: Int = .zero,
                                listOfItemsInSegmentedControl: [String],
                                segmentControlValueChanged: ((_ selectedSegmentIndex: Int) -> Void)? = nil) {
    titleLabel.text = titleText
    
    if segmentedControl.numberOfSegments == .zero {
      listOfItemsInSegmentedControl.enumerated().forEach { index, title in
        segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
      }
    }
    
    segmentedControl.selectedSegmentIndex = startSelectedSegmentIndex
    self.segmentControlValueChanged = segmentControlValueChanged
  }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    layer.cornerRadius = .zero
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [titleLabel, segmentedControl].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                          constant: appearance.insets.left),
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      
      segmentedControl.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor,
                                                constant: appearance.insets.left),
      segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor,
                                            constant: appearance.insets.top),
      segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -appearance.insets.right),
      segmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                               constant: -appearance.insets.bottom)
    ])
  }
  
  private func applyDefaultBehavior() {
    backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    contentView.backgroundColor = .fancy.darkAndLightTheme.primaryWhite
    selectionStyle = .none
    
    titleLabel.font = fancyFont.primaryRegular18
    titleLabel.textColor = .fancy.darkAndLightTheme.primaryGray
    titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    
    segmentedControl.setContentHuggingPriority(.required, for: .horizontal)
    segmentedControl.addTarget(self,
                               action: #selector(segmentedSelectedItemChanged),
                               for: .valueChanged)
  }
  
  @objc private func segmentedSelectedItemChanged() {
    guard let segmentControlValueChanged else {
      return
    }
    segmentControlValueChanged(segmentedControl.selectedSegmentIndex)
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension LabelWithSegmentedControlCell {
  struct Appearance {
    let minInset: CGFloat = 3
    let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: .zero)
    let imageSize: CGFloat = 32
  }
}
