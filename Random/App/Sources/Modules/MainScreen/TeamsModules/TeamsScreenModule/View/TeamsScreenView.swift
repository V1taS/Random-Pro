//
//  TeamsScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из View в Presenter
protocol TeamsScreenViewOutput: AnyObject {
  
  /// Обновить количество команд
  ///  - Parameter count: Количество команд
  func updateTeams(count: Int)
    
  /// Показать алерт для обновления названия команды
  /// - Parameters:
  ///   - name: название команды
  ///   - id: id команды
  func showAlert(name: String, id: String)
}

/// События которые отправляем от Presenter ко View
protocol TeamsScreenViewInput {
  
  /// Обновить контент
  /// - Parameters:
  ///   - models: Список команд
  ///   - teamsCount: Количество команд
  func updateContentWith(models: [TeamsScreenModel.Team], teamsCount: Int)
  
  /// Показать заглушка
  ///  - Parameter isShow: Показать заглушку
  func plugIsShow( _ isShow: Bool)
  
  ///  Получить изображение контента
  func returnCurrentContentImage(completion: @escaping (Data?) -> Void)
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
  private var isShowEditImage = true
  private let resultLabel = UILabel()
  private let contentPlugImage = UIImageView()
  
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
  
  func returnCurrentContentImage(completion: @escaping (Data?) -> Void) {
    showContentPlug()
    isShowEditImage = false
    collectionView.reloadData()
    
    return collectionView.screenShotFullContent { [weak self] screenshot in
      let imgData = screenshot?.pngData()
      completion(imgData)
      self?.hideContentPlug()
      self?.isShowEditImage = true
      self?.collectionView.reloadData()
    }
  }
}

// MARK: - UICollectionViewDelegate

extension TeamsScreenView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
  
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    guard let headerView = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: CustomDoubleTextHeaderCollectionCell.reuseIdentifier,
      for: indexPath) as? CustomDoubleTextHeaderCollectionCell else {
      return UICollectionReusableView()
    }
    
    let model = models[indexPath.section]
    
    headerView.configureCellWith(
      primaryText: model.name,
      primaryTextColor: fancyColor.darkAndLightTheme.primaryGray,
      primaryTextFont: fancyFont.primaryBold18,
      secondaryText: "\(Appearance().countPlayersTitle) - \(model.players.count)",
      secondaryTextColor: fancyColor.darkAndLightTheme.secondaryGray,
      secondaryTextFont: fancyFont.primaryRegular18,
      editImage: isShowEditImage ? Appearance().renameTeamButton : nil) {
        self.output?.showAlert(name: model.name, id: model.id)
      }
    headerView.backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
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
      avatar: UIImage(named: player.avatar),
      name: player.name,
      styleCard: player.style,
      styleEmoji: .customEmoji(Character(player.emoji ?? " "))
    )
    return cell
  }
}

// MARK: - Private

private extension TeamsScreenView {
  func showContentPlug() {
    contentPlugImage.isHidden = false
    contentPlugImage.image = self.asImage
  }
  
  func hideContentPlug() {
    contentPlugImage.isHidden = true
    contentPlugImage.image = nil
  }
  
  func configureLayout() {
    let appearance = Appearance()
    
    [countTeamsSegmentedControl, collectionView, resultLabel, contentPlugImage].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      countTeamsSegmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                      constant: appearance.defaultInset / 2),
      countTeamsSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                          constant: appearance.defaultInset),
      countTeamsSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                           constant: -appearance.defaultInset),
      
      resultLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: appearance.defaultInset),
      resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.defaultInset),
      
      collectionView.topAnchor.constraint(equalTo: countTeamsSegmentedControl.bottomAnchor,
                                          constant: appearance.minInset),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      contentPlugImage.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentPlugImage.topAnchor.constraint(equalTo: topAnchor),
      contentPlugImage.trailingAnchor.constraint(equalTo: trailingAnchor),
      contentPlugImage.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    
    resultLabel.font = fancyFont.primaryBold70
    resultLabel.textColor = fancyColor.darkAndLightTheme.primaryGray
    resultLabel.textAlignment = .center
    resultLabel.numberOfLines = .zero
    resultLabel.text = appearance.resultLabelTitle
    resultLabel.isHidden = true
    
    contentPlugImage.isHidden = true
    
    countTeamsSegmentedControl.selectedSegmentIndex = appearance.selectedSegmentIndex
    countTeamsSegmentedControl.addTarget(self,
                                         action: #selector(countTeamsSegmentedControlAction),
                                         for: .valueChanged)
    
    collectionView.backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    collectionView.showsVerticalScrollIndicator = false
    collectionView.alwaysBounceVertical = true
    collectionView.register(PlayerCollectionViewCell.self,
                            forCellWithReuseIdentifier: PlayerCollectionViewCell.reuseIdentifier)
    collectionView.register(CustomDoubleTextHeaderCollectionCell.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: CustomDoubleTextHeaderCollectionCell.reuseIdentifier)
    
    collectionViewLayout.sectionInset = appearance.sectionInset
    collectionViewLayout.scrollDirection = .vertical
    collectionViewLayout.minimumInteritemSpacing = .zero
    collectionViewLayout.minimumLineSpacing = appearance.defaultInset
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

// MARK: - Appearance

private extension TeamsScreenView {
  struct Appearance {
    let sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
    let cellWidthConstant: CGFloat = 90
    let estimatedRowHeight: CGFloat = 100
    let collectionHeaderHeight: CGFloat = 32
    
    let minInset: CGFloat = 8
    let defaultInset: CGFloat = 16
    let selectedSegmentIndex = 2
    
    let resultLabelTitle = "?"
    let countTeams = ["1", "2", "3", "4", "5", "6"]
    let countPlayersTitle = RandomStrings.Localizable.numberOf
    let renameTeamButton = UIImage(systemName: "pencil")
  }
}
