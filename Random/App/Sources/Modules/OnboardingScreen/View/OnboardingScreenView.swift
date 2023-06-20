//
//  OnboardingScreenView.swift
//  Random
//
//  Created by Artem Pavlov on 17.06.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol OnboardingScreenViewOutput: AnyObject {

  /// Страница онбординга была изменена
  func didChangeOnboardingPage()

}

/// События которые отправляем от Presenter ко View
protocol OnboardingScreenViewInput {

  /// Обновить контент
  ///  - Parameter models: Массив моделек
  func updateContentWith(models: [OnboardingScreenModel])
}

/// Псевдоним протокола UIView & OnboardingScreenViewInput
typealias OnboardingScreenViewProtocol = UIView & OnboardingScreenViewInput

/// View для экрана
final class OnboardingScreenView: OnboardingScreenViewProtocol {

  // MARK: - Internal properties
  
  weak var output: OnboardingScreenViewOutput?
  
  // MARK: - Private properties

  private let tableView = TableView()
  private var models: [OnboardingScreenModel] = []

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

  func updateContentWith(models: [OnboardingScreenModel]) {
    self.models = models
    tableView.reloadData()
  }
}

// MARK: - Private

private extension OnboardingScreenView {
  func configureLayout() {
    let appearance = Appearance()

    [tableView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }

    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
      tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func applyDefaultBehavior() {
    let appearance = Appearance()
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
    tableView.backgroundColor = RandomColor.darkAndLightTheme.primaryWhite

    tableView.delegate = self
    tableView.dataSource = self
    tableView.showsVerticalScrollIndicator = false

    tableView.register(OnboardingViewCell.self,
                       forCellReuseIdentifier: OnboardingViewCell.reuseIdentifier)
  }
}

// MARK: - UITableViewDelegate

extension OnboardingScreenView: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension OnboardingScreenView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    models.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let appearance = Appearance()
    let model = models[indexPath.row]
    var viewCell = UITableViewCell()
    
    switch model {
    case let .onboardingPage(models):
      if let cell = tableView.dequeueReusableCell(
        withIdentifier: OnboardingViewCell.reuseIdentifier
      ) as? OnboardingViewCell {
        cell.configureCellWith(
          OnboardingViewModel(
            pageModels: models,
            didChangePageAction: { [weak self] _ in
              self?.output?.didChangeOnboardingPage()
            })
        )
        viewCell = cell
      }
    }
    return viewCell
  }
}

// MARK: - Appearance

private extension OnboardingScreenView {
  struct Appearance {}
}
