//
//  TeamsScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol TeamsScreenViewOutput: AnyObject {
  
}

/// События которые отправляем от Presenter ко View
protocol TeamsScreenViewInput: AnyObject {
  
}

/// Псевдоним протокола UIView & TeamsScreenViewInput
typealias TeamsScreenViewProtocol = UIView & TeamsScreenViewInput

/// View для экрана
final class TeamsScreenView: TeamsScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: TeamsScreenViewOutput?
  
  // MARK: - Private properties
  
  private let collectionViewLayout = UICollectionViewFlowLayout()
  private lazy var collectionView = UICollectionView(frame: .zero,
                                                     collectionViewLayout: collectionViewLayout)
  private var models: [Int] = [1, 2, 3, 4, 5, 6]
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [collectionView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor,
                                          constant: appearance.collectionViewInsets.top),
      collectionView.leftAnchor.constraint(equalTo: leftAnchor,
                                           constant: appearance.collectionViewInsets.left),
      collectionView.rightAnchor.constraint(equalTo: rightAnchor,
                                            constant: -appearance.collectionViewInsets.right),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                             constant: -appearance.collectionViewInsets.bottom),
    ])
  }
  
  private func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.primaryWhite
    
    collectionView.backgroundColor = RandomColor.primaryWhite
    
    collectionView.alwaysBounceVertical = true
    collectionView.register(PlayerCollectionViewCell.self,
                            forCellWithReuseIdentifier: PlayerCollectionViewCell.reuseIdentifier)
    collectionView.register(CustomDoubleTextHeaderCollectionCell.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: CustomDoubleTextHeaderCollectionCell.reuseIdentifier)
    
    collectionViewLayout.sectionInset = appearance.sectionInset
    collectionViewLayout.scrollDirection = .vertical
    collectionViewLayout.minimumInteritemSpacing = .zero
    collectionViewLayout.minimumLineSpacing = 12
    collectionViewLayout.headerReferenceSize = CGSize(width: collectionView.frame.size.width,
                                                      height: 32)
    collectionViewLayout.itemSize = CGSize(width: appearance.cellWidthConstant,
                                           height: appearance.estimatedRowHeight)
    
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

// MARK: - UICollectionViewDelegate

extension TeamsScreenView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let headerView = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: CustomDoubleTextHeaderCollectionCell.reuseIdentifier,
      for: indexPath) as! CustomDoubleTextHeaderCollectionCell

    headerView.configureCellWith(
      primaryText: "Команда номер 1",
      primaryTextColor: RandomColor.primaryGray,
      primaryTextFont: RandomFont.primaryBold18,
      secondaryText: "5",
      secondaryTextColor: RandomColor.secondaryGray,
      secondaryTextFont: RandomFont.primaryRegular18
    )
    headerView.backgroundColor = RandomColor.tertiaryGray
    return headerView
  }
}

// MARK: - UICollectionViewDataSource

extension TeamsScreenView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return models.count
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    3
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: PlayerCollectionViewCell.reuseIdentifier,
      for: indexPath
    ) as? PlayerCollectionViewCell else {
      return UICollectionViewCell()
    }
    cell.configureCellWith(
      avatar: UIImage(named: "player12"),
      name: "Сосин Виталий",
      nameTextColor: RandomColor.primaryGray,
      styleCard: .defaultStyle,
      styleEmoji: .ball,
      isBorder: true,
      isShadow: true,
      emojiAction: {},
      cardAction: {}
    )
    return cell
  }
}

// MARK: - Appearance

private extension TeamsScreenView {
  struct Appearance {
    let collectionViewInsets: UIEdgeInsets = .zero
    let sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
    let cellWidthConstant: CGFloat = 90
    let estimatedRowHeight: CGFloat = 100
  }
}
