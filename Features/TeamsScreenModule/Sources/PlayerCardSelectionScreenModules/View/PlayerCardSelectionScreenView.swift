//
//  PlayerCardSelectionScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 07.02.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol PlayerCardSelectionScreenViewOutput: AnyObject {
  
  /// Нет премиум доступа
  func noPremiumAccessAction()
  
  /// Выбрана карточка
  /// - Parameters:
  ///  - style: Выбран стиль карточки
  ///  - models: Общий список
  func didSelect(style: PlayerView.StyleCard, with models: [PlayerCardSelectionScreenModel])
  
  /// Успешно выбран стиль карточки
  func didSelectStyleSuccessfully()
}

/// События которые отправляем от Presenter ко View
protocol PlayerCardSelectionScreenViewInput {
  
  /// Обновить контент
  /// - Parameter models: Список моделек
  func updateContentWith(models: [PlayerCardSelectionScreenModel])
}

/// Псевдоним протокола UIView & PlayerCardSelectionScreenViewInput
typealias PlayerCardSelectionScreenViewProtocol = UIView & PlayerCardSelectionScreenViewInput

/// View для экрана
final class PlayerCardSelectionScreenView: PlayerCardSelectionScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: PlayerCardSelectionScreenViewOutput?
  
  // MARK: - Private properties
  
  private let collectionViewLayout = UICollectionViewFlowLayout()
  private lazy var collectionView = UICollectionView(frame: .zero,
                                                     collectionViewLayout: collectionViewLayout)
  private var models: [PlayerCardSelectionScreenModel] = []
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  func updateContentWith(models: [PlayerCardSelectionScreenModel]) {
    self.models = models
    collectionView.reloadData()
  }
}

// MARK: - Private

private extension PlayerCardSelectionScreenView {
  func configureLayout() {
    [collectionView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    collectionView.backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    collectionView.showsVerticalScrollIndicator = false
    collectionView.alwaysBounceVertical = true
    collectionView.register(PlayerCollectionViewCell.self,
                            forCellWithReuseIdentifier: PlayerCollectionViewCell.reuseIdentifier)
    
    collectionViewLayout.sectionInset = appearance.sectionInset
    collectionViewLayout.scrollDirection = .vertical
    collectionViewLayout.minimumInteritemSpacing = 8
    collectionViewLayout.minimumLineSpacing = appearance.defaultInset
    collectionViewLayout.itemSize = CGSize(width: appearance.cellWidthConstant,
                                           height: appearance.estimatedRowHeight)
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

// MARK: - UICollectionViewDelegate

extension PlayerCardSelectionScreenView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    let appearance = Appearance()
    let totalWidth = appearance.cellWidthConstant * appearance.maxCardInLine
    let totalSpacingWidth = appearance.spacingBetweenWidth * (appearance.maxCardInLine - 1)
    let leftInset = (collectionView.frame.width - CGFloat(totalWidth + totalSpacingWidth)) / 2
    let rightInset = leftInset
    return UIEdgeInsets(top: appearance.minInset, left: leftInset, bottom: .zero, right: rightInset)
  }
}

// MARK: - UICollectionViewDelegate

extension PlayerCardSelectionScreenView: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource

extension PlayerCardSelectionScreenView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return models.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: PlayerCollectionViewCell.reuseIdentifier,
      for: indexPath
    ) as? PlayerCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    let model = models[indexPath.row]
    let modelStyle = (model.style as? PlayerCardSelectionScreenModel.StyleCard) ?? .defaultStyle
    var styleCard: PlayerView.StyleCard
    
    switch modelStyle {
    case .defaultStyle:
      styleCard = .defaultStyle
    case .darkGreen:
      styleCard = .darkGreen
    case .darkBlue:
      styleCard = .darkBlue
    case .darkOrange:
      styleCard = .darkOrange
    case .darkRed:
      styleCard = .darkRed
    case .darkPurple:
      styleCard = .darkPurple
    case .darkPink:
      styleCard = .darkPink
    case .darkYellow:
      styleCard = .darkYellow
    }
    
    cell.configureCellWith(avatar: UIImage(named: model.avatar),
                           name: model.name,
                           styleCard: styleCard,
                           styleEmoji: .none,
                           setIsCheckmark: model.playerCardSelection,
                           setIsLocked: !model.isPremium,
                           emojiAction: {},
                           cardAction: { [weak self] in
      guard let self else {
        return
      }
      
      if modelStyle == .defaultStyle {
        self.output?.didSelect(style: styleCard, with: self.models)
        self.output?.didSelectStyleSuccessfully()
      } else if model.isPremium {
        self.output?.didSelect(style: styleCard, with: self.models)
        self.output?.didSelectStyleSuccessfully()
      } else {
        self.output?.noPremiumAccessAction()
      }
    })
    return cell
  }
}

// MARK: - Appearance

private extension PlayerCardSelectionScreenView {
  struct Appearance {
    let sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
    let maxCardInLine: CGFloat = 2
    let spacingBetweenWidth: CGFloat = 32
    
    let minInset: CGFloat = 8
    let defaultInset: CGFloat = 16
    
    let cellWidthConstant: CGFloat = UIScreen.main.bounds.width * 0.35
    let estimatedRowHeight: CGFloat = UIScreen.main.bounds.width * 0.38
  }
}
