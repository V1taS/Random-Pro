//
//  SquircleImageAndLabelWithSegmentedControlCell.swift
//  RandomUIKitExample
//
//  Created by Artem Pavlov on 05.05.2023.
//

import UIKit
import FancyStyle

// MARK: - SquircleImageAndLabelWithSegmentedControlCell

public final class SquircleImageAndLabelWithSegmentedControlCell: UITableViewCell {

  // MARK: - Public property

  /// Identifier для ячейки
  public static let reuseIdentifier = SquircleImageAndLabelWithSegmentedControlCell.description()

  // MARK: - Private property

  private let titleLabel = UILabel()
  private let leftSideImageView = UIImageView()
  private let leftSideSquircleView = SquircleView()
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
  ///  - squircleBGColors: Squircle цвет фона
  ///  - squircleBGAlpha: Squircle прозрачность
  ///  - leftSideImage: Картинка слева в squircle
  ///  - leftSideImageColor: Цвет картинки слева
  ///  - titleText: Заголовок у ячейки
  ///  - startSelectedSegmentIndex: Первоначально выбранный элемент у SegmentedControl
  ///  - listOfItemsInSegmentedControl: Список элементов у SegmentedControl
  ///  - segmentControlValueChanged: Выбранный элемент у SegmentedControl изменился
  public func configureCellWith(squircleBGColors: [UIColor],
                                squircleBGAlpha: CGFloat = 1,
                                leftSideImage: UIImage?,
                                leftSideImageColor: UIColor?,
                                titleText: String?,
                                startSelectedSegmentIndex: Int = .zero,
                                listOfItemsInSegmentedControl: [String],
                                segmentControlValueChanged: ((_ selectedSegmentIndex: Int) -> Void)? = nil) {
    titleLabel.text = titleText
    leftSideImageView.image = leftSideImage
    leftSideImageView.setImageColor(color: leftSideImageColor ?? .fancy.darkAndLightTheme.primaryGray)
    leftSideSquircleView.applyGradient(colors: squircleBGColors,
                                       alpha: squircleBGAlpha)

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

    [leftSideImageView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      leftSideSquircleView.addSubview($0)
    }

    [titleLabel, segmentedControl, leftSideSquircleView].forEach {
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

      segmentedControl.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -appearance.insets.right),
      segmentedControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
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

private extension SquircleImageAndLabelWithSegmentedControlCell {
  struct Appearance {
    let minInset: CGFloat = 3
    let insets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    let imageSize: CGFloat = 32
  }
}
