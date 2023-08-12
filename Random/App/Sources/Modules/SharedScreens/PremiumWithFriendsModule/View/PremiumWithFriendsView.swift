//
//  PremiumWithFriendsView.swift
//  Random
//
//  Created by Vitalii Sosin on 24.07.2023.
//

import UIKit
import FancyUIKit
import FancyStyle
import Lottie

/// События которые отправляем из View в Presenter
protocol PremiumWithFriendsViewOutput: AnyObject {
  
  /// Пользователь скопировал ссылку
  ///  - Parameter link: Ссылка
  func copyLinkAction(_ link: String?)
  
  /// Не показывать этот экран снова
  func doNotShowScreenAgain()
}

/// События которые отправляем от Presenter ко View
protocol PremiumWithFriendsViewInput {
  
  /// Запустить доадер
  func startLoader()
  
  /// Остановить лоадер
  func stopLoader()
  
  /// Обновить контент
  ///  - Parameter models: Массив моделек
  func updateContentWith(models: [PremiumWithFriendsTableViewModel])
}

/// Псевдоним протокола UIView & PremiumWithFriendsViewInput
typealias PremiumWithFriendsViewProtocol = UIView & PremiumWithFriendsViewInput

/// View для экрана
final class PremiumWithFriendsView: PremiumWithFriendsViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: PremiumWithFriendsViewOutput?
  
  // MARK: - Private properties
  
  private let tableView = TableView()
  private let lottieAnimationView = LottieAnimationView(name: Appearance().loaderImage)
  private var models: [PremiumWithFriendsTableViewModel] = []
  
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
  
  func updateContentWith(models: [PremiumWithFriendsTableViewModel]) {
    self.models = models
    tableView.reloadData()
  }
  
  func startLoader() {
    lottieAnimationView.isHidden = false
    tableView.isHidden = true
    lottieAnimationView.play()
  }
  
  func stopLoader() {
    lottieAnimationView.isHidden = true
    tableView.isHidden = false
    lottieAnimationView.stop()
  }
}

// MARK: - UITableViewDelegate

extension PremiumWithFriendsView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch models[indexPath.row] {
    case .insets(let inset):
      return CGFloat(inset)
    case .divider:
      return CGFloat(1)
    default:
      return UITableView.automaticDimension
    }
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return Appearance().estimatedHeight
  }
}

// MARK: - Private

private extension PremiumWithFriendsView {
  func configureLayout() {
    [tableView, lottieAnimationView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      lottieAnimationView.centerXAnchor.constraint(equalTo: centerXAnchor),
      lottieAnimationView.centerYAnchor.constraint(equalTo: centerYAnchor),
      lottieAnimationView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.5)
    ])
  }
  
  func applyDefaultBehavior() {
    backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    tableView.backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
    
    lottieAnimationView.isHidden = true
    lottieAnimationView.contentMode = .scaleAspectFit
    lottieAnimationView.loopMode = .loop
    lottieAnimationView.animationSpeed = Appearance().animationSpeed
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    
    tableView.register(CustomPaddingCell.self,
                       forCellReuseIdentifier: CustomPaddingCell.reuseIdentifier)
    tableView.register(DividerTableViewCell.self,
                       forCellReuseIdentifier: DividerTableViewCell.reuseIdentifier)
    tableView.register(CustomTextCell.self,
                       forCellReuseIdentifier: CustomTextCell.reuseIdentifier)
    tableView.register(ReferralProgramTableViewCell.self,
                       forCellReuseIdentifier: ReferralProgramTableViewCell.reuseIdentifier)
    tableView.register(SmallButtonCell.self,
                       forCellReuseIdentifier: SmallButtonCell.reuseIdentifier)
  }
}

// MARK: - UITableViewDataSource

extension PremiumWithFriendsView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = models[indexPath.row]
    var viewCell = UITableViewCell()
    
    switch model {
    case let .insets(inset):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: CustomPaddingCell.reuseIdentifier
      ) as? CustomPaddingCell {
        cell.configureCellWith(height: CGFloat(inset))
        cell.backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
        cell.contentView.backgroundColor = fancyColor.darkAndLightTheme.primaryWhite
        viewCell = cell
      }
    case let .referal(lottieAnimationJSONName, title, firstStepTitle,
                      link, secondStepTitle, circleStepsTitle, currentStep, maxSteps):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: ReferralProgramTableViewCell.reuseIdentifier
      ) as? ReferralProgramTableViewCell {
        cell.configureCellWith(
          lottieAnimationJSONName: lottieAnimationJSONName,
          title: title,
          firstStepTitle: firstStepTitle,
          link: link,
          secondStepTitle: secondStepTitle,
          circleStepsTitle: circleStepsTitle,
          currentStep: currentStep,
          maxSteps: maxSteps) { [weak self] link in
            self?.output?.copyLinkAction(link)
          }
        viewCell = cell
      }
    case let .text(text):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: CustomTextCell.reuseIdentifier
      ) as? CustomTextCell {
        cell.configureCellWith(
          titleText: text,
          textColor: fancyColor.only.lightGray,
          textFont: RandomFont.primaryRegular14,
          textAlignment: .left
        )
        viewCell = cell
      }
    case .divider:
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: DividerTableViewCell.reuseIdentifier
      ) as? DividerTableViewCell {
        viewCell = cell
      }
    case let .smallButton(title):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: SmallButtonCell.reuseIdentifier
      ) as? SmallButtonCell {
        cell.action = { [weak self] in
          self?.output?.doNotShowScreenAgain()
        }
        cell.configureCellWith(titleButton: title)
        viewCell = cell
      }
    }
    return viewCell
  }
}

// MARK: - Appearance

private extension PremiumWithFriendsView {
  struct Appearance {
    let loaderImage = RandomAsset.filmsLoader.name
    let animationSpeed: CGFloat = 0.5
    let estimatedHeight: CGFloat = 70
  }
}
