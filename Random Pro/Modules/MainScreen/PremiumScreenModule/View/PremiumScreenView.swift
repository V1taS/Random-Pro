//
//  PremiumScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol PremiumScreenViewOutput: AnyObject {}

/// События которые отправляем от Presenter ко View
protocol PremiumScreenViewInput {
  
  /// Обновить контент
  ///  - Parameter models: Массив моделек
  func updateContentWith(models: [PremiumScreenSectionType])
}

/// Псевдоним протокола UIView & PremiumScreenViewInput
typealias PremiumScreenViewProtocol = UIView & PremiumScreenViewInput

/// View для экрана
final class PremiumScreenView: PremiumScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: PremiumScreenViewOutput?
  
  // MARK: - Private properties
  
  private let tableView = TableView()
  private var models: [PremiumScreenSectionType] = []
  
  private let bottomContainerView = UIView()
  private let dividerView = UIView()
  private let restorePurchaseButton = SmallButtonView()
  private let mainButton = ButtonView()
  private let linkTextView = LinkTextView()
  
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
  
  func updateContentWith(models: [PremiumScreenSectionType]) {
    self.models = models
    tableView.reloadData()
  }
}

// MARK: - Private

private extension PremiumScreenView {
  func configureLayout() {
    let appearance = Appearance()
    
    [restorePurchaseButton, mainButton, linkTextView, dividerView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      bottomContainerView.addSubview($0)
    }
    
    [tableView, bottomContainerView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      
      bottomContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      bottomContainerView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
      bottomContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
      bottomContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      dividerView.heightAnchor.constraint(equalToConstant: 0.2),
      dividerView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor),
      dividerView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor),
      dividerView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor),
      
      restorePurchaseButton.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor,
                                                     constant: appearance.defaultInset),
      restorePurchaseButton.topAnchor.constraint(equalTo: dividerView.bottomAnchor,
                                                 constant: appearance.defaultInset),
      restorePurchaseButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor,
                                                      constant: -appearance.defaultInset),
      
      mainButton.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor,
                                          constant: appearance.defaultInset),
      mainButton.topAnchor.constraint(equalTo: restorePurchaseButton.bottomAnchor,
                                      constant: appearance.defaultInset),
      mainButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor,
                                           constant: -appearance.defaultInset),
      
      linkTextView.topAnchor.constraint(equalTo: mainButton.bottomAnchor,
                                        constant: appearance.defaultInset),
      linkTextView.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor),
      linkTextView.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor,
                                           constant: -32)
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.primaryWhite
    tableView.backgroundColor = RandomColor.primaryWhite
    
    dividerView.backgroundColor = UIColor(hexString: ColorToken.secondaryGray.rawValue)
    
    restorePurchaseButton.setTitle(appearance.restoreTitle, for: .normal)
    restorePurchaseButton.setTitleColor(RandomColor.primaryBlue, for: .normal)
    mainButton.setTitle(appearance.subscribeTitle, for: .normal)
    
    linkTextView.backgroundColor = .clear
    let termsConditionsAndPrivacyPolicy = "\(appearance.termsConditions) \(appearance.andTitle) \(appearance.privacyPolicy)"
    linkTextView.text = termsConditionsAndPrivacyPolicy
    linkTextView.addLinks([
      appearance.termsConditions: appearance.termsAndConditionsLink,
      appearance.privacyPolicy: appearance.privacyPolicyLink
    ])
    
    bottomContainerView.backgroundColor = RandomColor.primaryWhite
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.showsVerticalScrollIndicator = false
    
    tableView.register(OnboardingViewCell.self,
                       forCellReuseIdentifier: OnboardingViewCell.reuseIdentifier)
    tableView.register(PurchasesCardsCell.self,
                       forCellReuseIdentifier: PurchasesCardsCell.reuseIdentifier)
    tableView.register(CustomPaddingCell.self,
                       forCellReuseIdentifier: CustomPaddingCell.reuseIdentifier)
    tableView.register(DividerTableViewCell.self,
                       forCellReuseIdentifier: DividerTableViewCell.reuseIdentifier)
    
    tableView.separatorStyle = .none
  }
}

// MARK: - UITableViewDelegate

extension PremiumScreenView: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension PremiumScreenView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = models[indexPath.row]
    var viewCell = UITableViewCell()
    
    switch model {
    case let .onboardingPage(model):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: OnboardingViewCell.reuseIdentifier
      ) as? OnboardingViewCell {
        cell.configureCellWith(model)
        viewCell = cell
      }
    case let .purchasesCards(model):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: PurchasesCardsCell.reuseIdentifier
      ) as? PurchasesCardsCell {
        cell.configureCellWith(models: model)
        viewCell = cell
      }
    case let .padding(height):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: CustomPaddingCell.reuseIdentifier
      ) as? CustomPaddingCell {
        cell.configureCellWith(height: height)
        viewCell = cell
      }
    case .divider:
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: DividerTableViewCell.reuseIdentifier
      ) as? DividerTableViewCell {
        viewCell = cell
      }
    }
    return viewCell
  }
}

// MARK: - Appearance

private extension PremiumScreenView {
  struct Appearance {
    let defaultInset: CGFloat = 16
    
    let termsConditions = NSLocalizedString("Условия", comment: "")
    let andTitle = NSLocalizedString("и", comment: "")
    let privacyPolicy = NSLocalizedString("Политика конфиденциальности", comment: "")
    
    let buyTitle = NSLocalizedString("Купить", comment: "")
    let restoreTitle = NSLocalizedString("Восстановить", comment: "")
    let subscribeTitle = NSLocalizedString("Подписаться", comment: "")
    
    let termsAndConditionsLink = "https://sosinvitalii.com/terms-conditions"
    let privacyPolicyLink = "https://sosinvitalii.com/privacy-policy"
  }
}
