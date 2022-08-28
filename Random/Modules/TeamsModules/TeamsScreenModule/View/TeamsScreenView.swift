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
  
  /// Обновить количество команд
  ///  - Parameter count: Количество команд
  func updateTeams(count: Int)
}

/// События которые отправляем от Presenter ко View
protocol TeamsScreenViewInput: AnyObject {
  
  /// Обновить контент
  /// - Parameters:
  ///  - models: Список команд
  ///  - teamsCount: Количество команд
  func updateContentWith(models: [TeamsScreenModel.Team], teamsCount: Int)
  
  /// Показать заглушка
  ///  - Parameter isShow: Показать заглушку
  func plugIsShow( _ isShow: Bool)
  
  ///  Получить изображение контента
  func returnCurrentContentImage() -> Data?
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
  private let countTeamsSegmentedControl = UISegmentedControl(items: Appearance().countTeams)
  private var models: [TeamsScreenModel.Team] = []
  private let resultLabel = UILabel()
  
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
  
  func updateContentWith(models: [TeamsScreenModel.Team], teamsCount: Int) {
    self.models = models
    countTeamsSegmentedControl.selectedSegmentIndex = teamsCount - 1
    collectionView.reloadData()
  }
  
  func plugIsShow( _ isShow: Bool) {
    resultLabel.isHidden = !isShow
    collectionView.isHidden = isShow
  }
  
  func returnCurrentContentImage() -> Data? {
    guard let image = collectionView.asImage() else {
      return nil
    }
    return image.pngData()
  }
  
  // MARK: - Private func
  
  private func configureLayout() {
    let appearance = Appearance()
    
    [countTeamsSegmentedControl, collectionView, resultLabel].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      countTeamsSegmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      countTeamsSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                          constant: appearance.middleInset),
      countTeamsSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                           constant: -appearance.middleInset),
      
      resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.middleInset),
      resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.middleInset),
      
      collectionView.topAnchor.constraint(equalTo: countTeamsSegmentedControl.bottomAnchor,
                                          constant: appearance.minimumInset),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
  
  private func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.primaryWhite
    
    resultLabel.font = RandomFont.primaryBold70
    resultLabel.textColor = RandomColor.primaryGray
    resultLabel.textAlignment = .center
    resultLabel.numberOfLines = .zero
    resultLabel.text = appearance.resultLabelTitle
    resultLabel.isHidden = true
    
    countTeamsSegmentedControl.selectedSegmentIndex = appearance.selectedSegmentIndex
    countTeamsSegmentedControl.addTarget(self,
                                         action: #selector(countTeamsSegmentedControlAction),
                                         for: .valueChanged)
    
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
    collectionViewLayout.minimumLineSpacing = appearance.minimumLineSpacing
    collectionViewLayout.headerReferenceSize = CGSize(width: collectionView.frame.size.width,
                                                      height: appearance.collectionHeaderHeight)
    collectionViewLayout.itemSize = CGSize(width: appearance.cellWidthConstant,
                                           height: appearance.estimatedRowHeight)
    
    collectionView.delegate = self
    collectionView.dataSource = self
  }
  
  @objc
  func countTeamsSegmentedControlAction() {
    output?.updateTeams(count: countTeamsSegmentedControl.selectedSegmentIndex + 1)
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
    
    let model = models[indexPath.section]
    headerView.configureCellWith(
      primaryText: model.name,
      primaryTextColor: RandomColor.primaryGray,
      primaryTextFont: RandomFont.primaryBold18,
      secondaryText: "\(Appearance().countPlayersTitle) - \(model.players.count)",
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
    return models[section].players.count
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return models.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: PlayerCollectionViewCell.reuseIdentifier,
      for: indexPath
    ) as? PlayerCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    let player = models[indexPath.section].players[indexPath.row]
    cell.configureCellWith(
      avatar: UIImage(data: player.avatar ?? Data()),
      name: player.name,
      nameTextColor: RandomColor.primaryGray,
      styleCard: .defaultStyle,
      styleEmoji: .customEmoji(Character(player.emoji ?? " ")),
      isBorder: true,
      isShadow: true
    )
    return cell
  }
}

// MARK: - Appearance

private extension TeamsScreenView {
  struct Appearance {
    let sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
    let cellWidthConstant: CGFloat = 90
    let estimatedRowHeight: CGFloat = 100
    let countTeams = ["1", "2", "3", "4", "5", "6"]
    let countPlayersTitle = NSLocalizedString("Количество", comment: "")
    let middleInset: CGFloat = 16
    let minimumInset: CGFloat = 8
    let resultLabelTitle = "?"
    let selectedSegmentIndex = 1
    let minimumLineSpacing: CGFloat = 12
    let collectionHeaderHeight: CGFloat = 32
  }
}
