//
//  BottleStyleSelectionScreenView.swift
//  Random
//
//  Created by Artem Pavlov on 16.08.2023.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из View в Presenter
protocol BottleStyleSelectionScreenViewOutput: AnyObject {
  
  /// Нет премиум доступа
  func noPremiumAccessAction()
  
  /// Выбрана карточка
  /// - Parameters:
  ///  - style: Выбран стиль бутылочки
  ///  - models: Общий список стилей бутылочки
  func didSelect(style: BottleStyleSelectionScreenModel.BottleStyle, with models: [BottleStyleSelectionScreenModel])
  
  /// Успешно выбран стиль карточки
  func didSelectStyleSuccessfully()
}

/// События которые отправляем от Presenter ко View
protocol BottleStyleSelectionScreenViewInput {

  /// Обновить контент
  /// - Parameter models: Список моделек стилей бутылочки
  func updateContentWith(models: [BottleStyleSelectionScreenModel])
}

/// Псевдоним протокола UIView & BottleStyleSelectionScreenViewInput
typealias BottleStyleSelectionScreenViewProtocol = UIView & BottleStyleSelectionScreenViewInput

/// View для экрана
final class BottleStyleSelectionScreenView: BottleStyleSelectionScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: BottleStyleSelectionScreenViewOutput?
  
  // MARK: - Private properties

  private let collectionViewLayout = UICollectionViewFlowLayout()
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
  private var models: [BottleStyleSelectionScreenModel] = []
  
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

  func updateContentWith(models: [BottleStyleSelectionScreenModel]) {
    self.models = models
    collectionView.reloadData()
  }
}

// MARK: - Private

private extension BottleStyleSelectionScreenView {
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

    backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    collectionView.backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    collectionView.showsVerticalScrollIndicator = false
    collectionView.alwaysBounceVertical = true
    collectionView.register(CardLockCollectionViewCell.self,
                            forCellWithReuseIdentifier: CardLockCollectionViewCell.reuseIdentifier)

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

// MARK: - UICollectionViewDelegateFlowLayout

extension BottleStyleSelectionScreenView: UICollectionViewDelegateFlowLayout {
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

extension BottleStyleSelectionScreenView: UICollectionViewDelegate {}

// MARK: - UICollectionViewDataSource

extension BottleStyleSelectionScreenView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return models.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: CardLockCollectionViewCell.reuseIdentifier,
      for: indexPath
    ) as? CardLockCollectionViewCell else {
      return UICollectionViewCell()
    }

    let model = models[indexPath.row]
    var state = CardLockView.CardState.none

    switch model.bottleState {
    case .lock:
      state = .lock
    case .checkmark:
      state = .checkmark
    case .none:
      state = .none
    }

    cell.configureCellWith(image: UIImage(named: model.bottleStyle.rawValue),
                           title: nil,
                           cardState: state,
                           cardAction: { [weak self] in
      guard let self else {
        return
      }

      //действие
    })

    return cell
  }
}

// MARK: - Appearance

private extension BottleStyleSelectionScreenView {
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
